function assign_preRun_sol_ICEBOX(FID,PRE_RUN_FILE_NAME,UNIT)
% UNIT COULD BE GLOBAL VAR
fprintf(FID,'$ Assign pre-run solution file \n');
fprintf(FID,'ASSIGN INPUTT2=');
fprintf(FID,'''');
fprintf(FID,'%s', PRE_RUN_FILE_NAME);
fprintf(FID,'''');
fprintf(FID,' unit=%s\n',num2str(UNIT));fprintf(FID,'$\n');
end
