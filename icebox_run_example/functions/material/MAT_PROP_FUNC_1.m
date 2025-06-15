function MAT_PROP_FUNC_1(compProp)

fclose('all');
delete INCLUDE_COMPOSITE_MAT_PROP1.dat;
FID1 = fopen('INCLUDE_COMPOSITE_MAT_PROP1.dat','w'); %% NEW DAT FILE
temp = sprintf('MAT8   * 1              %8.3e        %8.3e        %8.3e\n', compProp(1),compProp(2),compProp(3));
temp2 = erase(temp,'e');
fprintf(FID1,temp2);
fprintf(FID1,erase(sprintf('*       %8.3e', compProp(4)),'e'));
% fprintf(FID1'PARAM  * POST            1                                                      
% fprintf(FID1'PARAM  * PRTMAXIM        YES 

fclose(FID1);
end