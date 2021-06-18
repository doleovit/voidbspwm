#!/bin/sh
#
    pkill -x polybar

    while pgrep -x polybar >/dev/null; do
        sleep 1
    done

    polybar -q mybar 2>/dev/null &
