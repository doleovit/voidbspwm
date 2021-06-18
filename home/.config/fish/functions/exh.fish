function exh
    find "$HOME" -maxdepth 10 -executable -type f | sort | fzf --reverse --color=bw --preview 'head -150 {}' --bind '!:toggle-preview,?:execute(nvim {})'
end
