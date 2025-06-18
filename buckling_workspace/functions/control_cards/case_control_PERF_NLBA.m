function case_control_PERF_NLBA(FID,SubCaseID1,StepID1,ANALYSIS_TYPE,NLSTEP_STEP_ID,NLSTEP_METHOD_ID,SORT_TYPE)
t=now; d = datetime(t,'ConvertFrom','datenum');
fprintf(FID,'$\n');
fprintf(FID,'$ CASE CONTROL COMMAND SECTION\n');
fprintf(FID,'$ Direct Text Input for this Subcase\n'); 
fprintf(FID,'TITLE = MSC.Nastran job created on %s\n',d);
fprintf(FID,'$\n');
%% SUBCASE I ; first use linear buckling analysis;
fprintf(FID,'SUBCASE %s\n',num2str(SubCaseID1));% SUBCASE ID
fprintf(FID,'$ Direct Text Input for this Subcase\n'); 
%% STEP 1 : NLBUCK // NON LINEAR BUCKLING 
fprintf(FID,' STEP %s\n',num2str(StepID1));% STEP ID : Delimits and identifies a nonlinear analysis step for SOL 400 

fprintf(FID,'   LABEL = NON LINEAR BUCKLING \n');
% fprintf(FID,'   SUBTITLE=Default\n');
fprintf(FID,'   NLSTEP = %s\n',num2str(NLSTEP_STEP_ID)); % NLSTEP ID
fprintf(FID,'   METHOD=%d\n',NLSTEP_METHOD_ID);
fprintf(FID,'   %s =  ALL\n',ANALYSIS_TYPE); % ANALYSIS TYPE
fprintf(FID,'   SPC = 2\n'); %SPC ID 
fprintf(FID,'   LOAD = 2\n'); %LOAD ID
% fprintf(FID,'   DISPLACEMENT(PRINT,PLOT,%s,REAL)=%s\n',SORT_TYPE,num2str(SET_ID)); % SORT2 : outputs results for all load steps for each grid points
% fprintf(FID,'   SPCFORCES(PRINT,PLOT,%s,REAL)=%\ns',SORT_TYPE,num2str(SET_ID));
% fprintf(FID,'   OLOAD(PRINT,PLOT,%s,REAL)=%s\n',SORT_TYPE,num2str(SET_ID));

fprintf(FID,'$\n');

end

