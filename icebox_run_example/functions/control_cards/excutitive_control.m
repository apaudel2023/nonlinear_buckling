function excutitive_control(FID,sol_type)
fprintf(FID,'$ Excutive control section : specify solution type\n');
fprintf(FID,'SOL %s\n',num2str(sol_type));
fprintf(FID,'CEND\n'); % CEND : Designates the end of the Executive Control Section.
fprintf(FID,'$\n');

end