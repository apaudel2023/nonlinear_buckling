
function  nlstep(FID,NLSTEP_ID,nIncrement,nBisectionMax,noutStep,maxIncr,maxStep,minStep,maxItr,minItr,Type,stepFact,initStep)
% nBisectionMax = 10;
total_time = 1;
fprintf(FID,'$ Non-Linear Load Step : Fixed or Adaptive\n');
fprintf(FID,'$ NLSTEP     ID     TOTTIME     CTRLDEF \n'); % total time 1
% CTRLDEF : For SOL400,  the values "QLINEAR", "MILDLY", and "SEVERELY"  are available
% fprintf(FID,'NLSTEP   %2s      %s\n',num2str(NLSTEP_ID),num2str(total_time)); % total time 1
fprintf(FID,'NLSTEP   %2s\n',num2str(NLSTEP_ID)); % total time 1

% fprintf(FID,'$------- GENERAL MAXITER MINITER MAXBIS CREEP \n');
% GENERAL  : Keyword for parameters used for overall analysis.
% MAXITER  : Maximum number of iterations allowed for each increment. See Remark 6. (Integer; Default = 10)
% MINITER  : Minimum number of iterations needed for each increment. (Integer >0; Default = 1)
%          : In contact analysis or CTRLDEF = SEVERELY, Default = 2). When high accuracy is required,
%          : it is also recommended to set MINITER = 2.
% MAXBIS   : Maximum number of bisections allowed in the current step. (Default = 10). See remark 17. for more information.



switch Type
    case 'Fixed'
        % % % %         fprintf(FID,'         GENERAL         2      %s\n',num2str(nBisectionMax));
%         fprintf(FID,'         GENERAL%8s%8s%8s\n',num2str(maxItr),num2str(minItr),num2str(nBisectionMax));
        
        
        % % % % % % fprintf(FID,'         GENERAL        %8s\n',num2str(nBisectionMax));
        
        % NINC Number of increments for fixed time stepping. (Integer > 0; Default =50).
        % The time step of each increment will be TOTTIME/NINC.
        %         fprintf(FID,'$         FIXED  NINC    NO \n');
        fprintf(FID,'         FIXED   %s\n',num2str(nIncrement));
        % UPV - CONVERGENCE
