function SET3_func(FID,SETi_ID)
% % DEFINES A LIST OF GRIDS, ELEMENTS OR POINTS
% % DEFINE SET3 TO INCLUDE SELECTED GRID POINTS AS IMPERFECTION :
% % can be defined before bulk but must be after subcase section
fprintf(FID,'$ SETi ID : used for specifying set of grid for imperfection by IMPGEOM\n');
fprintf(FID,'$ SET3 SID ID1 THRU ID2\n');
fprintf(FID,'SET3,%s,GRID,1,THRU,25761\n',num2str(SETi_ID));
fprintf(FID,'$\n');
end

