#!/bin/bash
#
echo "Number of parameters of the script:" $#
echo "Process PID of the current script:" $$
echo "Name of the current script:" $0
echo "The first parameter passed in by the current script:" $1
echo "The second parameter passed in by the current script:" $2
echo "List of all parameters passed in by the current script:" $@
echo "List of all parameters passed in by the current script:" $*

echo ""
echo "Traversal using \"\$@\" method"
n=1
for i in "$@"; do
  echo "$n : " $i
  let n+=1
done

echo ""
echo "Traversal using \"\$*\" method"
n=1
for i in "$*"; do
  echo "$n : " $i
  let n+=1
done


echo ""
echo "Traversal using \$* method"
n=1
for i in $*; do
  echo "$n : " $i
  let n+=1
done

echo ""
echo "Get the current script process"
ps -fe | grep $$ > /dev/null 2>&1
if [ $? -eq 0 ]
then
    echo "Process $0 is running!"
else
    echo "Process $0 don not run!"
fi