function tma
    if test -n "$argv" -a "$argv" != st
        printf "\n"
        while true
            read -l -P 'transmission? (y/n) ' ch
            switch $ch
                case y
                    sudo sv up transmission-daemon
                    and sleep 1
                    transmission-remote -a $argv
                    return 0
                case n
                    return 0
            end
        end
    end

    if test "$argv" = st
        transmission-remote -l
        return 0
    end

    transmission-remote -t1 -S >/dev/null

    if test "$status" -eq 0
        set -l di /var/lib/transmission/Downloads
        if string length -q -- (ls -A $di)
            if test ! -d "$HOME"/Temp
                mkdir $HOME/Temp
            end
            sudo mv \
            {$di}/**.{iso,tar.gz,pdf,mp4,mkv,srt,mp3} \
            $HOME/Temp
        end
    else
        return 1
    end

    transmission-remote -t1 -rad >/dev/null
    and transmission-remote --exit >/dev/null

    if string length -q -- (ls -A $HOME/Temp)
        sudo chown $USER:$USER $HOME/Temp/**
        chmod go-rwx,a-t $HOME/Temp/**
    end

    sudo sv down transmission-daemon

    and begin
        echo "cleanup.."
        sleep 5
        sudo sed -i '1,$d' \
        /var/lib/transmission/.config/t*-d*/stats.json
    end

    if pgrep -l transmission
        printf "\n"
        printf "tmd = \u2191"
    else
        printf "\n"
        echo "done"
    end

    printf "\n"
    file $HOME/Temp/**
end
