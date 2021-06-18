function rlp
    uname -r | cut -d '.' -f 1,2 | xargs -I{} sudo xbps-reconfigure -f linux{}
end
