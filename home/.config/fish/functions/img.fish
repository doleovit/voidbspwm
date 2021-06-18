function img
    if test -d "$HOME"/Pictures
        feh -r $HOME/Pictures >/dev/null 2>&1 <&1 & disown 2>/dev/null
    else
        echo "$HOME/Pictures does not exist"
    end
end
