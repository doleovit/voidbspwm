function fla
    find / -path /home -prune -o -maxdepth 10 -type f -print 2>/dev/null | sort | fzf --reverse --color=bw --preview 'head -150 {}' --bind '!:toggle-preview,?:execute(EDITOR=nvim sudoedit {})' --preview-window=:hidden --exact
end
