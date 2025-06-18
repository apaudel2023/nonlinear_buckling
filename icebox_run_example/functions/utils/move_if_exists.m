
function move_if_exists(src, dst)
    if isfile(src)
        movefile(src, dst);
        fprintf('[INFO] Movied files to: %s\n', dst);
    else
        warning('[WARN] File not found: %s\n', src);
    end
end