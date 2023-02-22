# if

在linux的shell中，if 语句通过关系运算符判断表达式的真假来决定执行哪个分支。

shell有三种 if ... else 语句：
```shell
    if ... fi 语句；
    if ... else ... fi 语句；
    if ... elif ... else ... fi 语句。
```

## if ... fi 语句

if ... else 语句的语法：
```shell
if [ expression ]
then
    Statement(s) to be executed if expression is true
fi

#等同于:
if test 条件;then
	命令
fi

if [[ 条件 ]];then
	命令
fi

[ 条件 ] && command

```
注意：如果 expression 返回 true，then 后边的语句将会被执行；如果返回 false，不会执行任何语句。 最后必须以 fi 来结尾闭合 if。

注意：expression 和方括号([ ])之间必须有空格，否则会有语法错误。

举例：
```shell
#!/bin/sh
a=10
b=20
if [ $a == $b ]
then
    echo "a is equal to b"
fi
if [ $a != $b ]
then
    echo "a is not equal to b"
fi
```
运行结果：
```shell
a is not equal to b
```


## if ... else ... fi 语句

if ... else ... fi 语句的语法：
```shell
if [ expression ]
then
    Statement(s) to be executed if expression is true
else
    Statement(s) to be executed if expression is not true
fi

#等同于:
[ 条件 ] && command1 || command2
```
如果 expression 返回 true，那么 then 后边的语句将会被执行；否则，执行 else 后边的语句。

举例：
```shell
#!/bin/sh
a=10
b=20
if [ $a == $b ]
then
    echo "a is equal to b"
else
    echo "a is not equal to b"
fi
```
执行结果：
```shell
a is not equal to b
```


##  if ... elif ... fi 语句

if ... elif ... fi 语句可以对多个条件进行判断，语法为：
```shell
if [ expression 1 ]
then
    Statement(s) to be executed if expression 1 is true
elif [ expression 2 ]
then
    Statement(s) to be executed if expression 2 is true
elif [ expression 3 ]
then
    Statement(s) to be executed if expression 3 is true
else
    Statement(s) to be executed if no expression is true
fi
```
哪一个 expression 的值为 true，就执行哪个 expression 后面的语句；如果都为 false，那么不执行任何语句。

举例：
```shell
#!/bin/sh
a=10
b=20
if [ $a == $b ]
then
    echo "a is equal to b"
elif [ $a -gt $b ]
then
    echo "a is greater than b"
elif [ $a -lt $b ]
then
    echo "a is less than b"
else
    echo "None of the condition met"
fi
```
运行结果：
```shell
a is less than b
```

if ... else 语句也可以写成一行，以命令的方式来运行，像这样：

```shell
if test $[2*3] -eq $[1+5]; then echo 'The two numbers are equal!'; fi;
```

if ... else 语句也经常与 test 命令结合使用，如下所示：
```shell
num1=$[2*3]
num2=$[1+5]
if test $[num1] -eq $[num2]
then
    echo 'The two numbers are equal!'
else
    echo 'The two numbers are not equal!'
fi
```
运行结果：
```shell
The two numbers are equal!
```

test 命令用于检查某个条件是否成立，与方括号([ ])类似。
