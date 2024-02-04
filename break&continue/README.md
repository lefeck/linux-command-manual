# break and continue

Loops allow you to run one or more commands multiple times until a certain condition is met. However, sometimes you may need to alter the flow of the loop and terminate the loop or only the current iteration.

In Bash, break and continue statements allows you to control the loop execution.

## Bash break Statement

The break statement terminates the current loop and passes program control to the command that follows the terminated loop. It is used to exit from a for, while, until , or select loop. s The syntax of the break statement takes the following form:

```shell
break [n]
```

[n] is an optional argument and must be greater than or equal to 1. When [n] is provided, the n-th enclosing loop is exited. break 1 is equivalent to break.

To better understand how to use the break statement, let’s take a look at the following examples.

In the script below, the execution of the while loop will be interrupted once the current iterated item is equal to 2:

```shell
i=0

while [[ $i -lt 5 ]]
do
echo "Number: $i"
((i++))
if [[ $i -eq 2 ]]; then
break
fi
done
echo 'All Done!'
```

Output:
```shell
Number: 0
Number: 1
All Done!
```

Here is an example of using the break statement inside nested for loops .

When the argument [n] is not given, break terminates the innermost enclosing loop. The outer loops are not terminated:

```shell
for i in {1..3}; do
for j in {1..3}; do
if [[ $j -eq 2 ]]; then
break
fi
echo "j: $j"
done
echo "i: $i"
done

echo 'All Done!'
```
Output:
```text
j: 1
i: 1
j: 1
i: 2
j: 1
i: 3
All Done!
```

If you want to exit from the outer loop, use break 2. Argument 2 tells break to terminate the second enclosing loop:

```shell
for i in {1..3}; do
for j in {1..3}; do
if [[ $j -eq 2 ]]; then
break 2
fi
echo "j: $j"
done
echo "i: $i"
done

echo 'All Done!'
```
Output:
```text
j: 1
All Done!

```

## Bash continue Statement

The continue statement skips the remaining commands inside the body of the enclosing loop for the current iteration and passes program control to the next iteration of the loop.

The syntax of the continue statement is as follows:

```shell
continue [n]
```

The [n] argument is optional and can be greater than or equal to 1. When [n] is given, the n-th enclosing loop is resumed. continue 1 is equivalent to continue.

In the example below, once the current iterated item is equal to 2, the continue statement will cause execution to return to the beginning of the loop and to continue with the next iteration.

```shell
i=0

while [[ $i -lt 5 ]]; do
((i++))
if [[ "$i" == '2' ]]; then
continue
fi
echo "Number: $i"
done

echo 'All Done!'
```
Output:
```text
Number: 1
Number: 3
Number: 4
Number: 5
All Done!
```

The following script prints numbers from 1 through 50 that are divisible by 9.

If a number is not divisible by 9, the continue statement skips the echo command and pass control to the next iteration of the loop.

```shell
for i in {1..50}; do
if [[ $(( $i % 9 )) -ne 0 ]]; then
continue
fi
echo "Divisible by 9: $i"
done
```
Output:
```text
Divisible by 9: 9
Divisible by 9: 18
Divisible by 9: 27
Divisible by 9: 36
Divisible by 9: 45
```

## Conclusion

Loops are one of the fundamental concepts of programming languages. In scripting languages such as Bash, loops are useful for automating repetitive tasks.

The break statement is used to exit the current loop. The continue statement is used to exit the current iteration of a loop and begin the next iteration.