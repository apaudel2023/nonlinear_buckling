function EIGENVAL = read_fo6_PERF_LBA_SOL_105(FILENAME,nmodes,hline_EIGENVALUES)

% getDirectory = dir('*.f06');
% FILENAME = getDirectory.name;
%% read result files from a directory and
% A =  exist(FILENAME,'file');
% if A ==0
%     pause(2);
%     disp('The .f06 file does not exist');
%     return;
% else
%     disp('The .f06 file exists!!!')
% end
%% READ STRESS FOR selected ELEMENTS for ALL LOAD STEPS
FID2 =  fopen(FILENAME,'r'); % use fopen to obtain the FID
% InputText=textscan(FID2,'%s %s %s %s',1,'HeaderLines',16148) ;%for my computer!!!!
% InputTextA = textscan(FID2,'%s',15,'HeaderLines',16147);
InputText=textscan(FID2,'%s %s %s %s %s %s %s %s %s %s %s %s',1,'HeaderLines',hline_EIGENVALUES);

% for iit = 1:max_steps % for each load step;
while(1)
    %%
    if cell2mat(InputText{1,1}')=="R" && cell2mat(InputText{1,4}')=="L" && cell2mat(InputText{1,5}')=="E"...
            && cell2mat(InputText{1,11}')=="A"
        tempInputscan= textscan(FID2,'%s %s %s %s %s %s %s %s %s %s %s %s',nmodes,'HeaderLines',3);
        EIGENVAL = str2double(tempInputscan{1,3});
        break;
        
    else
        InputText=textscan(FID2,'%s %s %s %s %s %s %s %s %s %s %s %s',1,'HeaderLines',1);
    end
end
fclose(FID2);



end