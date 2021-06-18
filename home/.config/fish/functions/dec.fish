function dec --argument vault
    if test -n "$vault"
        openssl enc -aes-256-cbc -salt -pbkdf2 -iter 2000000 -a -d -in $vault -pass file:(read -l -s $pass | psub) | tar -x -f -
        and /bin/rm -i -v -- $vault
    end
end
