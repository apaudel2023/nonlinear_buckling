function config = linear_buck_imperf()

% Configuration for Imperfect Linear Buckling Analysis (SOL 105 + SOL 400)

config = struct();

% Sample range
config.sample_start = 1;
config.sample_end = 5;

% Paths
config.sample_bank_path = fullfile('samples', 'SAMPBANK_SFMAX_2E1_1E2_25D.mat');
config.bdf_file_perfect = fullfile('bdf_templates', 'BDF_PERFECT_LBA_SOL_105.bdf');
config.bdf_file_imperfect = fullfile('bdf_templates', 'BDF_IMPERFECT_LINEAR_SOL_400.bdf');
config.load_file = 'INCLUDE_LOAD_APPLIED_LBA_PERF.dat';

% Output structure
config.output_dir = fullfile('data', 'imperfect_linear');

% Nastran executable
config.nastran_cmd = '"C:\Program Files\MSC.Software\MSC_Nastran\2023.4\bin\nastranw.exe"';

% Analysis control
config.applied_force = 275000;
config.save_op2_imperfect = true;
config.delete_temp = true;

% Nastran max run time 
config.simulation_timeout105 = 200;
config.simulation_timeout400 = 300;

% Postprocessing setup
config.nmodes_perf = 10;
config.hline_perf = 350;

end
