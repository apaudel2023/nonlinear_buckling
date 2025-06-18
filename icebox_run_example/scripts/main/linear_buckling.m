% scripts/main/linear_buckling.m
clc; clear; close all;

this_file = fileparts(fileparts(mfilename('fullpath')));
repo_root = fileparts(this_file);

fprintf('[INFO] Repo root detected: %s\n', repo_root);

% Add paths
addpath(genpath(fullfile(repo_root, 'functions')));
addpath(genpath(fullfile(repo_root, 'configs')));
addpath(genpath(fullfile(repo_root, 'scripts')));

% Load config
config = cfg_linear_buck_perf();

% Load samples
SAMPBANK = load(fullfile(repo_root, config.sample_bank_path), '-mat');

% Output dir
output_dir_full = fullfile(repo_root, config.output_dir);
if ~exist(output_dir_full, 'dir')
    mkdir(output_dir_full);
    fprintf('[INFO] Created output directory: %s\n', output_dir_full);
end

% Sample loop
for itk = config.sample_start:config.sample_end
    fprintf('\n[INFO] ========== SAMPLE %d ==========\n', itk);
    tic;

    % Setup temp dir
    temp_dir = fullfile(output_dir_full, sprintf('tmp_sample_%06d', itk));
    if ~exist(temp_dir, 'dir')
        mkdir(temp_dir);
        fprintf('[INFO] Created temp directory: %s\n', temp_dir);
    end

    % Copy BDF to temp dir
    bdf_template_path = fullfile(repo_root, config.bdf_file);
    [~, bdf_name, ext] = fileparts(config.bdf_file);
    bdf_filename = [bdf_name, ext];
    bdf_working_path = fullfile(temp_dir, bdf_filename);
    copyfile(bdf_template_path, bdf_working_path);

    % Change to temp directory
    old_dir = pwd;
    cd(temp_dir);

    % Get material sample
    mat_props = SAMPBANK.SAMPBANK_SFMAX_2E1_1E2_25D.ORG_SAMP(itk, 1:4);
    ply_props = SAMPBANK.SAMPBANK_SFMAX_2E1_1E2_25D.ORG_SAMP(itk, 5:24);

    % Create include files
    MAT_PROP_FUNC_1(config.matprop1, mat_props);
    MAT_PROP_FUNC_2(config.matprop2, ply_props);
    LOADS_FUNC(config.load_file, config.applied_force);

    % Run Nastran
    if isfile(bdf_filename)
        bdf_command = sprintf('%s %s scr=yes old=no delete=f04,log,xdb', ...
            config.nastran_cmd, bdf_filename);
        fprintf('[INFO] Executing Nastran: %s\n', bdf_command);
        system(bdf_command);
        check_nastran_status(bdf_filename, config.simulation_timeout105);
    else
        error('BDF file not found: %s\n', bdf_filename);
    end

    % Save f06 output
    fo6_filename = [bdf_name, '.f06'];
    out_f06 = fullfile(temp_dir, fo6_filename);
    if isfile(out_f06)
        dest_name = fullfile(output_dir_full, sprintf('sample_%06d.f06', itk));
        copyfile(out_f06, dest_name);
        fprintf('[INFO] Saved .f06 to: %s\n', dest_name);
    else
        warning('[WARN] No .f06 file generated for sample %d\n', itk);
    end

    % Cleanup
    cd(old_dir);
    if config.delete_temp
        cleanup_dir(temp_dir);  % uses defaults: 5 retries, 2 sec pause
    end

    toc;
end