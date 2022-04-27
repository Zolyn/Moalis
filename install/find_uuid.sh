#!/bin/bash
partinfo=$(blkid | grep $BLOCK_DEVICE)
index=1

while true; do
    fragment=$(echo "$partinfo" | awk -F ' ' '{print $'$index'}')
    uuid=$(echo "$fragment" | grep "UUID")

    if [ -n "$uuid" ]; then
        break
    fi

    if [ -z "$fragment" ]; then
        break
    fi

    ((index++))
done

if [ -z "$uuid" ]; then
    echo 0
else
    echo "$uuid"
fi
