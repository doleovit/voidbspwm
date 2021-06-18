function iso
    printf "usb device \u2193\n\n"

    for dev in /dev/disk/by-id/usb*
        set dev (readlink -f $dev)
    end

    if test -z "$dev"
        echo "no usb"
        return 1
    end

    set -l usb (string replace -ra '\d' '' -- $dev)

    if set -q usb
        echo "$usb"
    else
        return 1
    end

    printf "\n"

    read -l -P 'cross check? (y/n) ' cck

    if test "$cck" = y
        printf "\n"
        lsblk -no model,name
        printf "\n"
        while true
            read -l -P 'okay? (y/n) ' ok
            switch $ok
                case n
                    return 1
                case y
                    break
            end
        end
    end

    set -l mp (df --output=source | grep "$usb")

    if test -n "$mp"
        printf "\n"
        sudo umount $mp
        or return 1
    end

    printf "\n"

    while true
        read -l -P 'wipe usb drive? (y/n) ' wpd
        switch $wpd
            case y
                printf "\n"
                sudo wipefs --all --force --quiet {$usb}*
                sudo dd if=/dev/zero of=$usb bs=512 count=1
                printf "\n"
                read -l -P 'shred entire disk? (n/y) ' disk
                if test "$disk" = y
                    sudo dd if=/dev/zero of=$usb bs=4M \
                    iflag=nocache oflag=direct status=progress
                end
                printf "\n"
                echo "creating primary partition.."
                printf 'n\np\n1\n\n\nt\nb\na\n\nw' \
                | sudo fdisk $usb > /dev/null
                sudo fdisk -l $usb | tail -n2
                set -l par {$usb}1
                printf "\n"
                sudo mkfs -t vfat $par
                break
            case n
                break
        end
    end

    printf "\n"

    while true
        read -l -P 'write image @ usb? (y/n) ' img
        switch $img
            case y
                printf "\n"
                read -l -P 'path/to/xyz.iso: ' iso
                if test -f "$iso"
                    sudo dd bs=4M if=$iso of=$usb \
                    conv=fdatasync status=progress
                    and sleep 1
                    printf "\n"
                    lsblk -o model,name,size,fstype,label
                    break
                else
                    printf "\n"
                    printf "\033[5merror\033[0m $iso"
                    return 1
                end
            case n
                printf "\n"
                lsblk -o model,name,size,fstype,label
                return 0
        end
    end
end
