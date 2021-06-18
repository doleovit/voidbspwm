function dmes
    sudo dmesg -L -H -T | less -m -n -q -S -w -e -i --mouse
end
