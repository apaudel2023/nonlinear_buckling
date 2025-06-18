function case_control_IMPF_NLBA(FID,SubCaseID1,StepID1,StepID2,ANALYSIS_TYPE1,ANALYSIS_TYPE2,SET_ID,NLSTEP_STEP_ID,NLSTEP_METHOD_ID,SORT_TYPE)
t=now; d = datetime(t,'ConvertFrom','datenum');
fprintf(FID,'$\n');
fprintf(FID,'$ CASE CONTROL COMMAND SECTION\n');
fprintf(FID,'$ Direct Text Input for this Subcase\n'); 
fprintf(FID,'TITLE = MSC.Nastran job created on %s\n',d);
fprintf(FID,'$\n');
fprintf(FID,'$\n');
%% SUBCASE I ; first use linear buckling analysis;

fprintf(FID,'SUBCASE %s\n',num2str(SubCaseID1));% SUBCASE ID
fprintf(FID,'$ Direct Text Input for this Subcase\n'); 

%% % % %  STEP 1 : NLSTATIC // LINEAR BUCKLING 
fprintf(FID,' STEP %s\n',num2str(StepID1));% STEP ID : Delimits and identifies a nonlinear analysis step for SOL 400 
% fprintf(FID,'   SUBTITLE=Default\n'); % Defines a subtitle that will appear on the second heading line of each page of printer output.
% fprintf(FID,'   ANALYSIS = %s\n',ANALYSIS_TYPE1); % ANALYSIS TYPE
% % fprintf(FID,'   ANALYSIS = BUCK\n'); % ANALYSIS TYPE
% % fprintf(FID,'   NLSTEP = %s\n',num2str(NLSTEP_ID)); % NLSTEP ID
% fprintf(FID,'   SPC = 2\n'); %SPC ID 
% fprintf(FID,'   LOAD = 2\n'); %LOAD ID
% % fprintf(FID,'   NLBUCK=ALL\n');
% fprintf(FID,'   METHOD=%d\n',EIGmethodID);


% % % fprintf(FID,'   DISPLACEMENT(PRINT,PLOT,%s,REAL)=%s\n',SORT_TYPE,num2str(SET_ID)); % SORT2 : outputs results for all load steps for each grid points
% % % fprintf(FID,'   SPCFORCES(PRINT,PLOT,%s,REAL)=%s\n',SORT_TYPE,num2str(SET_ID));


% fprintf(FID,'   DISPLACEMENT(PLOT,%s,REAL)=ALL\n',SORT_TYPE); % SORT2 : outputs results for all load steps for each grid points
% fprintf(FID,'   SPCFORCES(PLOT,%s,REAL)=ALL\n',SORT_TYPE);
% fprintf(FID,'   OLOAD(PRINT,PLOT,%s,REAL)=%s\n',SORT_TYPE,num2str(SET_ID));
fprintf(FID,'$\n');


%% STEP 2 : NLBUCK // NON LINEAR BUCKLING 


fprintf(FID,'   LABEL = NON LINEAR BUCKLING \n');

% fprintf(FID,' STEP %s\n',num2str(StepID2));% STEP ID
% fprintf(FID,'   SUBTITLE=Default\n');
fprintf(FID,'   NLSTEP = %s\n',num2str(NLSTEP_STEP_ID)); % NLSTEP ID

% fprintf(FID,'   NLBUCK=ALL\n');
fprintf(FID,'   METHOD=%d\n',NLSTEP_METHOD_ID);
fprintf(FID,'   %s =  ALL\n',ANALYSIS_TYPE2); % ANALYSIS TYPE
fprintf(FID,'   SPC = 2\n'); %SPC ID 
fprintf(FID,'   LOAD = 2\n'); %LOAD ID
% fprintf(FID,'   DISPLACEMENT(PRINT,PLOT,%s,REAL)=%s\n',SORT_TYPE,num2str(SET_ID)); % SORT2 : outputs results for all load steps for each grid points
% fprintf(FID,'   SPCFORCES(PRINT,PLOT,%s,REAL)=%\ns',SORT_TYPE,num2str(SET_ID));


% fprintf(FID,'   OLOAD(PRINT,PLOT,%s,REAL)=%s\n',SORT_TYPE,num2str(SET_ID));
% STATSUB : Selects the static solution to use in forming the differential stiffness for static analysis, buckling analysis, normal modes, complex eigenvalue, frequency response and transient response analysis
% fprintf(FID,'   STATSUB=1\n');

fprintf(FID,'$\n');

end

