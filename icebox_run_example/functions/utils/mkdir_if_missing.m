% === Utility functions ===
function mkdir_if_missing(dir_path)
    if ~exist(dir_path, 'dir')
        mkdir(dir_path);
        fprintf('[INFO] Created temp directory: %s\n', dir_path);
    end
end