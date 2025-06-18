function define_impCase_static(FID,SubCaseID,IMPERFECT_ID,SETi_ID,MODE_TYPE,nIMP_CASE,SCALE_FACTOR,UNIT)



%% SPEFICY IMPERFECTION CASES : IMPCASE

fprintf(FID,'$ IMPCASE    ID1      ID2        ID3 ...etc\n');
fprintf(FID,'IMPCASE %8d',IMPERFECT_ID);

if length(nIMP_CASE)==1
    fprintf(FID,'%8d',nIMP_CASE(1));
    
elseif length(nIMP_CASE)>=2
    fprintf(FID,'%8d',nIMP_CASE(1));
    fprintf(FID,' THRU   ');
    fprintf(FID,'%8d',nIMP_CASE(end));
end



%%  DEFINE IMPERFECTION CASES : IMPGEOM
fprintf(FID,'\n');
fprintf(FID,'$\n');
fprintf(FID,'$ IMPGOEM       ID1     -------- -------- SETID   SCALE   -------- UNIT -------- --------        ID3 ...etc\n');
fprintf(FID,'$ --------    SUBCASE1    STEP1    MODE1  SETID1    S1    -------- UNIT -------- --------        ID3 ...etc\n');
fprintf(FID,'$ --------    SUBCASE1    STEP1    MODE1  SETID1    S1    -------- UNIT -------- --------        ID3 ...etc\n');
fprintf(FID,'$ --------    etc      \n');

% v1
% % for itk = 1:length(nIMP_CASE)
% %     fprintf(FID,'IMPGEOM %2s\n',num2str(nIMP_CASE(itk)));
% %     fprintf(FID,'         1              %2s              %8.6f         %2s\n',...
% % num2str(nIMP_CASE(itk)),SCALE_FACTOR(itk),UNIT);
% % end

% % v2 : working
% for itk = 1:length(nIMP_CASE)
%     fprintf(FID,'IMPGEOM %2s\n',num2str(nIMP_CASE(itk)));
%     fprintf(FID,'         %2s      %2s         %2s             %8.6f         %2s\n',...
%         num2str(SubCaseID),num2str(StepID),num2str(MODES(itk)),SCALE_FACTOR(itk),UNIT);
% end

% v3 : working : with specified set ID for including imperfection grid points
for itk = 1:length(nIMP_CASE)
    fprintf(FID,'IMPGEOM %2s\n',num2str(nIMP_CASE(itk)));
    fprintf(FID,'         %2s              %2s      %2s     %8.6f         %2s\n',...
        num2str(SubCaseID),num2str(MODE_TYPE),num2str(SETi_ID),SCALE_FACTOR(itk),num2str(UNIT));
end
fprintf(FID,'\n');

end