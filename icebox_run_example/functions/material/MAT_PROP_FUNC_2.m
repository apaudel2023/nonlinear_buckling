function MAT_PROP_FUNC_2(filename, samples)
fprintf('[INFO] Writing composite ply properties to: %s\n', filename);

tply   = samples(1:10);   % Thickness of each ply
ortply = samples(11:20);  % Orientation of each ply

fclose('all');
FID2 = fopen(filename,'w'); %% NEW DAT FILE
if FID2 == -1
    error('[ERROR] Could not open file: %s', filename);
end

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
pause(1);  % Brief pause to ensure disk I/O finishes
fprintf('[INFO] Ply property file created successfully: %s\n', filename);
end