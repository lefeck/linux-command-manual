#!/bin/bash

echo "The PID of the shell script $0 before it is executed is $$"

export A=1
echo "In $0: variable A=$A"

case $1 in
        --exec)
                echo -e "using the exec method of execution\n"
                exec ./task.sh ;;
        --source)
                echo -e "using the source method of execution\n"
                . ./task.sh ;;
        *)
                echo -e "using the fork method of execution by default\n"
                ./task.sh ;;
esac

echo "The PID of the shell script $0 after it is executed is $$"
echo -e "In $0: variable A=$A\n"