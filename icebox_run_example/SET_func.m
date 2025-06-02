function SET_func(FID,SET_ID1)
%% SET : DEFINE SET TO REQUEST OUTPUT OF THE SELECTED GRID/ELEMENTS
% SET_ID1 = 11; 
fprintf(FID,'$ Define SET ID- used for output request');
fprintf(FID,' of grid,elements,etc \n');
% fprintf(FID,'SET %s = 1,5,15,50 \n',num2str(SID1));
% fprintf(FID,'SET %s = 1,THRU,5,EXCEPT,3,50 \n',num2str(SID1));
% fprintf(FID,'SET %s = 1,THRU,5,EXCEPT,3,50 \n',num2str(SID1));
fprintf(FID,'SET %s = 1,THRU,25761\n',num2str(SET_ID1));
% fprintf(FID,'SET %s = 200\n',num2str(SET_ID1));

end