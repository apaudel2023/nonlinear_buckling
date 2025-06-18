function config = cfg_linear_buck_imperf()

% Configuration for Imperfect Linear Buckling Analysis 

config = struct();

% Sample range
config.sample_start = 1;
config.sample_end = 2;

%% Paths
% sample path
config.sample_bank_path = fullfile('samples', 'SAMPBANK_SFMAX_2E1_1E2_25D.mat');

%bdf file path:
config.bdf_file_perfect = fullfile('bdf_templates', 'BDF_PERFECT_LBA_SOL_105.bdf');
config.bdf_file_imperfect = fullfile('bdf_templates', 'BDF_IMPERFECT_LINEAR_SOL_400.bdf');

% filenames to be included in the bdf: Do not change this: if you change
% you must update the name iside the bdf file accordingly

config.load_file_perf = 'INCLUDE_LOAD_APPLIED_LBA_PERF.dat';
config.load_file_impperf = 'INCLUDE_LOAD_APPLIED_LBA_IMPF.dat';

config.matprop1 = 'INCLUDE_COMPOSITE_MAT_PROP1.dat';
config.matprop2 = 'INCLUDE_COMPOSITE_MAT_PROP2.dat';

config.impf_main_file = 'INCLUDE_IMPF_LBA_MAIN.dat';
% Output dir
config.output_dir = fullfile('data', 'imperfect_linear');

%% Nastran executable
% change this path accor to your machine/hpc environment
config.nastran_cmd = '"C:\Program Files\MSC.Software\MSC_Nastran\2023.4\bin\nastranw.exe"';

% Analysis control
config.applied_force_perf = 275000;
config.applied_force_imperf = NaN; %if NaN, then papplied = pcr_perfect
config.save_op2_imperfect = true;
config.delete_temp = true;

% Nastran max run time 
config.simulation_timeout105 = 200;
config.simulation_timeout400 = 300;

% Postprocessing setup
config.nmodes_perf = 10;
config.hline_perf = 350;

% Cleanup
config.delete_temp = true; % Set false if you want to inspect tmp folders

end
