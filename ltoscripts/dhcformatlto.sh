#!/bin/bash
# ltodhcformat.sh - Quick format and label / volume names for DHC LTO tapes

printf "Enter tape label (D followed by pool letter and tape number) in the following format: D[A|B]nnnn, e.g. DA0001\n"
read tapeid
if [ "$tapeid" = "" ];then
echo "Whoops empty tape label."
elif [[ "$tapeid" != "D"[A-B][0-9][0-9][0-9][0-9] ]]; then
echo "Whoops wrong format" 
else
mkltfs --device=/dev/st0 -f --tape-serial="$tapeid" --volume-name="$tapeid"
ltfs -o eject
fi
