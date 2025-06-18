clc; clear all; close all;
load('SOBOL_SAMPLES_5E4_CASE_III_V2.mat', 'SAMPBANK_v2')
%load('RERUN7_SAMP_CASE_III.mat', 'RERUN7_SAMP_CASE_III')
load('MEANPOOL_CASE_III.mat', 'MEANPOOL_CASE_III')
%% SOL 400

PRE_RUN_FILE_NAME = 'CYLIINDER_REF_DLR_SOL_105.op2';

% NASTRAN_FILEPATH = 'nast20210';
NASTRAN_FILEPATH='C:\"Program Files"\MSC.Software\MSC_Nastran\2021\bin\nastranw.exe';

for ITK = 1
    tic;
%     SAMP = ITK ;
%     MATPROP = SAMPBANK_v2.ORG_SAMP(SAMP,1:4);
%     PLYPROP = SAMPBANK_v2.ORG_SAMP(SAMP,5:24);
% % % % %     
    MATPROP = MEANPOOL_CASE_III(1:4);
    PLYPROP = MEANPOOL_CASE_III(5:24);
    %     SF = SAMPBANK_v2.ORG_SAMP(SAMP,25);
    SF = MEANPOOL_CASE_III(end);
    %% STEP 1 : RUN SOL 105 WITH UNCERTAINTIES IN MAT PROP/ PLY PROP; GET .OP2 FILE WITH MODE SHAPES
    
    MAT_PROP_FUNC_1(MATPROP)
    MAT_PROP_FUNC_2(PLYPROP)
% % % % % %     fprintf('Sample - %d \n',SAMP);
% % % % %     fprintf('Running SOL 105\n');
% % % % %     
% % % % %     NASTRAN_MAIN_BDF_FILE_SOL105='CYLIINDER_REF_DLR_SOL_105.bdf';  %% MAIN BDF FILE
% % % % %     matlab2nastran=strcat([NASTRAN_FILEPATH, ' ', NASTRAN_MAIN_BDF_FILE_SOL105, ' ', 'scr=yes old=no delete=f04,log,xdb']);
% % % % %     system(matlab2nastran);
% % % % %     pause(40);
    
% % %     currFileName105 = 'CYLIINDER_REF_DLR_SOL_105.f06';
% % %     
% % %     while(1)
% % %         dval = dir(currFileName105);
% % %         if dval.bytes*1e-6 <43
% % %             fprintf('Simulation running  -- SOL 105')
% % %             pause(15)
% % %         else
% % %             pause(5)
% % %             fprintf('Simulation complete -- SOL 105')
% % %             break;
% % %         end
% % %     end
% % % 
% % %     currFileName105 = 'CYLIINDER_REF_DLR_SOL_105.f06';
% % %     
% % %     %     currFileName105='cyliinder_ref_dlr_sol_105.f06';
% % %     filenameNew105 = sprintf('CASE_III_SOL_105_SAMP_%d_.f06', SAMP);
% % %     destination105 = fullfile('/home/apaudel/IMPERFECTION/CASE_III_UNCERTAIN_IMPERF_MATPROP/RESULT_FILES_CASE_III_SAMP_7001_',filenameNew105); % for ice box
% % %     source105 = currFileName105;
% % %     pause(0.5);
% % %     movefile(source105,destination105);
% % %     pause(0.5);
% % %     t105 = toc; 
% % %     fprintf('Time taken for SOL 105 = %0.2f min\n',t105/60)

    %% STEP 2 RUN SOL 400 WITH UNCERTAITIES IN SCALING FACTOR
    tic;
    pause(1);
    currentPath = pwd;
    
    PRE_RUN_FILE_NAME = 'CYLIINDER_REF_DLR_SOL_105.op2';
    %     SOL_400_NONLINEAR_BUCK_FUNC_MAIN(SAMPBANK_v2.ORG_SAMP(SAMP,25),PRE_RUN_FILE_NAME)
    SOL_400_NONLINEAR_BUCK_FUNC_MAIN(SF,PRE_RUN_FILE_NAME)
    
    % NASTRAN_MAIN_BDF_FILE='CYLIINDER_REF_DLR_SOL_400.bdf';  %% MAIN BDF FILE
    
   
%     copyfile(PRE_RUN_FILE_NAME,fullfile(pwd,'/SOL400',PRE_RUN_FILE_NAME));
    copyfile('COMPOSITE_MAT_PROP1.dat',fullfile(pwd,'/SOL400','COMPOSITE_MAT_PROP1.dat'));
    copyfile('COMPOSITE_MAT_PROP2.dat',fullfile(pwd,'/SOL400','COMPOSITE_MAT_PROP2.dat'));
    copyfile('IMP_CYLINDER_SOL400.dat',fullfile(pwd,'/SOL400','IMP_CYLINDER_SOL400.dat'));
% % %     
    cd 'SOL400'
    NASTRAN_MAIN_BDF_FILE_SOL400='CYLIINDER_REF_DLR_SOL_400_CASE_III.bdf';  %% MAIN BDF FILE
    matlab2nastran=strcat([NASTRAN_FILEPATH, ' ', NASTRAN_MAIN_BDF_FILE_SOL400, ' ', 'scr=yes old=no delete=f04,log,xdb']);
    fprintf('Simulation running  -- SOL 400')
    
    system(matlab2nastran);
% %     pause(60);
% %     
% %     currFileName400 = 'CYLIINDER_REF_DLR_SOL_400_CASE_III.f06';
% %     
% %     while(1)
% %         dirval = dir('*.f06') ;
% %         sizeval = dirval.bytes * 1e-6;
% %         if sizeval < 46
% %             pause(15);
% %         else
% %             pause(10);
% %             break;
% %         end
% %     end
% %     
% %     fprintf('Simulation complete  -- SOL 400')
% %     filenameNew400 = sprintf('CASE_III_SOL_400_SAMP_%d_.f06', SAMP);
% %  
% %     destination400 = fullfile('/home/apaudel/IMPERFECTION/CASE_III_UNCERTAIN_IMPERF_MATPROP/RESULT_FILES_CASE_III_SAMP_7001_',filenameNew400); % for ice box
% %     source400 = currFileName400;
% %     pause(0.5);
% %     movefile(source400,destination400);
% %     pause(0.5);
% %     delete('*.dat')
% %     delete('*.op2')
    
% %     cd(currentPath);
% %     
% %     fclose('all');
% %     
% %     t400= toc; 
% %     
% %     fprintf('Time taken for SOL 400 = %0.2f min\n',t400/60)
% %     fprintf('Nastran Total RunTime = %0.2f min\n',(t105+t400)/60);
    
end
% run('read_fo6_EIGENVALUES.m')




