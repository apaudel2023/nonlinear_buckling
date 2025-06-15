
function config = linear_buck_perf()

% configs/linear_buck_perf.m
% Configuration for Linear Buckling Analysis (Perfect Geometry)

config = struct();

% General Settings
config.sample_start = 1;
config.sample_end = 1;

% Paths (relative to repo root)
config.sample_bank_path = fullfile('samples', 'SAMPBANK_SFMAX_2E1_1E2_25D.mat');
config.result_bank_path = fullfile('samples', 'RESULT_LBA_PERF_SAMP_1_5E3_25D_SF_1E3_2E1.mat');
config.bdf_file = fullfile('bdf_templates', 'BDF_PERFECT_LBA_SOL_105.bdf');
config.load_file = 'INCLUDE_LOAD_APPLIED_LBA_PERF.dat';

% Output directory (can be absolute or relative)
config.output_dir = fullfile('data', 'linear_buckling_results');

% Nastran executable (edit for HPC or local use)
% e.g., on Windows: 'C:\Program Files\MSC.Software\MSC_Nastran\2021\bin\nastranw.exe'
% e.g., on Linux/HPC: 'nastran'
% config.nastran_cmd = 'nastran';
config.nastran_cmd = '"C:\Program Files\MSC.Software\MSC_Nastran\2023.4\bin\nastranw.exe"';
% Load application
config.applied_force = 275E3; % kN

% Delay after system call (if needed on slower machines)
config.simulation_pause = 35; % seconds


% Cleanup
config.delete_temp = true; % Set false if you want to inspect tmp folders
end