%         fprintf(FID,'         MECH    UPV\n');
        
    case 'Adaptive'
        %         initStep = 1e-5;
        %         stepFact = 1.2;
        fprintf(FID,'         GENERAL%8s%8s%8s\n',num2str(maxItr),num2str(minItr),num2str(nBisectionMax));
        %         fprintf(FID,'         GENERAL        %8s\n',num2str(nBisectionMax));
        fprintf(FID,'$-------- ADAPT  DTINITF DTMINF  DTMAXF  NDESIR  SFACT  INTOUT NSMAX -------- \n');
        fprintf(FID,'         ADAPT  %8.2e%8.2e%8.2e        %8.2e%8d%8d\n',initStep,minStep,maxStep,stepFact,noutStep,maxIncr);
        
        %         DTINITF Initial time step defined as fraction of total load step time (TOTTIM).
        %         DTMINF  Minimum time step defined as fraction of total load step time
        %         DTMAXF  Maximum time step defined as fraction of total load step time (TOTTIM).
        %                 (Real; Default 0.5). For most nonlinear problems, this should be between 0.05 and 0.2 for dynamic simulation
        %         NDESIR  Desired number of iterations per increment
        %         SFACT   Factor for increasing time steps due to number of iterations. See Remark 4. (Real; Default =1.2
        
        %         INTOUT  Output flag. Integer > -1. (Default=0) -1 Only the last increment of the step will be output.
        %                 0 Every computed load increment will be output. > 0 The output will be obtained at INTOUT
        % 	              equally spaced intervals.
        %         NSMAX   Maximum number of increments in the current load case. (Integer; Default=99999).
        %                 The job will stop if this limit is reached
        
        fprintf(FID,'$-------- --------  IDAMP   DAMP  CRITTID IPHYS   LIMTAR RSMALL  RBIG --------\n');
        
        %         IDAMP   Flag for activating artificial damping for static analysis.  (Integer, Default = 0).
        %                 See Remarks 27. 0 No damping considered 4 Artificial damping is always turned on 5 Artificial damping is not turned on.
        %                 But time step is adjusted based on damping energy as 4 6 When the time step reaches the minimum value and
        %                 artificial damping is turned on
        
        %         DAMP    Damping ratio. (Real; Default=2.e-4)
        %         CRITTID ID of Bulk Data TABSCTL entry which defines the user criteria to use. See Remark 5. (Integer; Default 0
        %         IPHYS   Flag to determine if automatic physical criteria should be added and how analysis should proceed if a user criterion is not satisfied. (Integer; Default=2) It is recommended to use 1.
        %         LIMTAR  Enter 0 to treat user criteria as limits, 1 to treat user criteria as targets. (Integer; Default =0). Only used if a user criterion is given through CRITTID
        %         RSMALL  Smallest ratio between time step changes due to user criteria. (Real; Default =0.1)
        %         RBIG    Largest ratio between time step changes due to user criteria. (Real; Default =10.0)
        
        
        fprintf(FID,'$-------- -------- ADJUST   MSTEP    RB     UTOL\n');
        
        %         ADJUST  Time step skip factor for automatic time step adjustment. Only for dynamics. See Remark 16. (Integer; Default = 0).
        %         MSTEP   Number of steps to obtain the dominant period response. See Remark 16. (10 < Integer < 200 or = -1; Default = 10).
        %         RB      Define bounds for maintaining the same time step for the stepping function during the adaptive process. See Remark 16. (0.1 < Real <1.0; Default = 0.6).
        %         UTOL    Defines tolerance on displacement. (.0001 < Real < 1.0; Default = 1.0)
        
        %         Only one of LCNT, FIXED, ADAPT, ARCLN, or RCHEAT time/load stepping scheme can be used on a specific NLSTEP entry.
        %         If no LCNT, FIXED, ADAPT, or ARCLN appear on a NLSTEP entry, then the default is FIXED with 50 increments.
        %
        % The test flags (U=displacement error, P=load equilibrium error, W=work error, V = vector component method,
        % N = length method, and A = auto switch) and the tolerances (EPSU, EPSP, and EPSW) define the convergence criteria.
        % All the requested criteria (combination of U, P, W, V and/or N) are satisfied upon convergence.
        % For SOL 400, if the U criterion is selected together with P or W, then for the first iteration of a load increment,
        % the U criterion will not be checked. For SOL 400 if CONV = 'blank' the code will use a default of "UPW" if heat analysis and "PV" if a structural stress analysis is performed
        
        % V and N are additional methods for convergence checking using the displacement (U) and/or load (P) criteria.
        % V stands for vector component checking. In this method, convergence checking is performed on the maximum vector
        % component of all components in the model. N stands for length checking. In this method, the length of a vector
        % at a grid point is first computed by the SRSS (square root of the sum of the squares) method. Then convergence
        % checking is performed on the maximum length of all grid points in the model. For example, if CONV=UV, then V
        %     checking method will be performed with the U criteria, i.e., the maximum displacement component of all
        %     displacement components in the model is used for convergence checking. For V and N, the EPSU is always
        %     negative, i.e., the error is computed with respect to the delta displacements of a load increment, even
        %     if positive value is requested by users. CONV=V is the same as CONV=UPV. If both V and N are specified;
        %         V will take precedence over N. For example, CONV=VN is the same as CONV=V.
    case 'ArcLength'
        
        
        %         “ARCLN” TYPE DTINITFA MINALR MAXALR NDESIRA NSMAXA
        %         NSMAXA : is maximum number of iteration 
        %       EXAMPLE USING ARC LENGTH METHOD
        % NLSTEP   2       0.8
        %          GENERAL         2
        %          ARCLN                                                   50
        %          MECH    UPV
        
        fprintf(FID,'         GENERAL        %8s%8s\n',num2str(minItr),num2str(nBisectionMax));
        fprintf(FID,'         ARCLN                                                  %8s',num2str(nIncrement));
        fprintf(FID,'         MECH    UPV\n');

       
        
end

fprintf(FID,'\n');


end