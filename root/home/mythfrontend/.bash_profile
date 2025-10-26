if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty8 ]]; then
    exec startx >> ~/mfout 2>&1
fi
