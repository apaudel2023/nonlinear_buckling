function outputs = read_fo6_IMPF_LBA_SOL_400(F06_PERFECT_NON_LINEAR_SOL_400,NDmodes_IMPF_LBA,hline_IMPF_LBA_400);

FILENAME = F06_PERFECT_NON_LINEAR_SOL_400;
A =  exist(FILENAME,'file');
if A ==0
    pause(1);
    disp('The .f06 file does not exist');
    return;
else
    disp('Reading .fo6 file --')
    disp(FILENAME)
end
%%

FID2 =  fopen(FILENAME,'r'); % use fopen to obtain the FID
InputText=textscan(FID2,'%s %s %s %s',1,'HeaderLines',hline_IMPF_LBA_400) ;%for my computer!!!!
% IMF_CASECOUNT = 0;
nIMPcase = 1;
for itk = 1:nIMPcase
    InputText=textscan(FID2,'%s %s %s %s',1,'HeaderLines',1) ;%for my computer!!!!
    
    while(1)
        if InputText{1,4} == "IMPERFECT"
            %             InputTextB=textscan(FID2,'%s %s %s %s',1,'HeaderLines',1) ;%for my computer!!!!
            %             InputTextA = textscan(FID2,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',1,'HeaderLines',1) ;%for my computer!!!!
            InputTextA = textscan(FID2,'%s',15,'HeaderLines',1);
            
            if size(InputTextA{1,1}{1,1},2) == size(InputTextA{1,1}{2,1},2) == size(InputTextA{1,1}{3,1},2)
                tempvar2 = cell2mat(InputTextA{1,1});
                
                %             tempvar=string(InputTextA);
                %             strvar = convertCharsToStrings(sprintf('%s ',tempvar{:}));
                strvar = convertCharsToStrings(sprintf('%s',tempvar2));
                strcheck = "REALEIGENVALUES";
                
                if strcheck==strvar
                    %                     fprintf('\n IMPERFECT CASE -- ')
                    %                     disp(itk)
                    %                     fprintf('SAMPLE %d : ',sampLoc)
                    %                     fprintf('SCALING FACTOR  %2.2e',SF)
                    %
                    %                     fprintf(' : EIGENVALUES\n')
%                     IMF_CASECOUNT = itk;
                    tempInputscan= textscan(FID2,'%s %s %s %s %s %s %s %s',NDmodes_IMPF_LBA,'HeaderLines',3);
                    EIGVALS =str2double( tempInputscan{1,3});
                    %                     disp(EIGVALS(:,IMF_CASECOUNT))
                    fprintf('\n')
                    break;
                end
                
            else
                InputText=textscan(FID2,'%s %s %s %s',1,'HeaderLines',1) ;%for my computer!!!!
            end
        else
            InputText=textscan(FID2,'%s %s %s %s',1,'HeaderLines',1) ;%for my computer!!!!
        end
        
    end
    outputs(:,itk) = EIGVALS;
    %     disp(outputs)
    %     fprintf('\n')
end
end
