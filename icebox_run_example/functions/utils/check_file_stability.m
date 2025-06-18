function is_stable = check_file_stability(file_path, wait_secs)
% Checks if a file has stopped growing over the specified wait duration
% Returns true if stable, false otherwise

    if ~isfile(file_path)
        is_stable = false;
        return;
    end

    size1 = dir(file_path).bytes;
    pause(wait_secs);
    size2 = dir(file_path).bytes;

    is_stable = (size1 == size2);
end
