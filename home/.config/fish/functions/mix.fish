function mix
    printf "\n"

    read -l -P 'reconcile permissions if they were overwritten? (y/n) ' choice

    if test "$choice" = 'y'
        if not getcap -r /usr/bin/newuidmap 2>/dev/null | grep -o -i -q 'cap'
            sudo setcap cap_setuid+ep /usr/bin/newuidmap
        end
        if not getcap -r /usr/bin/newgidmap 2>/dev/null | grep -o -i -q 'cap'
            sudo setcap cap_setgid+ep /usr/bin/newgidmap
        end
        if test -u /usr/libexec/ssh-keysign
            sudo chmod u-s /usr/libexec/ssh-keysign
        end
        if test -g /usr/bin/wall
            sudo chmod g-s /usr/bin/wall
        end
        if test -g /usr/bin/write
            sudo chmod g-s /usr/bin/write
        end
        if test -u /usr/bin/newgidmap
            sudo chmod u-s /usr/bin/newgidmap
        end
        if test -u /usr/bin/newuidmap
            sudo chmod u-s /usr/bin/newuidmap
        end
        if not stat -c '%A' /boot | grep -w -i -q 'drwx'
            sudo chmod go-rwx /boot
        end
        if not stat -c '%A' /usr/src | grep -w -i -q 'drwx'
            sudo chmod go-rwx /usr/src
        end
        if not stat -c '%A' /lib/modules | grep -w -i -q 'drwx'
            sudo chmod go-rwx /lib/modules
        end
        if not stat -c '%A' /usr/lib/modules | grep -w -i -q 'drwx'
            sudo chmod go-rwx /usr/lib/modules
        end
    end

    sudo printf "\nmitigation status:\n\n"
    grep --color=always -H '' /sys/devices/system/cpu/vulnerabilities/* \
    | sed 's/\/sys\/devices\/system\/cpu\/vulnerabilities\///;s/:/ /'

    printf "\nSMT: "
    grep -h '' /sys/devices/system/cpu/smt/control

    printf "\ncore file size:"
    ulimit -a | grep -i 'core' | tr -s ' ' | sed 's/.*)//'

    printf "\nentropy: "
    grep -h '' /proc/sys/kernel/random/entropy_avail

    printf "\nzombies: "
    if not ps -e -o ppid,stat,cmd | tr -s ' ' | grep -i -w 'defunct' | grep -v 'grep'
        printf "no\n"
    end

    printf "\nsuid/sgid bits \u2193\n\n"
    sudo find / -perm /u=s,g=s -type f 2>/dev/null

    printf "\ncapability \u2193\n\n"
    if not getcap -r /usr/bin /usr/sbin | grep --color=never .
        printf "found nothing\n"
    end

    printf "\nsticky bits \u2193\n\n"
    if not sudo find / -perm /a=t -type f 2>/dev/null | grep --color=never .
        printf "found nothing\n"
    end

    printf "\npermissions \u2193\n\n"
    stat -c '%A %n' /usr/lib/modules /lib/modules /usr/src /boot

    printf "\n"
end
