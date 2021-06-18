function fip
    if pgrep -f ffplay >/dev/null
        pkill ffplay
        or return 1
    end

    while true
        read -l -P 'jazz, electro, main, or exit? (j/e/m/x) ' choice
        switch $choice
            case j
                ffplay -i https://icecast.radiofrance.fr/fipjazz-midfi.mp3 \
                -volume 100 -nodisp -hide_banner -noinfbuf -nostats -loglevel fatal >/dev/null 2>&1 <&1 & disown 2>/dev/null
                return 0
            case e
                ffplay -i https://icecast.radiofrance.fr/fipelectro-midfi.mp3 \
                -volume 100 -nodisp -hide_banner -noinfbuf -nostats -loglevel fatal >/dev/null 2>&1 <&1 & disown 2>/dev/null
                return 0
            case m
                ffplay -i https://icecast.radiofrance.fr/fip-lofi.mp3 \
                -volume 100 -nodisp -hide_banner -noinfbuf -nostats -loglevel fatal >/dev/null 2>&1 <&1 & disown 2>/dev/null
                return 0
            case x
                return 0
            case '*'
                printf "\nplease answer with: j, e, m, or x to exit"
        end
    end
end
