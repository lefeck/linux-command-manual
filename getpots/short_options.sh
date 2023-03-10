#!/bin/bash

function usage() {
      cat << EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-s source_dir] [-d destination] [-u] [-h]"

options:

-s the path of source directory"
-d the path of destination directory"
-u upload file to the specify path
-h Print this help and exit
EOF
    exit
}


upload="false"

while getopts 's:d:uh' OPT; do
    case $OPT in
        s)
            soure_dir="$OPTARG"
            ;;
        d)
            destination_dir="$OPTARG"
            ;;
        u)
            upload="true"
            ;;
        h)
            usage
            ;;
        ?*)
            usage
            ;;
    esac
done

echo "source dir: " $soure_dir
echo "destination dir: "$destination_dir
echo "upload status: "$upload