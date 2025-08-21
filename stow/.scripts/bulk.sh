#!/bin/bash

for d in */; do
    if [ -d "$d/.git" ]; then
        echo "$d"
        (
            cd "$d" || exit
            "${@}"
        )
        echo ""
    fi
done
