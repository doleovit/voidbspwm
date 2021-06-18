function pdf
    mupdf -r 150 $argv 2>&1 <&1 & disown 2>/dev/null
end
