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
config = cfg_nonlinear_buck_imperf();  % must be defined separately

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
    temp_dir = fullfile(outdir_base, sprintf('tmp_sample_%06d', itk));
    mkdir_if_missing(temp_dir);
    cd(temp_dir);

    % === Generate input for SOL 105 ===
    MAT_PROP_FUNC_1(config.matprop1, mat_props);
    MAT_PROP_FUNC_2(config.matprop2, ply_props);
    LOADS_FUNC(config.load_file_perf, config.applied_force_perf);

    % === Copy and run SOL 105 ===
    bdf_105_path = fullfile(repo_root, config.bdf_file_perfect);
    [~, bdf_name_105, ext] = fileparts(bdf_105_path);
    bdf_file_105 = [bdf_name_105, ext];
    copyfile(bdf_105_path, bdf_file_105);

    cmd105 = sprintf('%s %s scr=yes old=no delete=f04,log,xdb', ...
        config.nastran_cmd, bdf_file_105);
    fprintf('[INFO] Running SOL 105...\n');
    system(cmd105);
    check_nastran_status(bdf_file_105, config.simulation_timeout105);

    % === Save F06 and OP2 from SOL 105 ===
    f06_file_105 = [bdf_name_105, '.f06'];
    op2_file_105 =  [bdf_name_105, '.op2'];

    move_if_exists(f06_file_105, fullfile(dir_f06_perf, sprintf('sample_%06d.f06', itk)));
    move_if_exists(op2_file_105, fullfile(dir_op2_perf, sprintf('sample_%06d.op2', itk)));

    % === Read eigenvalue from f06 ===
    f06_path = fullfile(dir_f06_perf, sprintf('sample_%06d.f06', itk));
    if isfile(f06_path)
        eig_vals = read_fo6_PERF_LBA_SOL_105(f06_path, config.nmodes_perf, config.hline_perf);
        Pcr = eig_vals(1) * config.applied_force_perf;
        fprintf('[INFO] Critical eigenvalue (Pcr): %.6f\n', Pcr);
    else
        warning('[WARN] Missing .f06 file for sample %d, skipping.\n', itk);
        continue;
    end

    %% === Setup and run SOL 400 (nonlinear, imperf) ===
    sol400_dir = fullfile(temp_dir, 'tmp_SOL400');
    mkdir_if_missing(sol400_dir);
    cd(sol400_dir);

    % Copy dependencies, op2 files, mat props etc... into the working dir
    op2_file_moved_path = fullfile(dir_op2_perf, sprintf('sample_%06d.op2', itk));
    copyfile(op2_file_moved_path, fullfile(sol400_dir, op2_file_105));


    copyfile(fullfile(temp_dir, config.matprop1), config.matprop1);
    copyfile(fullfile(temp_dir, config.matprop2), config.matprop2);

    % Generate imperfection input for nonlinear analysis
    SOL_400_IMPF_NLBA_FUNC_MAIN(sf_value,op2_file_105,config.impf_main_file);

    % Load file for nonlinear SOL 400
    if isnan(config.applied_force_imperf)
        LOADS_FUNC(config.load_file_impperf, Pcr);
    else
        LOADS_FUNC(config.load_file_impperf, config.applied_force_imperf);
    end

    % Run SOL 400 (nonlinear imperfect)
    bdf_400_path = fullfile(repo_root, config.bdf_file_imperfect);
    [~, bdf_name_400, ext] = fileparts(bdf_400_path);
    bdf_file_400 = [bdf_name_400, ext];
    copyfile(bdf_400_path, bdf_file_400);

    cmd400 = sprintf('%s %s scr=yes old=no delete=f04,log,xdb', ...
        config.nastran_cmd, bdf_file_400);
    fprintf('[INFO] Running SOL 400 (nonlinear imperfect)...\n');
    system(cmd400);
    check_nastran_status(bdf_file_400, config.simulation_timeout400);

    % Save outputs
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
        cleanup_dir(temp_dir);
    end

    toc;
end
