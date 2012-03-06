#!/bin/bash
if [ $# -eq 1 ]
then
    RANDOM=$$
    searching=1
    tryed_id=0
    while [ $searching -eq 1 ] || [ $tryed_id -eq 0 ]
    do
        searching=0
        tryed_id=$RANDOM
        for line in `grep -o '[0-9]\+' $1`
        do
            if [ $line -eq $tryed_id ]
            then
                searching=1
            fi
        done
    done
    echo $tryed_id
else
    echo "usage: $0 <file-with-id>"
    exit 1
fi
