function exa
    find / -maxdepth 10 -executable -type f 2>/dev/null | sort | fzf --reverse --color=bw --preview 'head -150 {}' --bind '!:toggle-preview,?:execute(nvim {})' --preview-window=:hidden
end
