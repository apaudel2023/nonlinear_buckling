function MAT_PROP_FUNC_2(samples)
tply = samples(1:10);
ortply = samples(11:20);
fclose('all');
delete INCLUDE_COMPOSITE_MAT_PROP2.dat;
FID2 = fopen('INCLUDE_COMPOSITE_MAT_PROP2.dat','w'); %% NEW DAT FILE

fprintf(FID2,'PCOMP  * 1  \n');                                                                    
fprintf(FID2,'*          \n');                                                                       
fprintf(FID2,erase(sprintf('*        1              %8.3e        %16.12fYES\n',tply(1),ortply(1)),'e'));                    
fprintf(FID2,erase(sprintf('*        1              %8.3e        %16.12fYES\n',tply(2),ortply(2)),'e'));                    
fprintf(FID2,erase(sprintf('*        1              %8.3e        %16.12fYES\n',tply(3),ortply(3)),'e'));                    
fprintf(FID2,erase(sprintf('*        1              %8.3e        %16.12fYES\n',tply(4),ortply(4)),'e'));                    
fprintf(FID2,erase(sprintf('*        1              %8.3e        %16.12fYES\n',tply(5),ortply(5)),'e'));                    
fprintf(FID2,erase(sprintf('*        1              %8.3e        %16.12fYES\n',tply(6),ortply(6)),'e'));                    
fprintf(FID2,erase(sprintf('*        1              %8.3e        %16.12fYES\n',tply(7),ortply(7)),'e'));                    
fprintf(FID2,erase(sprintf('*        1              %8.3e        %16.12fYES\n',tply(8),ortply(8)),'e')); 
fprintf(FID2,erase(sprintf('*        1              %8.3e        %16.12fYES\n',tply(9),ortply(9)),'e'));                    
fprintf(FID2,erase(sprintf('*        1              %8.3e        %16.12fYES'  ,tply(10),ortply(10)),'e'));                    

fclose(FID2);
pause(1)
end