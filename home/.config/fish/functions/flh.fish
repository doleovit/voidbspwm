function flh
    find "$HOME" -maxdepth 10 -type f | sort | fzf --reverse --color=bw --preview 'head -150 {}' --bind '!:toggle-preview,?:execute(nvim {})' --preview-window=:hidden --exact
end
