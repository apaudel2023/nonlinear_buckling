function cleanup_dir(dir_path, max_retries, wait_secs)
% Attempts to delete a directory with retry logic.
% Usage: cleanup_dir(dir_path)
%        cleanup_dir(dir_path, max_retries, wait_secs)

    if nargin < 2, max_retries = 5; end
    if nargin < 3, wait_secs = 3; end

    for attempt = 1:max_retries
        try
            if isfolder(dir_path)
                rmdir(dir_path, 's');
                fprintf('[INFO] Deleted temp directory: %s\n', dir_path);
                return;
            else
                return;  % Nothing to delete
            end
        catch
            pause(wait_secs);
        end
    end

    warning('[WARN] Failed to delete directory after %d attempts: %s', max_retries, dir_path);
end
