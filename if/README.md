
# 条件判断

## 条件判断语法格式

| 格式            | 示例(判断当前目录下file1文件是否存在)                        |
| --------------- | ------------------------------------------------------------ |
| test 条件表达式 | test -e ./file1; echo $? (注意:条件判断完毕后是没有输出的，真假结果需要单独用echo来显示） |
| [ ]             | [ -e ./file1 ]; echo $? (注意:括号两边都必须要有空格；不支持正则) |
| [[ ]]           | [[ -e ./file1 ]]; echo $? (注意:括号两边都必须要有空格，此表达式中支持正则) |

## 条件判断相关参数

### 判断文件类型

| 判断参数 | 含义                                                 |
| -------- | ---------------------------------------------------- |
| -e       | 判断文件是否存在（任意类型文件、这个文件可以是目录） |
| -f       | 判断文件是否存在并且是一个普通文件                   |
| -d       | 判断文件是否存在并且是一个目录                       |
| -L       | 判断文件是否存在并且是一个软链接文件                 |
| -b       | 判断文件是否存在并且是一个块设备文件                 |
| -S       | 判断文件是否存在并且是一个套接字文件                 |
| -c       | 判断文件是否存在并且是一个字符设备文件               |
| -p       | 判断文件是否存在并且是一个命名管道文件               |
| -s       | 判断文件是否存在并且文件大小大于零                   |

**举例说明：**

```shell
[root@localhost ~]# test -e hello;echo $?                   #只要文件存在条件为真
0
[root@localhost ~]# [ -d /shell/dir1 ];echo $?            #判断目录是否存在，存在条件为真
1
[root@localhost ~]# [ ! -d /shell/dir1 ];echo $?      #判断目录是否存在,不存在条件为真
0
[root@localhost ~]# [[ -f /shell/1.sh ]];echo $?      #判断文件是否存在，并且是一个普通的文件
1
```

### 判断文件权限

| 判断参数 | 含义                       |
| -------- | -------------------------- |
| -r       | 当前用户对其是否可读       |
| -w       | 当前用户对其是否可写       |
| -x       | 当前用户对其是否可执行     |
| -u       | 是否有suid，高级权限冒险位 |
| -g       | 是否sgid，高级权限强制位   |



### 判断文件新旧

说明：新旧指的是**文件的修改时间**

| 判断参数        | 含义                                                         |
| --------------- | ------------------------------------------------------------ |
| file1 -nt file2 | file1是否比file2新                                           |
| file1 -ot file2 | file1是否比file2旧                                           |
| file1 -ef file2 | file1是否file2为同一文件(注意：两文件内容一样，不代表两个是同一个文件）；或者用于判断硬链接，file1和file2是否指向同一inode |

**举例说明：**

```shell
[root@localhost ~]# file1=test.txt
[root@localhost ~]# file2=test.sh
[root@localhost ~]# ln -s test.txt test.txt.bak
[root@localhost ~]# file3=test.txt.bak
[root@localhost ~]# [ ${file1} -nt ${file2} ];echo $?
0
[root@localhost ~]# [ ${file1} -ot ${file2} ];echo $?
1
[root@localhost ~]# [ ${file1} -ef ${file2} ];echo $?
1

[root@localhost ~]# [ ${file1} -ef ${file3} ];echo $?
0
```

### 整数判断

| 判断参数 | 含义                      |
| -------- | ------------------------- |
| -eq      | 等于（Equal）             |
| -ne      | 不等于（Not equal）       |
| -gt      | 大于（Greater Than）      |
| -lt      | 小于（Less than）         |
| ge       | 大于等于（Greater equal） |
| le       | 小于等于（Less equal）    |

数值比较示例:

```sh
[root@localhost ~]# a=2
[root@localhost ~]# b=6
[root@localhost ~]# c=8
[root@localhost ~]# d=6
[root@localhost ~]# [ $a -eq $b ];echo $?
1
[root@localhost ~]# [ $a -ne $b ];echo $?
0
[root@localhost ~]# [ $a -le $b ];echo $?
0
[root@localhost ~]# [ $d -gt $b ];echo $?
1
[root@localhost ~]# [ $c -lt $b ];echo $?
1
[root@localhost ~]# [ $d -ge $b ];echo $?
0
[root@localhost ~]# [ `id -u` -eq 0 ];echo $?
0
[root@localhost ~]# [ $(id -u) -eq 0 ] && echo this is root
this is root
```

### 字符串判断

| 判断参数           | 含义                                                         |
| ------------------ | ------------------------------------------------------------ |
| -z                 | 判断是否为空字符串；字符串长度为0则成立（the length of string is zero） |
| -n                 | 判断是否为非空字符串；字符串长度不为0则成立（the length of string is nonzero） |
| string1 = string2  | 判断字符串是否相等（注意：等号两边一定都要有空格，两边都没有空格会将整个判断视为一个字符串，值永远为真 |
| string1 != string1 | 判断字符串是否不相等（注意：判断符号两边一定都要有空格，两边都没有空格会将整个判断视为一个字符串，值永远为真 |

字符串比较示例:

```shell
[root@localhost ~]# a=hello
[root@localhost ~]# b=world
[root@localhost ~]# [ -z $a ];echo $?
1
[root@localhost ~]# [ -n $b ];echo $?
0
[root@localhost ~]# [ $a = $b ];echo $?
1
[root@localhost ~]# [ $a = $b ];echo $?
1
[root@localhost ~]# [ "$a" = "$b" ];echo $?
1
[root@localhost ~]# [ "$a" == "$b" ];echo $?
1
[root@localhost ~]# [ "$a" != "$b" ];echo $?
0
[root@localhost ~]# [ '' = $a ];echo $?
1
[root@localhost ~]# [[ '' = $a ]];echo $?
1
```

### 多重条件判断

| 判断参数  | 含义   | 举例                                                         |
| --------- | ------ | ------------------------------------------------------------ |
| -a 和 &&  | 逻辑与 | [ 1 -eq 1 -a 1 -ne 0 ] [ 1 -eq 1 ] && [ 1 -ne 0 ] (注意：[]判断语句结构中-a符号是在一个判断语句中使用；&&是在两个判断语句中使用；) [[ 1 -eq 1 && 1 -ne 0 ]] (注意：**[[ ]] 判断语法不支持 -a 和 -o**) |
| -o 和\|\| | 逻辑或 | [ 1 -eq 1 -o 1 -ne 0 ] [ 1 -eq 1 ] \|\| [ 1 -ne 0 ] (注意：[]判断语句结构中-a符号是在一个判断语句中使用；&&是在两个判断语句中使用) [[ 1 -eq 1 \|\| 1 -ne 0 ]] (注意：**[[ ]] 判断语法不支持 -a 和 -o**) |

#### 特别说明

* && 前面的表达式为真，才会执行后面的代码
* || 前面的表达式为假，才会执行后面的代码
* ; 只用于分割命令或表达式


## 总结

1. 符号 ; 和 && 和 || 都可以用来分割命令或者表达式
2. 分号 ; 完全不考虑前面的语句是否正确执行，都会执行 ; 号后面的内容
3. && 符号，需要考虑 && 前面的语句的正确性，前面语句正确执行才会执行 && 后的内容；反之亦然
4. || 符号，需要考虑 || 前面的语句的非正确性，前面语句执行错误才会执行 || 后内容；反之亦然
5. 如果 && 和 || 一起出现，按照以上原则，从左往右依次执行


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
