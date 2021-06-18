function nt
    if test ! -d "$HOME"/.notes
        mkdir $HOME/.notes
        touch $HOME/.notes/nt
    end

    if test -z "$argv"
        sed = $HOME/.notes/nt | sed 'N;s/\n/    /' \
        | less -S -m -n -q -e -i
    else if test "$argv[1]" = a -a (count $argv) -ge 2
        echo "$argv[2..-1]" \
        | tee -a $HOME/.notes/nt >/dev/null
    else if test "$argv[1]" = s -a (count $argv) -eq 2
        printf "\n"
        sed -n "/$argv[2]/p" $HOME/.notes/nt
        printf "\n"
    else if test "$argv[1]" = r -a (count $argv) -eq 2
        if string match -rq '^[\d]+$' -- $argv[2]
            sed -i "$argv[2]d" $HOME/.notes/nt
            echo "note no. $argv[2] : removed"
        end
    else if test "$argv[1]" = b -a (count $argv) -eq 1
        cp $HOME/.notes/nt $HOME/.notes/nt.bak
        printf ".notes/nt \u21B7 .notes/nt.bak"
    else if test "$argv[1]" = h -a (count $argv) -eq 1
        echo '
        nt ( [a]dd [s]earch [r]emove [b]ackup [h]elp )

        $ nt
        $ nt b
        $ nt a <note>
        $ nt s <query>
        $ nt r <number>
        ' | cut -c 9-
    end
end
