function LOADS_FUNC(F,fname)

fclose('all');
FID5 = fopen(fname,'w'); %% NEW DAT FILE
fprintf(FID5,'$ FORCE SID G CID F N1 N2 N3\n');
fprintf(FID5,'$ SID  Load set identification number.  (Integer>0)\n');
fprintf(FID5,'$ G    Grid point identification number.  (Integer >0) \n');
fprintf(FID5,'$ CID  Coordinate system identification number.  (Integer >0; Default=0) \n');
fprintf(FID5,'$ F    Scale factor.  (Real) Ni Components of a vector measured in coordinate system defined by CID.  (Real) \n');
fprintf(FID5,'FORCE  * 1               50000           0              %16.2f\n',F);           
fprintf(FID5,'*        0.              0.              -1.\n');     
fclose('all');
end