function check_nastran_status(bdf_filename, timeout_sec)
% Waits for a Nastran simulation to complete by monitoring the associated .log file.
% Assumes log file has the same base name as the .bdf file.
%
% Args:
%   bdf_filename - e.g., 'BDF_PERFECT_LBA_SOL_105.bdf'
%   timeout_sec  - maximum wait time in seconds

    [~, name, ~] = fileparts(bdf_filename);
    log_file = [name, '.log'];
    finished_marker = 'MSC Nastran finished';

    fprintf('[INFO] Monitoring log: %s\n', log_file);
    t_start = tic;

    while toc(t_start) < timeout_sec
        if isfile(log_file)
            try
                fid = fopen(log_file, 'r');
                lines = textscan(fid, '%s', 'Delimiter', '\n');
                fclose(fid);
                lines = lines{1};

                % Check last 10 lines for completion message
                if any(contains(lines(max(1, end-10):end), finished_marker))
                    fprintf('[INFO] Simulation complete: %s\n', log_file);
                    return;
                end
            catch ME
                warning('[WARN] Error reading %s: %s', log_file, ME.message);
            end
        end
        pause(5);
    end

    error('[ERROR] Timeout: Nastran did not finish in %d seconds (%s)', timeout_sec, log_file);
end
