function svs
    sudo sv status /var/service/* | sed 's/://g;s/\/var\/service\///' | grep --color=always -E -- 'run|down|\)|\(|fail'
end
