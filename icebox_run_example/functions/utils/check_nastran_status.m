function check_nastran_status(bdf_filename, timeout_sec)
% Waits for Nastran simulation to complete by checking the associated .f06 file.
% Validates END OF JOB marker and file stability before proceeding.
%
% Args:
%   bdf_filename - name of the BDF input file (e.g., 'jobname.bdf')
%   timeout_sec  - max wait time in seconds before error

    [~, name, ~] = fileparts(bdf_filename);
    f06_file = [name, '.f06'];
    finished_marker = '* * * END OF JOB * * *';

    % Timings
    initial_wait = 20;    % wait before polling starts
    pause_interval = 10;   % interval between file checks
    stability_wait = 10;   % how long the file must remain stable

    fprintf('[INFO] Monitoring f06 file for completion: %s\n', f06_file);
    fprintf('[INFO] Waiting %d seconds for simulation to start...\n', initial_wait);
    pause(initial_wait);

    t_start = tic;

    while toc(t_start) < timeout_sec
        if isfile(f06_file)
            try
                fid = fopen(f06_file, 'r');
                fseek(fid, -8192, 'eof');  % read last 8KB
                tail = fread(fid, '*char')';
                fclose(fid);

                if contains(tail, finished_marker)
                    % Check file is no longer growing
                    is_stable = check_file_stability(f06_file, stability_wait);

                    if is_stable
                        elapsed = toc(t_start) + initial_wait;
                        file_info = dir(f06_file);
                        size_MB = file_info.bytes / (1024^2);

                        fprintf('[INFO] Simulation complete: %s\n', f06_file);
                        fprintf('[INFO] Total elapsed time: %.2f seconds\n', elapsed);
                        fprintf('[INFO] Final .f06 file size: %.2f MB\n', size_MB);
                        return;
                    else
                        fprintf('[WARN] Marker found but file still growing. Waiting...\n');
                    end
                end
            catch ME
                warning('[WARN] Error reading %s: %s\n', f06_file, ME.message);
            end
        end
        pause(pause_interval);
    end

    error('[ERROR] Timeout: Nastran did not finish in %d seconds (%s)', timeout_sec, f06_file);
end
