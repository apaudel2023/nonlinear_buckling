function SET1_func(FID,SETi_ID)
% DEFINES LIST OF STRUCTURAL GRID POINTS OR ELEMENTS ID

fprintf(FID,'$\n');
% fprintf(FID,'$ SET3 SID DES ID1 THRU ID2\n'); 
% fprintf(FID,'$ DES options :GRID,ELEM,POINT,PROP,RBEin,RBEex\n'); 
fprintf(FID,'SET1,%s,1,THRU,484\n',num2str(SETi_ID));
fprintf(FID,'$\n');

end

