
function config = cfg_linear_buck_perf()

% configs/linear_buck_perf.m
% Configuration for Linear Buckling Analysis (Perfect Geometry)

config = struct();

% Sample range
config.sample_start = 3;
config.sample_end = 4;

%% Paths (relative to repo root)
% sample path
config.sample_bank_path = fullfile('samples', 'SAMPBANK_SFMAX_2E1_1E2_25D.mat');

%bdf file path:
config.bdf_file = fullfile('bdf_templates', 'BDF_PERFECT_LBA_SOL_105.bdf');

% filenames to be included in the bdf: Do not change this: if you change
% you must update the name iside the bdf file accordingly

config.load_file = 'INCLUDE_LOAD_APPLIED_LBA_PERF.dat';
config.matprop1 = 'INCLUDE_COMPOSITE_MAT_PROP1.dat';
config.matprop2 = 'INCLUDE_COMPOSITE_MAT_PROP2.dat';

% Output directory 
config.output_dir = fullfile('data', 'perfect_linear');

%% Nastran executable (edit for HPC or local use)
% e.g., on Windows: 'C:\Program Files\MSC.Software\MSC_Nastran\2021\bin\nastranw.exe'
% e.g., on Linux/HPC: 'nastran'
% config.nastran_cmd = 'nastran';
config.nastran_cmd = '"C:\Program Files\MSC.Software\MSC_Nastran\2023.4\bin\nastranw.exe"';

% Load application
config.applied_force = 275E3; % kN

% Delay after system call (if needed on slower machines)
config.simulation_timeout105 = 200; % seconds


% Cleanup
config.delete_temp = true; % Set false if you want to inspect tmp folders
end