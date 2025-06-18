clc; clear; close all;

% === Get repo root ===
this_file = fileparts(fileparts(mfilename('fullpath')));
repo_root = fileparts(this_file);
fprintf('[INFO] Repo root detected: %s\n', repo_root);

% === Add path dependencies ===
addpath(genpath(fullfile(repo_root, 'functions')));
addpath(genpath(fullfile(repo_root, 'configs')));
addpath(genpath(fullfile(repo_root, 'scripts')));
% addpath(genpath(fullfile(repo_root, 'scripts', 'solvers')));
% addpath(genpath(fullfile(repo_root, 'scripts', 'postprocessing')));

% === Load configuration ===
config = linear_buck_imperf();

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

% === Iterate over samples ===
for itk = config.sample_start:config.sample_end
    fprintf('\n[INFO] ========== SAMPLE %d ==========\n', itk);
    tic;

    %% === Extract material data ===
    mat_props = SAMPBANK.SAMPBANK_SFMAX_2E1_1E2_25D.ORG_SAMP(itk, 1:4);
    ply_props = SAMPBANK.SAMPBANK_SFMAX_2E1_1E2_25D.ORG_SAMP(itk, 5:24);
    sf_value  = SAMPBANK.SAMPBANK_SFMAX_2E1_1E2_25D.ORG_SAMP(itk, 25);

    %% === Create temp working dir ===
    temp_dir = fullfile(outdir_base, sprintf('tmp_sample_%04d', itk));
    mkdir_if_missing(temp_dir);
    cd(temp_dir);

    %% === Run SOL 105 ===
    MAT_PROP_FUNC_1(mat_props);
    MAT_PROP_FUNC_2(ply_props);
    LOADS_FUNC(config.applied_force, config.load_file);

    bdf_file_105 = 'BDF_PERFECT_LBA_SOL_105.bdf';
    copyfile(fullfile(repo_root, config.bdf_file_perfect), bdf_file_105);

    cmd105 = sprintf('%s %s scr=yes old=no delete=f04,xdb', ...
        config.nastran_cmd, bdf_file_105);
    fprintf('[INFO] Running SOL 105...\n');
    system(cmd105);
    check_nastran_status(bdf_file_105, config.simulation_timeout105);

    %% === Save F06 and OP2 from SOL 105 ===
    f06_file_105 = 'BDF_PERFECT_LBA_SOL_105.f06';
    op2_file_105 = 'BDF_PERFECT_LBA_SOL_105.op2';

    move_if_exists(f06_file_105, fullfile(dir_f06_perf, sprintf('sample_%04d.f06', itk)));
    move_if_exists(op2_file_105, fullfile(dir_op2_perf, sprintf('sample_%04d.op2', itk)));

    %% === Read eigenvalue from .f06 ===
    eig_path = fullfile(dir_f06_perf, sprintf('sample_%04d.f06', itk));
    if isfile(eig_path)
        eig_array = read_fo6_PERF_LBA_SOL_105(eig_path, config.nmodes_perf, config.hline_perf);
        Pcr = eig_array(1) * config.applied_force;
        fprintf('[INFO] Critical eigenvalue (Pcr) = %.4f\n', Pcr);
    else
        warning('[WARN] Missing .f06 file, skipping sample %d\n', itk);
        continue;
    end

    %% === Copy files to SOL400 dir ===
    sol400_dir = fullfile(temp_dir, 'SOL400');
    mkdir_if_missing(sol400_dir);

    %% Rename .op2 as expected by downstream processing
    op2_input_file = 'BDF_PERFECT_LBA_SOL_105.op2';
    op2_file_moved_path = fullfile(dir_op2_perf, sprintf('sample_%04d.op2', itk));
    copyfile(op2_file_moved_path, fullfile(sol400_dir, op2_input_file));
    copyfile('INCLUDE_COMPOSITE_MAT_PROP1.dat', fullfile(sol400_dir, 'INCLUDE_COMPOSITE_MAT_PROP1.dat'));
    copyfile('INCLUDE_COMPOSITE_MAT_PROP2.dat', fullfile(sol400_dir, 'INCLUDE_COMPOSITE_MAT_PROP2.dat'));

    cd(sol400_dir);

    %% === Generate SOL 400 input (.dat) ===
    impf_dat_file = 'INCLUDE_IMPF_LBA_MAIN.dat';
    SOL_400_IMPF_LBA_FUNC_MAIN(sf_value, op2_input_file, impf_dat_file);

    %% === Generate new load file based on Pcr ===
    LOADS_FUNC(Pcr, 'INCLUDE_LOAD_APPLIED_LBA_IMPF.dat');

    %% === Run SOL 400 ===
    bdf_file_400 = 'BDF_IMPERFECT_LINEAR_SOL_400.bdf';
    copyfile(fullfile(repo_root, config.bdf_file_imperfect), bdf_file_400);

    cmd400 = sprintf('%s %s scr=yes old=no delete=f04,xdb', ...
        config.nastran_cmd, bdf_file_400);
    fprintf('[INFO] Running SOL 400...\n');
    system(cmd400);
    check_nastran_status(bdf_file_400, config.simulation_timeout400);


    %% === Save F06 and optionally OP2 from SOL 400 ===
    f06_file_400 = 'BDF_IMPERFECT_LINEAR_SOL_400.f06';
    op2_file_400 = 'BDF_IMPERFECT_LINEAR_SOL_400.op2';

    move_if_exists(f06_file_400, fullfile(dir_f06_impf, sprintf('sample_%04d.f06', itk)));

    if config.save_op2_imperfect
        move_if_exists(op2_file_400, fullfile(dir_op2_impf, sprintf('sample_%04d.op2', itk)));
    end

    cd(repo_root);
    if config.delete_temp
        try
            rmdir(temp_dir, 's');
            fprintf('[INFO] Deleted temp directory: %s\n', temp_dir);
        catch
            warning('[WARN] Could not delete temp dir for sample %d', itk);
        end
    end

    toc;
end

% === Utility functions ===
function mkdir_if_missing(dir_path)
    if ~exist(dir_path, 'dir')
        mkdir(dir_path);
    end
end

function move_if_exists(src, dst)
    if isfile(src)
        movefile(src, dst);
        fprintf('[INFO] Saved file: %s\n', dst);
    else
        warning('[WARN] File not found: %s\n', src);
    end
end
