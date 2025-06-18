function assign_imperfection(FID,IMPERFECT_ID)

fprintf(FID,'$ Assign Imperfection ID and Imperfection output request\n');
fprintf(FID,'IMPERFECT =%d\n',IMPERFECT_ID);
fprintf(FID,'$\n');
% fprintf(FID,'OIMPERFECT([PRINT,PLOT],GEOM)=ALL\n'); % PRINT FOR .FO6 PLOT FOR .OP2
% fprintf(FID,'OIMPERFECT(PRINT,PLOT)=ALL\n'); % PRINT FOR .FO6 PLOT FOR .OP2
% fprintf(FID,'OIMPERFECT(GEOM,PRINT,PUNCH,PLOT)=ALL\n'); % PRINT FOR .FO6 PLOT FOR .OP2
fprintf(FID,'OIMPERFECT(GEOM,PUNCH,PLOT)=ALL\n'); % PRINT FOR .FO6 PLOT FOR .OP2

% GEOM option is to output GRID entries with imperfection to punch file
% fprintf(FID,'OIMPERFECT(GEOM)=ALL\n');
fprintf(FID,'$\n');
end