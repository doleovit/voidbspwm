function enc --argument dir
    if test -n "$dir"
        tar -c -f - -- $dir | openssl enc -aes-256-cbc -salt -pbkdf2 -iter 2000000 -a -out vault.enc -pass file:(read -l -s $pass | psub)
    end
end
