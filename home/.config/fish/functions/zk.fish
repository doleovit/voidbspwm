function zk
    ps -e -o ppid,stat,cmd | grep -i -w 'defunct' | grep -v 'grep' | sed 's/^[ ]*//' | cut -d ' ' -f 1 | uniq | xargs -n1 kill
end
