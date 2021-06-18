function mpvl
    mpv --profile=local-video $argv >/dev/null 2>&1 <&1 & disown 2>/dev/null
    and exit
end
