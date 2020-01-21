#!/bin/bash

alltags() {
    IMG="$1"
    local alltags=
    local rawtags=
    rawtags=$(curl -qsL "https://github.com/docker-library/official-images/raw/master/library/${IMG}" | grep "Tags:"|sed "s/Tags: //g")
    while read -r line; do
        for tag in $(echo "$line" | sed "s/,/ /g"); do
            alltags="$alltags $tag"
        done
    done < <(echo "$rawtags")
    echo "$alltags"|sed "s/^ //g"
}