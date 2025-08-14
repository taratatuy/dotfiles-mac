#!/bin/bash

for d in */; do
    if [ -d "$d/.git" ]; then
        echo "$d"
        (
            cd "$d" || exit
            git "${@}"
        )
        echo ""
    fi
done
