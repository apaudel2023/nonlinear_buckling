function case_control_IMPF_LBA(FID,SubCaseID1,SubCaseID2,StepID1,ANALYSIS_TYPE1,ANALYSIS_TYPE2,SET_ID,EIGmethodID,SORT_TYPE)
t=now; d = datetime(t,'ConvertFrom','datenum');
fprintf(FID,'$\n');
fprintf(FID,'$ CASE CONTROL COMMAND SECTION\n');
fprintf(FID,'$ Direct Text Input for this Subcase\n'); 
fprintf(FID,'TITLE = MSC.Nastran job created on %s\n',d);
fprintf(FID,'$\n');
%% SUBCASE I
fprintf(FID,'SUBCASE %s\n',num2str(SubCaseID1));% SUBCASE ID
fprintf(FID,'$ Direct Text Input for this Subcase\n'); 
fprintf(FID,' STEP %s\n',num2str(StepID1));% STEP ID : Delimits and identifies a nonlinear analysis step for SOL 400 
fprintf(FID,'   SUBTITLE=Default\n'); % Defines a subtitle that will appear on the second heading line of each page of printer output.
fprintf(FID,'   ANALYSIS = %s\n',ANALYSIS_TYPE1); % ANALYSIS TYPE
fprintf(FID,'   SPC = 2\n'); %SPC ID 
fprintf(FID,'   LOAD = 2\n'); %LOAD ID
fprintf(FID,'   DISPLACEMENT(PLOT,%s,REAL)=%s\n',SORT_TYPE,num2str(SET_ID)); % SORT2 : outputs results for all load steps for each grid points
fprintf(FID,'   SPCFORCES(PLOT,%s,REAL)=%s\n',SORT_TYPE,num2str(SET_ID));
% fprintf(FID,'   OLOAD(PRINT,PLOT,%s,REAL)=%s\n',SORT_TYPE,num2str(SET_ID));
fprintf(FID,'$\n');

%% SUBCASE II
fprintf(FID,'$ Direct Text Input for this Subcase\n'); 
fprintf(FID,'SUBCASE %s\n',num2str(SubCaseID2));% SUBCASE ID
fprintf(FID,'   LABEL = EIGENVALUE CALCULATION\n');
fprintf(FID,'   METHOD=%d\n',EIGmethodID);
fprintf(FID,'   ANALYSIS = %s\n',ANALYSIS_TYPE2); % ANALYSIS TYPE
fprintf(FID,'   SPC = 2\n'); %SPC ID 
fprintf(FID,'   LOAD = 2\n'); %LOAD ID
fprintf(FID,'   DISPLACEMENT(PLOT,%s,REAL)=%s\n',SORT_TYPE,num2str(SET_ID)); % SORT2 : outputs results for all load steps for each grid points
fprintf(FID,'   SPCFORCES(PLOT,%s,REAL)=%s\n',SORT_TYPE,num2str(SET_ID));
% fprintf(FID,'   OLOAD(PRINT,PLOT,%s,REAL)=%s\n',SORT_TYPE,num2str(SET_ID));
% STATSUB : Selects the static solution to use in forming the differential stiffness for static analysis, buckling analysis, normal modes, complex eigenvalue, frequency response and transient response analysis
fprintf(FID,'   STATSUB=1\n');
fprintf(FID,'$\n');

end

