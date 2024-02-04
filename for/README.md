
# for 循环

## C语言风格的 for 循环

用法如下：
```shell
for((exp1; exp2; exp3))
do
    statements
done
```
说明：
* exp1、exp2、exp3 是三个表达式，其中 exp2 是判断条件，for 循环根据 exp2 的结果来决定是否继续下一次循环；
* statements 是循环体语句，可以有一条，也可以有多条；
* do 和 done 是 shell 中的关键字。

执行流程：

1) 先执行 exp1。

2) 再执行 exp2，如果它的判断结果是成立的，则执行循环体中的语句，否则结束整个 for 循环。

3) 执行完循环体后再执行 exp3。

4) 重复执行步骤 2) 和 3)，直到 exp2 的判断结果不成立，就结束循环。


例子：计算从 1 加到 100 的和。
```shell
#!/bin/bash
sum=0
for ((i=1; i<=100; i++))
do
((sum += i))
done
echo "The sum is: $sum"
```
运行结果：
The sum is: 5050


### for 循环中的三个表达式

for 循环中的 exp1（初始化语句）、exp2（判断条件）和 exp3（自增或自减）都是可选项，都可以省略（但分号;必须保留）。

1. 修改“从 1 加到 100 的和”的代码，省略 exp1：
```shell
#!/bin/bash
sum=0
i=1
for ((; i<=100; i++))
do
   ((sum += i))
done
echo "The sum is: $sum"
```

2. 省略 exp2，就没有了判断条件，如果不作其他处理就会成为死循环，我们可以在循环体内部使用 break 关键字强制结束循环：
```shell
#!/bin/bash
sum=0
for ((i=1; ; i++))
do
    if(( i>100 )); then
    break
    fi
    ((sum += i))
done
echo "The sum is: $sum"
```

3. 省略了 exp3，就不会修改 exp2 中的变量，这时可在循环体中加入修改变量的语句。例如：
```shell
#!/bin/bash
sum=0
for ((i=1; i<=100; ))
do
    ((sum += i))
    ((i++))
done
echo "The sum is: $sum"
```

4. 同时省略三个表达式：

```shell
#!/bin/bash
sum=0
i=0
for (( ; ; ))
do
    if(( i>100 )); then
        break
    fi
    ((sum += i))
    ((i++))
done
echo "The sum is: $sum"
```
实际使用过程中不会这样写，这里仅仅演示使用。

## Python风格的for in循环

用法如下：
```shell
for variable in value_list
do
    statements
done
```
说明：
* variable 表示变量，value_list 表示取值列表，in 是 Shell 中的关键字。
* in value_list 部分可以省略，省略后的效果相当于 in $@。

* 每次循环都会从 value_list 中取出一个值赋给变量 variable，然后进入循环体（do 和 done 之间的部分），执行循环体中的 statements。直到取完 value_list 中的所有值，循环就结束。

for in 循环举例：
```shell
#!/bin/bash
sum=0
for n in 1 2 3 4 5 6
do
     echo $n
     ((sum+=n))
done
echo "The sum is "$sum
```
运行结果：
```shell
1
2
3
4
5
6
The sum is 21
```
### value_list多种写法

取值列表 value_list 的形式有多种，你可以直接给出具体的值，也可以给出一个范围，还可以使用命令产生的结果，甚至使用通配符。

#### 直接给出具体的值

可以在 in 关键字后面直接给出具体的值，多个值之间以空格分隔，比如1 2 3 4 5、"abc" "390" "tom"等。

上面的代码中用一组数字作为取值列表，下面示例用一组字符串作为取值列表：
```shell
#!/bin/bash
for str in "tom" "jack" "luce" "trump"
do
    echo $str
done
```
运行结果：
```shell
"tom" 
"jack" 
"luce" 
"trump"
```
#### 给出一个取值范围

给出一个取值范围的具体格式：
```shell
{start..end}
```
说明：
* start 表示起始值，end 表示终止值；
* 注意中间用两个点号相连，而不是三个点号。这种形式只支持数字和字母。

例如，计算从 1 加到 100 的和：
```shell
#!/bin/bash
sum=0
for n in {1..100}
do
    ((sum+=n))
done
echo $sum
```
运行结果：
```shell
5050
```
再如，输出从 A 到 z 之间的所有字符：
```shell
#!/bin/bash
for c in {A..z}
do
    printf "%c" $c
done
```
输出结果：
```shell
ABCDEFGHIJKLMNOPQRSTUVWXYZ[]^_`abcdefghijklmnopqrstuvwxyz
```
可以发现，shell 是根据 ASCII 码表来输出的。

#### 使用命令的执行结果

使用反引号``或者$()都可以取得命令的执行结果。

例如，计算从 1 到 100 之间所有偶数的和：
```shell
#!/bin/bash
sum=0
for n in $(seq 2 2 100)
do
    ((sum+=n))
done
echo $sum
```
运行结果：
```text
2550
```

seq 是一个 Linux 命令，用来产生某个范围内的整数，并且可以设置步长，不了解的读者请自行百度。seq 2 2 100表示从 2 开始，每次增加 2，到 100 结束。

再如，列出当前目录下的所有 Shell 脚本文件：
```text
#!/bin/bash
for filename in $(ls *.sh)
do
    echo $filename
done
```
运行结果：
```text
demo.sh
test.sh
abc.sh
```

ls 是一个 Linux 命令，用来列出当前目录下的所有文件，*.sh表示匹配后缀为.sh的文件，也就是 Shell 脚本文件。

#### 使用 shell 通配符

Shell 通配符可以认为是一种精简化的正则表达式，通常用来匹配目录或者文件，而不是文本。

使用 shell 通配符获取当前目录下的所有脚本文件，示例：
```text
#!/bin/bash
for filename in *.sh
do
       echo $filename
done
```
运行结果：
```text
demo.sh
test.sh
abc.sh
```

#### 使用特殊变量

Shell 中有多个特殊的变量，例如 $#、$*、$@、$?、$$ 等，在 value_list 中就可以使用它们。

示例：
````shell
#!/bin/bash
function func(){
  for str in $@
  do
      echo $str
  done
}
func C++ Java Python C#
````
运行结果：
```text
C++
Java
Python
C#
```

其实，我们也可以省略 value_list，省略后的效果和使用$@一样。示例：
```shell
#!/bin/bash
function func(){
    for str
    do
        echo $str
    done
}
func C++ Java Python C#
```
运行结果：
```text
C++
Java
Python
C#
```