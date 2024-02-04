#!/bin/bash

echo "The PID of the shell script task.sh: $$"
echo "In task.sh get variable A=$A from dispatcher.sh"

export A=2

echo -e "In task.sh: variable A=$A\n"