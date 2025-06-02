function SOL_400_NONLINEAR_BUCK_FUNC_MAIN(SCALE_FACTOR,PRE_RUN_FILE_NAME,IMPF_FILE_NAME_NLBA)
%% CREATE NEW .DAT FILE
FID_400 = fopen(IMPF_FILE_NAME_NLBA,'w'); %% NEW DAT FILE

%% IMPORT PRE-RUN
% PRE_RUN_FILE_NAME = 'cyliinder_ref_dlr_sol_105_safe.op2';
% PRE_RUN_FILE_NAME = 'cyliinder_ref_dlr_sol_105_TEST.op2';

UNIT = 31;
% assign_preRun_sol(FID_400,PRE_RUN_FILE_NAME,UNIT)
assign_preRun_sol_ICEBOX(FID_400,PRE_RUN_FILE_NAME,UNIT)

%% EXCUTITIVE CONTROL
sol_type = 400;
excutitive_control(FID_400,sol_type)

%%

fprintf(FID_400,'ECHO = NONE\n');
%% ASSIGN IMPERFECTION CASE
IMPERFECT_ID = 17;
assign_imperfection(FID_400,IMPERFECT_ID)


%% SET
SET_ID = 4;
SET_func(FID_400,SET_ID)
% SET_ID = [];
%% CASE CONTROL
SORT_TYPE = 'SORT1'; % SORT1 or SORT2

SubCaseID1 = 1;
StepID1 = 1;
ANALYSIS_TYPE1 = 'NLSTATIC';

StepID2 = 2;
NLSTEP_STEP_ID = 11; % not needed for linear static;
NLSTEP_METHOD_ID = 25;
ANALYSIS_TYPE2 = 'NLBUCK';

% case_control_400(FID_400,SubCaseID1,StepID,ANALYSIS_TYPE,NLSTEP_ID,SET_ID,EIGmethodID,SORT_TYPE);
case_control_IMPF_NLBA(FID_400,SubCaseID1,StepID1,StepID2,ANALYSIS_TYPE1,ANALYSIS_TYPE2,SET_ID,NLSTEP_STEP_ID,NLSTEP_METHOD_ID,SORT_TYPE);

%% SET1 OR SET3
SETi_ID = 14;
% SETi_ID = ALL;

SET3_func(FID_400,SETi_ID)

%% BULK SECTION BEGINING
begin_bulk(FID_400)

%% DEFINE IMPERFECTION CASE

% lower bound = 0.005 units mm
% upper bound = 0.4 units mm

MODE_TYPE = 1;
nIMP_CASE = 1:length(SCALE_FACTOR);
% define_impCase(FID_400,SubCaseID2,StepID1,IMPERFECT_ID,SETi_ID,MODE_TYPE,nIMP_CASE,SCALING_FACTOR,UNIT)
define_impCase_static(FID_400,SubCaseID1,IMPERFECT_ID,SETi_ID,MODE_TYPE,nIMP_CASE,SCALE_FACTOR,UNIT);

%% REQUEST OUTPUT FILES
outputFile_request_400(FID_400)

%% REQUEST EIGENVALUE OUTPUTS
NROOT = 1;

% eigval_request_400(FID_400,NROOT,EIGmethodID)
MIN =0.0001;
MAX = 500;
METHOD = 'LAN';
RANGE = 'y'; 

EIGmethodID=NLSTEP_METHOD_ID;
eigval_request_EIGRL(FID_400,NROOT,EIGmethodID,MIN,MAX,METHOD,RANGE);
% % eigval_request_EIGR(FID_400,NROOT,EIGmethodID,MIN,MAX,METHOD,RANGE)
% % eigval_request_EIGB(FID_400,NROOT,EIGmethodID,MIN,MAX,METHOD,RANGE)


%% DEFINE NONLINEAR STEPS

Type = 'Fixed';

nIncrementMax = 100;
nBisectionMax = 5;

% Type = 'Adaptive';

noutStep = 10; % out put steps
maxIncr = 1000; % max number of increment : default 9999

maxStep = 0.01;% as a fraction of total time step
minStep = 1e-6;
stepFact = 1.1; 
initStep = 1E-3; 

maxItr = 2; 
minItr = 10;

nlstep(FID_400,NLSTEP_STEP_ID,nIncrementMax,nBisectionMax,noutStep,maxIncr,maxStep,minStep,maxItr,minItr,Type,stepFact,initStep)

%%
fclose(FID_400);


end








