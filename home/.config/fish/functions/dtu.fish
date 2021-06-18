function dtu
    if test (count $argv) -ne 0 -a -e "$argv"
        nvim -c ":set ff=unix" -c ":x" $argv
        if file -b $argv | grep -i -w -q 'bom'
            nvim -c ":set nobomb" -c ":x" $argv
        end
    end
end
