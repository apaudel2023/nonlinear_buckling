function eigval_request_400(FID,NROOT,EIGmethodID)


fprintf(FID,'$ Eigenvalues output request \n');
% fprintf(FID,'EIGRL    10                      10\n');
% fprintf(FID,'EIGRL    10                      %2d\n',NROOT);
fprintf(FID,'EIGRL    %2s                      %2s\n',num2str(EIGmethodID),num2str(NROOT));

end