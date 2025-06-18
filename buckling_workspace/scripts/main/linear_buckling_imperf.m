clc; clear; close all;

% === Get repo root ===
this_file = fileparts(fileparts(mfilename('fullpath')));
repo_root = fileparts(this_file);
fprintf('[INFO] Repo root detected: %s\n', repo_root);

% === Add path dependencies ===
addpath(genpath(fullfile(repo_root, 'functions')));
addpath(genpath(fullfile(repo_root, 'configs')));
addpath(genpath(fullfile(repo_root, 'scripts')));

% === Load configuration ===
config = cfg_linear_buck_imperf();

% === Load sample bank ===
SAMPBANK = load(fullfile(repo_root, config.sample_bank_path), '-mat');

% === Setup output directories ===
outdir_base = fullfile(repo_root, config.output_dir);
dir_f06_perf = fullfile(outdir_base, 'f06_perfect');
dir_op2_perf = fullfile(outdir_base, 'op2_perfect');
dir_f06_impf = fullfile(outdir_base, 'f06_imperfect');
dir_op2_impf = fullfile(outdir_base, 'op2_imperfect');

mkdir_if_missing(dir_f06_perf);
mkdir_if_missing(dir_op2_perf);
mkdir_if_missing(dir_f06_impf);
if config.save_op2_imperfect
    mkdir_if_missing(dir_op2_impf);
end

%% === Iterate over samples ===
for itk = config.sample_start:config.sample_end
    fprintf('\n[INFO] ========== SAMPLE %d ==========\n', itk);
    tic;

    % === Extract material data ===
    mat_props = SAMPBANK.SAMPBANK_SFMAX_2E1_1E2_25D.ORG_SAMP(itk, 1:4);
    ply_props = SAMPBANK.SAMPBANK_SFMAX_2E1_1E2_25D.ORG_SAMP(itk, 5:24);
    sf_value  = SAMPBANK.SAMPBANK_SFMAX_2E1_1E2_25D.ORG_SAMP(itk, 25);

    % === Create temp working dir ===
    temp_dir_105 = fullfile(outdir_base, sprintf('tmp_sample_%06d', itk));
    mkdir_if_missing(temp_dir_105);
    cd(temp_dir_105);

    % Create include files
    MAT_PROP_FUNC_1(config.matprop1, mat_props);
    MAT_PROP_FUNC_2(config.matprop2, ply_props);
    LOADS_FUNC(config.load_file_perf, config.applied_force_perf);

    % Copy BDF to temp dir
    bdf_105_template_path = fullfile(repo_root, config.bdf_file_perfect);
    [~, bdf_name_105, ext] = fileparts(config.bdf_file_perfect);
    bdf_file_105 = [bdf_name_105, ext];
    bdf_working_path = fullfile(temp_dir_105, bdf_file_105);
    copyfile(bdf_105_template_path, bdf_working_path);

    % Run Nastran
    if isfile(bdf_file_105)
        cmd105 = sprintf('%s %s scr=yes old=no delete=f04,log,xdb', ...
            config.nastran_cmd, bdf_file_105);
        fprintf('[INFO] Running SOL 105... perfect liner ...\n');
        fprintf('[INFO] Executing Nastran: %s\n', cmd105);
        system(cmd105);
        check_nastran_status(bdf_file_105, config.simulation_timeout105);
    else
        error('BDF file not found: %s\n', bdf_filename);
    end

    % === Save F06 and OP2 from SOL 105 ===
    f06_file_105 = [bdf_name_105, '.f06'];
    op2_file_105 =  [bdf_name_105, '.op2'];

    move_if_exists(f06_file_105, fullfile(dir_f06_perf, sprintf('sample_%06d.f06', itk)));
    move_if_exists(op2_file_105, fullfile(dir_op2_perf, sprintf('sample_%06d.op2', itk)));

    % === Read eigenvalue from .f06 ===
    eig_path = fullfile(dir_f06_perf, sprintf('sample_%06d.f06', itk));
    if isfile(eig_path)
        eig_array = read_fo6_PERF_LBA_SOL_105(eig_path, config.nmodes_perf, config.hline_perf);
        Pcr = eig_array(1) * config.applied_force_perf;
        fprintf('[INFO] Critical eigenvalue (Pcr) = %.6f\n', Pcr);
    else
        warning('[WARN] Missing .f06 file, skipping sample %d\n', itk);
        continue;
    end

    %% Prepare for SOL 400 run with imperfection 
    sol400_dir = fullfile(temp_dir_105, 'tmp_SOL400');
    mkdir_if_missing(sol400_dir);
    cd(sol400_dir);

    % === Copy files to SOL400 temp dir ===
    % Rename .op2 as expected by downstream processing and copy to working dir
    op2_file_moved_path = fullfile(dir_op2_perf, sprintf('sample_%06d.op2', itk));
    copyfile(op2_file_moved_path, fullfile(sol400_dir, op2_file_105));

    copyfile(fullfile(temp_dir_105, config.matprop1), fullfile(sol400_dir, config.matprop1));
    copyfile(fullfile(temp_dir_105, config.matprop2), fullfile(sol400_dir, config.matprop2));

    % === Generate SOL 400 input (.dat) ===
    SOL_400_IMPF_LBA_FUNC_MAIN(sf_value, op2_file_105, config.impf_main_file);

    % === Generate new load file for imperfect analysis ===
    if isnan(config.applied_force_imperf) % if not provide use pcr from linear perfect buckling
        LOADS_FUNC(config.load_file_impperf, Pcr);
    else
        LOADS_FUNC(config.load_file_impperf, config.applied_force_imperf);
    end

    % === Copy BDF file  Run SOL 400 ===
    bdf_400_template_path = fullfile(repo_root, config.bdf_file_imperfect);
    [~, bdf_name_400, ext] = fileparts(config.bdf_file_imperfect);
    bdf_file_400 = [bdf_name_400, ext];

    copyfile(bdf_400_template_path, bdf_file_400);

    cmd400 = sprintf('%s %s scr=yes old=no delete=f04,xdb', ...
        config.nastran_cmd, bdf_file_400);
    fprintf('[INFO] Running SOL 400...imperfect linear ...\n');
    fprintf('[INFO] Executing Nastran: %s\n', cmd400);
    system(cmd400);

    check_nastran_status(bdf_file_400, config.simulation_timeout400);


    % === Save output files from imperfect analhysis: F06, and optionally OP2 from SOL 400 ===
    f06_file_400 = [bdf_name_400,'.f06'];
    op2_file_400 = [bdf_name_400, '.op2'];
    f06_file_400_destination = fullfile(dir_f06_impf, sprintf('sample_%06d.f06', itk));
    op2_file_400_destination = fullfile(dir_op2_impf, sprintf('sample_%06d.op2', itk));

    move_if_exists(f06_file_400, f06_file_400_destination );
    if config.save_op2_imperfect
        move_if_exists(op2_file_400, op2_file_400_destination);
    end

    % Cleanup
    cd(repo_root);
    if config.delete_temp
        cleanup_dir(temp_dir_105);  % uses defaults: 5 retries, 2 sec pause
    end

    toc;
end
