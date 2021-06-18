function ffp
    if pgrep -f ffplay >/dev/null
        pkill ffplay
        or return 1
    end

    ffplay $argv -volume 100 -nodisp -hide_banner -noinfbuf -nostats -loglevel fatal -autoexit >/dev/null 2>&1 <&1 & disown 2>/dev/null
end
