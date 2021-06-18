function iov
    xbps-query -m | cut -d ' ' -f 2 | xargs -n1 xbps-uhelper getpkgname
end
