function MAT_PROP_FUNC_1(filename, compProp)
fprintf('[INFO] Writing composite material properties to: %s\n', filename);

fclose('all');
FID1 = fopen(filename,'w'); %% NEW DAT FILE

if FID1 == -1
    error('[ERROR] Could not open file: %s', filename);
end

temp = sprintf('MAT8   * 1              %8.3e        %8.3e        %8.3e\n', compProp(1),compProp(2),compProp(3));
temp2 = erase(temp,'e');
fprintf(FID1,temp2);
fprintf(FID1,erase(sprintf('*       %8.3e', compProp(4)),'e'));
% fprintf(FID1'PARAM  * POST            1                                                      
% fprintf(FID1'PARAM  * PRTMAXIM        YES 

fclose(FID1);
pause(1);  % Brief pause to ensure disk I/O finishes
fprintf('[INFO] Material file saved successfully: %s\n', filename);
end