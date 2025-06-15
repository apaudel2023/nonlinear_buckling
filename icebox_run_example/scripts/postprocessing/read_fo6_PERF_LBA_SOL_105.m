function EIGENVAL = read_fo6_PERF_LBA_SOL_105(filename, nmodes, header_start)
% read_fo6_PERF_LBA_SOL_105
% Reads eigenvalues from a Nastran .f06 file for SOL 105 linear buckling analysis.
% Looks for the eigenvalue summary section starting near a given header line.
%
% Inputs:
%   filename      - Path to the .f06 file
%   nmodes        - Number of modes requested (i.e., how many eigenvalues to extract)
%   header_start  - Line number to start scanning (approximate location of eigenvalue section)
%
% Output:
%   EIGENVAL      - Array of eigenvalues (length = nmodes)

    EIGENVAL = [];  % Default empty

    if ~isfile(filename)
        error('File not found: %s', filename);
    end

    fid = fopen(filename, 'r');
    if fid == -1
        error('Failed to open file: %s', filename);
    end

    % Fast skip to approximate line
    for i = 1:header_start
        if feof(fid); break; end
        fgetl(fid);
    end

    % Search for the eigenvalue summary header
    while ~feof(fid)
        line = fgetl(fid);
        if contains(line, 'R E A L   E I G E N V A L U E S')  % Robust match
            % Skip 3 header lines
            for i = 1:3
                fgetl(fid);
            end

            % Read next nmodes lines
            eigvals = zeros(1, nmodes);
            for i = 1:nmodes
                if feof(fid); break; end
                entry = fgetl(fid);
                tokens = strsplit(strtrim(entry));
                if numel(tokens) >= 3
                    eigvals(i) = str2double(tokens{3});
                end
            end
            EIGENVAL = eigvals;
            break;
        end
    end

    fclose(fid);

    if isempty(EIGENVAL)
        error('Could not find eigenvalue section in file: %s', filename);
    end
end
