function cd
    if test ! "$argv" = ''
        builtin cd $argv
        and ll
    else
        builtin cd ~
    end
end
