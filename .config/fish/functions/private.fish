function private-open
    cryfs ~/.local/share/cryfs/private ~/Private
end

function private-close
    fusermount3 -u ~/Private
end
