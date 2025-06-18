% configs/cfg_nonlinear_buck_imperf.m

function config = cfg_nonlinear_buck_imperf()
% Configuration for Imperfect Nonlinear Buckling Analysis

config = struct();

% === Sample range ===
config.sample_start = 1;
config.sample_end = 2;

% === Paths ===
config.sample_bank_path = fullfile('samples', 'SAMPBANK_SFMAX_2E1_1E2_25D.mat');

config.bdf_file_perfect   = fullfile('bdf_templates', 'BDF_PERFECT_LBA_SOL_105.bdf');
config.bdf_file_imperfect = fullfile('bdf_templates', 'BDF_IMPERFECT_NON_LINEAR_SOL_400.bdf');

% Include files to be generated
config.load_file_perf   = 'INCLUDE_LOAD_APPLIED_LBA_PERF.dat';
config.load_file_impperf = 'INCLUDE_LOAD_APPLIED_NLBA_IMPF.dat';

config.matprop1 = 'INCLUDE_COMPOSITE_MAT_PROP1.dat';
config.matprop2 = 'INCLUDE_COMPOSITE_MAT_PROP2.dat';
config.impf_main_file = 'INCLUDE_IMPF_NLBA_MAIN.dat';

% === Output directory ===
config.output_dir = fullfile('data', 'imperfect_nonlinear');

% === Nastran path ===
% Update this path for your local/hpc setup
config.nastran_cmd = '"C:\Program Files\MSC.Software\MSC_Nastran\2023.4\bin\nastranw.exe"';

% === Force control ===
config.applied_force_perf = 275000;
config.applied_force_imperf = NaN;  % If NaN, use Pcr from perfect buckling

% === Save OP2 from SOL 400 ===
config.save_op2_imperfect = true;

% === Postprocessing setup ===
config.nmodes_perf = 10;     % number of modes to read from .f06
config.hline_perf  = 350;    % starting line for eigenvalue parsing

% === Timeouts and cleanup ===
config.simulation_timeout105 = 200;  % seconds
config.simulation_timeout400 = 5000;  % seconds
config.delete_temp = true;           % delete temp folders after run

end
