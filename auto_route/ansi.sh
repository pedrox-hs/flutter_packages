#!/bin/bash

set -ue -o pipefail

for code in {0..7}
do
    light=$((code+30))
    high=$((code+90))

    normal_light="\e[0;${light}m"
    normal_high="\e[0;${high}m"

    bold_light="\e[1;${light}m"
    bold_high="\e[1;${high}m"

    styles=("$normal_light" "$normal_high" "$bold_light" "$bold_high")

    for style in "${styles[@]}"; do
        echo -ne "$style"
        echo -n $style
        echo -ne "\e[0m  "
    done
    
    echo ""
done
