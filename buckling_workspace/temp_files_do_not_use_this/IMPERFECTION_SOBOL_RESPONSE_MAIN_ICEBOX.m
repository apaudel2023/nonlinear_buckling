%% This code is to run buckling analysis of a cylinder with following cases
%  A: Linear Buckling Analysis with Perfect Geometry
%  B: Non-Linear Buckling Analysis with Perfect Geometry
%  C: Linear Buckling Analysis with Geometric Imperfection
%  D: Non-LInear Buckling Analysis with Geometric Imperfection
% Author : Achyut Paudel
% Last Update : 08/19/2022
%%
clc; clear all; close all;
load('SAMPBANK_SFMAX_2E1_1E2_25D.mat', 'SAMPBANK_SFMAX_2E1_1E2_25D')

%%
NASTRAN_FILEPATH = 'nast20210';
% NASTRAN_FILEPATH = 'C:\"Program Files"\MSC.Software\MSC_Nastran\2021\bin\nastranw.exe';

% result_file_path = '/home/apaudel/IMPERFECTION/CASE_III_UNCERTAIN_IMPERF_MATPROP/RESULT_FILES_CASE_III_SAMP_7001';
% delete *.dat *.f06 *.op2 *.pch *.sts *.f04 *.plt *.bat *.rcf *.aeso *.asm
% countItr = 0;
for ITK = 1:100
    tic;
    %     countItr = countItr+1;
    delete *.dat  *.op2 *.pch *.sts *.f04 *.plt *.bat *.rcf *.aeso *.asm
    %% STEP 1 : PERFECT LINEAR BUCKLING ANALYSIS (PERF_LBA) : SOL_105
    SAMP = ITK ;
    % change material properties : Elastic constants, ply thickness and % orientation
    Fapp = 275E3; % kN

    LOAD_FILENAME1 = 'INCLUDE_LOAD_APPLIED_LBA_PERF.dat';
    LOADS_FUNC(Fapp,LOAD_FILENAME1) % modify the applied load for NLBA

    MATPROP = SAMPBANK_SFMAX_2E1_1E2_25D.ORG_SAMP(SAMP,1:4);
    PLYPROP = SAMPBANK_SFMAX_2E1_1E2_25D.ORG_SAMP(SAMP,5:24);
    MAT_PROP_FUNC_1(MATPROP) % modifies material properties
    MAT_PROP_FUNC_2(PLYPROP) % modifies ply thicknesses and orientations



    %% MAIN BDF FILE

    if isfile('BDF_PERFECT_LBA_SOL_105.bdf')
        fprintf('File exists!!!\n')
        NASTRAN_MAIN_BDF_LINEAR_PERF_SOL_105='BDF_PERFECT_LBA_SOL_105.bdf';
    else
        error('BDF file not found !!!')
    end

    matlab2nastran=strcat([NASTRAN_FILEPATH, ' ', NASTRAN_MAIN_BDF_LINEAR_PERF_SOL_105, ' ', 'scr=yes old=no delete=f04,log,xdb']);
    fprintf('Nastran Running: PERFECT_LINEAR_SOL_105 : Sample - %d \n',SAMP);
    system(matlab2nastran); % run nastran
    pause(25);    % wait until the simulation is completed using PID

    %% read the eigenvalues from linear buckling analysis
    tic
    F06_PERFECT_LINEAR_SOL_105 = [extractBefore(NASTRAN_MAIN_BDF_LINEAR_PERF_SOL_105,'bdf') 'f06'];

    dval_105 = dir(F06_PERFECT_LINEAR_SOL_105);

    if dval_105.bytes*1e-3 <20
        system(matlab2nastran); % run nastran
        fprintf('********** Rerunning Nastran :PERF-LBA ***************\n')
        pause(40);
    end

    NDmodes_PERF_LBA = 10;
    hline_PERF_LBA_105 = 450;

    try
        EIGENVAL_LBA_PERF = read_fo6_PERF_LBA_SOL_105(F06_PERFECT_LINEAR_SOL_105,NDmodes_PERF_LBA,hline_PERF_LBA_105);
    catch
        warning('Problem in reading F06 ');
        warning('Attempting to read agian ! ');
        pause(0.5);
        EIGENVAL_LBA_PERF = read_fo6_PERF_LBA_SOL_105(F06_PERFECT_LINEAR_SOL_105,NDmodes_PERF_LBA,hline_PERF_LBA_105);
    end

    %     LBA_PERFECT_RESULT(countItr,:) = [SAMP EIGENVAL_LBA_PERF(1)]

    %% rename result file and move it to result directory

    currFileName_PERFECT_LBA = F06_PERFECT_LINEAR_SOL_105;
    filenameNew105 = sprintf('SAMP_%d_PERFECT_LBA_.f06', SAMP);
    destination105 = fullfile('/home/apaudel/IMPERFECTION/IMPERFECTION_JOURNAL_II_FEA_RESPONSE_SF_2E1_1E2/F06_RESULT_FILES',filenameNew105); % for ice box
    %     destination105 = fullfile('D:\JOURNAL_2\JOURNAL_2_APPLICATION_PROBLEM_IMPERFECTION\F06_RESULT_FILES',filenameNew105); % for ice box
    source105 = currFileName_PERFECT_LBA;
    pause(0.5);
    movefile(source105,destination105);
    pause(0.5);
    toc1 = toc;
    %% STEP 2 : PERFECT NON-LINEAR BUCKLING ANALYSIS (PERF_NLBA) : SOL_400
    % obtain the Pcritical and use the modified load for non-linear case
    %     Fcr1 = EIGENVAL_LBA_PERF(1)*Fapp; % calculate the Pcritical based on LBA
    %     LOAD_FILENAME1 = 'INCLUDE_LOAD_APPLIED_PERF_NLBA.dat';
    %     LOADS_FUNC(Fcr1,LOAD_FILENAME1) % modify the applied load for perfect NLBA
    %     PERF_FILE_NAME_NLBA = 'INCLUDE_PERF_NLBA_MAIN.dat';
    %     SOL_400_PERF_NLBA_FUNC_MAIN(PERF_FILE_NAME_NLBA);
    %
    %     NASTRAN_MAIN_BDF_NON_LINEAR_PERF_SOL_400='BDF_PERFECT_NON_LINEAR_SOL_400.bdf';  %% MAIN BDF FILE
    %     matlab2nastran=strcat([NASTRAN_FILEPATH, ' ', NASTRAN_MAIN_BDF_NON_LINEAR_PERF_SOL_400, ' ', 'scr=yes old=no delete=f04,log,xdb']);
    %     fprintf('Nastran Running: PERFECT_NON_LINEAR_SOL_400 : Sample - %d \n',SAMP);
    %
    %     system(matlab2nastran); % run nastran
    %     pause(200); %%
    %
    %     tic;
    %     while(1)
    %         fval = dir('*BDF_PERFECT_NON_LINEAR_SOL_400.f06');
    %         fsize = fval.bytes * 1e-3;
    %         if fsize >=750
    %
    %             fprintf('Simulation Complete\n')
    %             break;
    %         else
    %             pause(60);
    %         end
    %
    %         t2val = toc;
    %
    %         if mod(t2val,600)>=0
    %            fprintf('Time take = %0.2f\n',t2val)
    %         end
    %
    %     end

    %% rename result file and move it to result directory
    %     currFileName_PERFECT_NLBA = [extractBefore(NASTRAN_MAIN_BDF_NON_LINEAR_PERF_SOL_400,'bdf') 'f06'];
    %
    %      dval_105 = dir(currFileName_PERFECT_NLBA);
    %
    %     if dval_105.bytes*1e-3 <50
    %         system(matlab2nastran); % run nastran
    %         fprintf('********** Rerunning Nastran :PERF-NLBA ***************\n')
    %         pause(6600);
    %     else
    %         pause(6400);
    %     end


    %
    %     filenameNew105 = sprintf('SAMP_%d_PERFECT_NLBA_.f06', SAMP);
    %     destination105 = fullfile('/home/apaudel/IMPERFECTION/IMPERFECTION_JOURNAL_II_FEA_RESPONSE_SF_2E1_1E2/F06_RESULT_FILES',filenameNew105); % for ice box
    %     %     destination105 = fullfile('D:\JOURNAL_2\JOURNAL_2_APPLICATION_PROBLEM_IMPERFECTION\F06_RESULT_FILES',filenameNew105); % for ice box
    %     source105 = currFileName_PERFECT_NLBA;
    %     pause(0.5);
    %     movefile(source105,destination105);
    %     pause(0.5);

    %     toc2 = toc;
    %     fprintf('Time taken for PERFECT NLBA = %0.2f min\n',(toc2-toc1)/60)
    %% STEP 3 : IMPERFECT LINEAR BUCKLING ANALYSIS (IMPF_LBA) : SOL_400
    SF = SAMPBANK_SFMAX_2E1_1E2_25D.ORG_SAMP(SAMP,25); % Scaling Factor for Imperfection
    PRE_RUN_FILE_NAME = [extractBefore(NASTRAN_MAIN_BDF_LINEAR_PERF_SOL_105,'bdf') 'op2']; % solution form LBA : to be imported in main bdf file for imperfection
    IMPF_FILE_NAME_LBA = 'INCLUDE_IMPF_LBA_MAIN.dat';
    LOAD_FILENAME3 = 'INCLUDE_LOAD_APPLIED_LBA_IMPF.dat';
    LOADS_FUNC(Fapp,LOAD_FILENAME3) % modify the applied load for NLBA
    SOL_400_IMPF_LBA_FUNC_MAIN(SF,PRE_RUN_FILE_NAME,IMPF_FILE_NAME_LBA)

    if isfile('BDF_IMPERFECT_LINEAR_SOL_400.bdf')
        fprintf('BDF File exists!!!\n')
        NASTRAN_MAIN_BDF_LINEAR_IMPF_SOL_400='BDF_IMPERFECT_LINEAR_SOL_400.bdf';  %% MAIN BDF FILE
    else
        error('BDF file not found !!!')
    end

    matlab2nastran=strcat([NASTRAN_FILEPATH, ' ', NASTRAN_MAIN_BDF_LINEAR_IMPF_SOL_400, ' ', 'scr=yes old=no delete=f04,log,xdb']);
    fprintf('Nastran Running: IMPERFECT_LINEAR_SOL_400 : Sample - %d \n',SAMP);

    system(matlab2nastran);
    pause(270);


    %% rename result file and move it to result directory
    currFileName_IMPERFECT_LBA = [extractBefore(NASTRAN_MAIN_BDF_LINEAR_IMPF_SOL_400,'bdf') 'f06'];

    dval_105_impf = dir(currFileName_IMPERFECT_LBA);

    if dval_105_impf.bytes*1e-3 <20
        system(matlab2nastran); % run nastran
        fprintf('********** Rerunning Nastran :IMRF-LBA ***************\n')
        pause(300);
    end


    filenameNew105 = sprintf('SAMP_%d_IMPERFECT_LBA_.f06', SAMP);
    destination105 = fullfile('/home/apaudel/IMPERFECTION/IMPERFECTION_JOURNAL_II_FEA_RESPONSE_SF_2E1_1E2/F06_RESULT_FILES',filenameNew105); % for ice box
    %     destination105 = fullfile('D:\JOURNAL_2\JOURNAL_2_APPLICATION_PROBLEM_IMPERFECTION\F06_RESULT_FILES',filenameNew105); % for ice box

    source105 = currFileName_IMPERFECT_LBA;
    pause(0.5);
    movefile(source105,destination105);
    pause(0.5);

    toc3 = toc;


    %% STEP 4 :  IMPERFECT NON-LINEAR BUCKLING ANALYSIS (IMPF_NLBA) : SOL_400

    Fcr_lba = EIGENVAL_LBA_PERF(1)*Fapp; % calculate the Pcritical based on LBA
    LOAD_FILENAME2 = 'INCLUDE_LOAD_APPLIED_NLBA_IMPF.dat';
    LOADS_FUNC(Fcr_lba,LOAD_FILENAME2) % modify the applied load for NLBA
    IMPF_FILE_NAME_NLBA = 'INCLUDE_IMPF_NLBA_MAIN.dat';
    SOL_400_IMPF_NLBA_FUNC_MAIN(SF,IMPF_FILE_NAME_NLBA)

    PRE_RUN_FILE_NAME = [extractBefore(NASTRAN_MAIN_BDF_LINEAR_PERF_SOL_105,'bdf') 'op2']; % solution form LBA : to be imported in main bdf file for imperfection
    SOL_400_NONLINEAR_BUCK_FUNC_MAIN(SF,PRE_RUN_FILE_NAME,IMPF_FILE_NAME_NLBA)


    if isfile('BDF_IMPERFECT_NON_LINEAR_SOL_400.bdf')
        fprintf('BDF File exists!!!\n')
        NASTRAN_MAIN_BDF_NON_LINEAR_IMPF_SOL_400='BDF_IMPERFECT_NON_LINEAR_SOL_400.bdf';  %% MAIN BDF FILE
    else
        error('BDF file not found !!!')
    end

    matlab2nastran=strcat([NASTRAN_FILEPATH,' ', NASTRAN_MAIN_BDF_NON_LINEAR_IMPF_SOL_400, ' ', 'scr=yes old=no delete=f04,log,xdb']);
    fprintf('Nastran Running: IMPERFECT_NON_LINEAR_SOL_400 : Sample - %d \n',SAMP);

    system(matlab2nastran);
    pause(6000);


    %% rename result file and move it to result directory

    currFileName_IMPERFECT_NLBA = [extractBefore(NASTRAN_MAIN_BDF_NON_LINEAR_IMPF_SOL_400,'bdf') 'f06'];

    dval_400_impf_nlba = dir(currFileName_IMPERFECT_NLBA);

    if dval_400_impf_nlba.bytes*1e-3 <500
        system(matlab2nastran); % run nastran
        fprintf('********** Rerunning Nastran :IMPF-NLBA ***************\n')
        pause(6000);
    end


    filenameNew105 = sprintf('SAMP_%d_IMPERFECT_NLBA_.f06', SAMP);
    destination105 = fullfile('/home/apaudel/IMPERFECTION/IMPERFECTION_JOURNAL_II_FEA_RESPONSE_SF_2E1_1E2/F06_RESULT_FILES',filenameNew105); % for ice box
    source105 = currFileName_IMPERFECT_NLBA;
    pause(0.5);
    movefile(source105,destination105);
    pause(0.5);

    fprintf('Time taken for All simulations = %0.2f hours !!! \n',toc/3600)

end