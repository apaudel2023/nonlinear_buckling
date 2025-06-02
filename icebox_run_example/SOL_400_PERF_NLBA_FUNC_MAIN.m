function SOL_400_PERF_NLBA_FUNC_MAIN(fname)
%% CREATE NEW .DAT FILE
FID_400 = fopen(fname,'w'); %% NEW DAT FILE

%% EXCUTITIVE CONTROL
sol_type = 400;
excutitive_control(FID_400,sol_type)
%% ECHO BULK DATA
fprintf(FID_400,'ECHO = NONE\n');

%% CASE CONTROL
SORT_TYPE = 'SORT1'; % SORT1 or SORT2

SubCaseID1 = 1;
NLSTEP_STEP_ID = 11; % not needed for linear static;
NLSTEP_METHOD_ID = 25; % FOR EIGRL OUTPUT REQUEST
ANALYSIS_TYPE = 'NLBUCK';
NLSTEP_ID = 1;

case_control_PERF_NLBA(FID_400,SubCaseID1,NLSTEP_ID,ANALYSIS_TYPE,NLSTEP_STEP_ID,NLSTEP_METHOD_ID,SORT_TYPE);

%% BULK SECTION BEGINING
begin_bulk(FID_400)
%% REQUEST OUTPUT FILES
outputFile_request_400(FID_400)
%% REQUEST EIGENVALUE OUTPUTS
NROOT = 10;

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
