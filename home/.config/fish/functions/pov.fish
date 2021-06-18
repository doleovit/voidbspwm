function pov
    xbps-query -l | cut -d ' ' -f 2 | xargs -n1 xbps-uhelper getpkgname
end
