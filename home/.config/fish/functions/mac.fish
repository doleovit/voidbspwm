function mac
    set -l interface (ip -o -4 route show to default | cut -d ' ' -f5)

    if test -n $interface
        sudo ip link set $interface down
        sudo macchanger -e $interface
        sudo ip link set $interface up
    else
        echo "can't get interface name"
    end
end
