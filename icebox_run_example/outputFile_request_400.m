function outputFile_request_400(FID)
fprintf(FID,'$\n');
fprintf(FID,'$ Output file request\n');
% fprintf(FID,'MDLPRM   HDF5    0\n'); % FOR .H5 FILE
fprintf(FID,'$ for hdf5/.h5 file\n');
fprintf(FID,'PARAM   PRTMAXIM YES\n'); % PRTMAXIM controls the printout of the maximums of applied loads, mpcs, displacements etc  
fprintf(FID,'$ for .op2 file\n');
fprintf(FID,'PARAM, POST, 1\n'); % for .op2 files : 1--> new, -1--> old
% fprintf(FID,'PARAM, POST, 0\n'); % for .XDB files 
fprintf(FID,'$ for displaying maximum values of constraints result\n');
fprintf(FID,'PARAM    LGDISP  1\n');
fprintf(FID,'$\n');
end