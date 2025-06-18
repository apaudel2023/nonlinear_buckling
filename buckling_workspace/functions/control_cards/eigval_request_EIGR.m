function eigval_request_EIGR(FID,NROOT,EIGmethodID,MIN,MAX,METHOD,RANGE)


fprintf(FID,'$ Eigenvalues output request \n');
if RANGE == 'y'  %% range specified;
    fprintf(FID,'EIGR    %2s     %8.6f%8.2f%2s\n',...
        num2str(EIGmethodID),MIN,MAX,num2str(NROOT));
elseif RANGE == 'n' %% range not specified;
    fprintf(FID,'EIGR,%2s,,,%2s\n',...
        num2str(EIGmethodID),num2str(NROOT));
end

end