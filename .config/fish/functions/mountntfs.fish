function mountntfs
    if test (count $argv) -lt 1
        echo "Usage: mountntfs <device> [mountpoint]"
        return 1
    end

    set -q argv[2]; or set argv[2] /mnt/ntfs_partition

    sudo mount -t ntfs-3g $argv[1] $argv[2]
end
