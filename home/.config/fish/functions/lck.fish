function lck
    if test "$argv[1]" = x -a (count $argv) -le 2
        set -lx XSECURELOCK_PASSWORD_PROMPT time
        set -lx XSECURELOCK_SAVER saver_blank
        set -lx XSECURELOCK_SHOW_HOSTNAME 0
        set -lx XSECURELOCK_SHOW_USERNAME 0
        set -lx XSECURELOCK_BLANK_DPMS_STATE on
        if test (count $argv) -eq 2
            if string match -rq '^[\d]+$' -- $argv[2]
                echo "lock screen in $argv[2] seconds"
                sleep $argv[2]
            else
                return 1
            end
        end
        xsecurelock 2>/dev/null
    end
end
