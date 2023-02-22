# 字符串

字符串（String）就是一系列字符的组合。字符串是 Shell 编程中最常用的数据类型之一

举例：

```
str1=www.google.com
str2="I come from uk"
str3='hello world $n'
```

三种形式的区别：

1) 由单引号`' '`包围的字符串：

- 任何字符都会原样输出，在其中，使用变量是不会被解析的。
- 字符串中不能出现单引号，即使对单引号进行转义也不行。


2) 由双引号`" "`包围的字符串：

- 如果其中包含了某个变量，那么该变量会被解析（得到该变量的值），而不是原样输出。
- 字符串中可以出现双引号，只要它被转义了就行。


3) 不被引号包围的字符串

- 不被引号包围的字符串中出现变量时也会被解析，这一点和双引号`" "`包围的字符串一样。
- 字符串中不能出现空格，否则空格后边的字符串会作为其他变量或者命令解析。



示例:

```sh
#!/bin/bash

n=hk
str1=www.google.com.$n 
str2="I come from \"$n\""
str3='hello world $n'

echo $str1
echo $str2
echo $str3
```

运行结果：

```sh
www.google.com.hk
I come from  "hk" 
hello world $n
```

str1 中包含了`$n`，它被解析为变量 n 的引用。

str2 中包含了引号，但是被转义了（由反斜杠`\`开头的表示转义字符）。str2 中也包含了`$n`，它也被解析为变量 n 的引用。

str3 中也包含了`$n`，但是仅仅是作为普通字符，并没有解析为变量 n 的引用。

## 获取字符串长度

在 Shell 中获取字符串长度很简单，具体方法如下：

> ${#string_name}

string_name 表示字符串名字。

示例：

```sh
#!/bin/bash

str="https://www.google.com.hk"

echo ${#str}
```

运行结果：

```
25
```
# 字符串拼接

在 Shell 中你不需要使用任何运算符，将两个字符串并排放在一起就能实现拼接，非常简单。


示例：

```sh
#!/bin/bash
name="uk"
url="http://www.google.com."
str1=$name$url  #中间不能有空格
str2="$name $url"  #如果被双引号包围，那么中间可以有空格
str3=$name": "$url  #中间可以出现别的字符串
str4="$name: $url"  #这样写也可以
str5="${name}Script: ${url}index.html"  #这个时候需要给变量名加上大括号

echo $str1
echo $str2
echo $str3
echo $str4
echo $str5
```

运行结果：

```
ukhttp://www.google.com.
uk http://www.google.com.
uk: http://www.google.com.
uk: http://www.google.com.
ukScript: http://www.google.com.index.html
```

对于第 7 行代码，$name 和 $url 之间之所以不能出现空格，是因为当字符串不被任何一种引号包围时，遇到空格就认为字符串结束了，空格后边的内容会作为其他变量或者命令解析。

对于第 10 行代码，加`{ }`是为了帮助解释器识别变量的边界。

# 字符串替换

有时候，我们给脚本参数一个默认值，当我们不传入参数的时候，将使用默认值，传入参数的时候替换默认值作为当前值使用。

#缺省值的替换
```shell
${parameter:-word} # 为空替换
${parameter:=word} # 为空替换，并将值赋给$parameter变量
${parameter:?word} # 为空报错
${parameter:+word} # 不为空替换
```

**${parameter}**：和$parameter是相同的，都是表示变量parameter的值，可以把变量和字符串连接。

示例：

```sh
# 变量和字符串拼接
machine_id=${USER}@${HOSTNAME} 
echo "$machine_id"   #root@ubuntu

# get system $PATH
echo "Original \$PATH = $PATH" # Original $PATH = /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin

PATH=${PATH}:/opt/bin  
#在脚本的生存期内，能额外增加路径/opt/bin到环境变量$PATH中去. 
echo "Current\$PATH = $PATH" # Original $PATH = /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/opt/bin  
```

**${parameter-default}, ${parameter:-default}**：如果变量没有被设置，使用默认值。`${parameter-default}`和`${parameter:-default}`几乎是相等的。它们之间的差别是：当一个参数已被声明，但是值是NULL的时候两者不同。

示例：
```shell
echo "====== \${parameter-alt_value} ======"

# 不定义username变量时,获取到的name为-后的值, 即使用默认值
name=${username-tom}
echo "name=$name"  # name=tom

# 定义username变量时,获取到的name为定义username的值,即为空
username=""
name=${username-tom}
echo "name=$name"  # name=


echo "====== \${parameter:-alt_value} ======"

# 不定义username变量时,获取到的name为-后的值
name=${username:-tom}
echo "name=$name"  # name=tom

# 定义了username变量,但是为空时,获取到的name为:-后的值,,即使用默认值
username=""
name=${username:-tom}
echo "name=$name"   # name=tom

# 定义了username变量,但是不为空时,获取到的name为定义username的值
username="jack"
name=${username:-tom}
echo "name=$name"   # name=jack
```

**${parameter=default}, ${parameter:=default}**：如果变量parameter没有设置，把它设置成默认值。除了引起的当变量被声明且值是空值时有些不同外，两种形式几乎相等。

示例：
```shell
echo "===== \${parameter+alt_value} ====="

sub=${subject+math}
echo "sub = $sub"      # sub =

subject2=
sub=${subject2+english}
echo "sub = $sub"      # sub = english

subject3=computer
sub=${subject3+english}
echo "sub = $sub"      # sub = english


echo "====== \${parameter:+alt_value} ======"


sub=${subject4:+english}
echo "sub = $sub"      # sub = 

subject5=
sub=${subject5:+english} 
echo "sub = $sub"     # sub = 
# 产生与a=${subject5+english}不同。


subject6=computer
sub=${subject6:+english} 
echo "sub = $sub"     # sub = english
```



**${parameter?err_msg}, ${parameter:?err_msg}**：如果变量parameter已经设置，则使用该值，否则打印err_msg错误信息。[demo20](https://wangchujiang.com/shell-tutorial/example/demo20)

示例：
```shell
#!/bin/bash
# 变量替换和"usage"信息

: ${1?"Usage: $0 ARGUMENT"}
#  如果没有提供命令行参数则脚本在这儿就退出了,
#+ 并打印了错误信息.
#    usage-message.sh: 1: Usage: usage-message.sh ARGUMENT

echo "These two lines echo only if command-line parameter given."
echo "command line parameter = \"$1\""

exit 0  # 仅在命令行参数提供时，才会在这儿退出.

# 分别检查有命令行参数和没有命令行参数时的退出状态。
# 如果有命令行参数,则"$?"为0.
# 否则, "$?"为1.
```

# 字符串截取

Shell 截取字符串通常有两种方式：从指定位置开始截取和从指定字符（子字符串）开始截取。

## 从指定位置开始截取

这种方式需要两个参数：除了指定起始位置，还需要截取长度，才能最终确定要截取的字符串。

既然需要指定起始位置，那么就涉及到计数方向的问题，到底是从字符串左边开始计数，还是从字符串右边开始计数。答案是 Shell 同时支持两种计数方式。

### 从字符串左边开始计数

如果想从字符串的左边开始计数，那么截取字符串的具体格式如下：

> ${string: start :length}

其中，string 是要截取的字符串，start 是起始位置（从左边开始，从 0 开始计数），length 是要截取的长度（省略的话表示直到字符串的末尾）。

例如：

```sh
url="c.biancheng.net"

#其中的 2 表示左边数第3个字符开始，9 表示字符的长度。
echo ${url: 2: 9}

# output : biancheng
```

再如：

```sh
url="c.biancheng.net"

# 其中的 2 表示左边第3个字符开始，省略 length，一直到结束。
echo ${url: 2}

# output: biancheng.net
```


### 从字符串右边开始计数

如果想从字符串的右边开始计数，那么截取字符串的具体格式如下：

> ${string: 0-start :length}

同第1种格式相比，第2种格式仅仅多了`0-`，这是固定的写法，专门用来表示从字符串右边开始计数。

注意：

- 从左边开始计数时，起始数字是 0（这符合程序员思维）；从右边开始计数时，起始数字是 1（这符合常人思维）。计数方向不同，起始数字也不同。
- 不管从哪边开始计数，截取方向都是从左到右。

例如：

```sh
url="c.biancheng.net"
# 其中的 0-13 表示右边算起第13个字符开始，9 表示字符的长度。
echo ${url: 0-13: 9}

# output: biancheng
```

从右边数，`b`是第 13 个字符。

再如：

```sh
url="c.biancheng.net"

# 表示从右边数第13个字符开始，省略 length，直接截取到字符串末尾。
echo ${url: 0-13}

# output: biancheng.net
```
注：（左边的第一个字符是用 0 表示，右边的第一个字符用 0-1 表示）

## 从指定字符（子字符串）开始截取

这种截取方式无法指定字符串长度，只能从指定字符（子字符串）截取到字符串末尾。Shell 可以截取指定字符（子字符串）右边的所有字符，也可以截取左边的所有字符。

### 使用#号截取右边字符

使用#号可以截取指定字符（或者子字符串）右边的所有字符，具体格式如下：
> ${string#*chars}

其中，string 表示要截取的字符，chars 是指定的字符（或者子字符串），*是通配符的一种，表示任意长度的字符串。*chars连起来使用的意思是：忽略左边的所有字符，直到遇见 chars（chars 不会被截取）。

例子：

假设有变量 `var=http://www.aaa.com/123.htm.`

1. \#号截取，删除左边字符，保留右边字符。

例如：
```shell
var=http://www.aaa.com/123.htm.
echo ${var#*//}
```
其中 var 是变量名，# 号是运算符，*// 表示从左边开始删除第一个 // 号及左边的所有字符
即删除 http://

输出结果：
```shell
www.aaa.com/123.htm
```
2. \## 号截取，删除左边字符，保留右边字符。

代码如下:
```shell
var=http://www.aaa.com/123.htm.
echo ${var##*/}
```
##*/ 表示从左边开始删除最后（最右边）一个/号及左边的所有字符
即删除 http://www.aaa.com/

输出结果：
```shell
123.htm
```

### 使用 % 截取左边字符

使用%号可以截取指定字符（或者子字符串）左边的所有字符，具体格式如下：
```shell
${string%chars*}
```
3. %号截取，删除右边字符，保留左边字符

代码如下:
```shell
var=http://www.aaa.com/123.htm.
echo ${var%/*}
```
%/* 表示从右边开始，删除第一个 / 号及右边的字符

输出结果：
```shell
http://www.aaa.com
```

4. %% 号截取，删除右边字符，保留左边字符

代码如下:
```shell
var=http://www.aaa.com/123.htm.
echo ${var%%/*}
```

%%/* 表示从右边开始，删除最后（最左边）一个 / 号及右边的字符

输出结果：
```shell
http:
```

## 总结

最后，对以上 8 种格式做一个总结，如下表：

| 格式                       | 说明                                                         |
| -------------------------- | ------------------------------------------------------------ |
| ${string: start :length}   | 从 string 字符串的左边第 start 个字符开始，向右截取 length 个字符。 |
| ${string: start}           | 从 string 字符串的左边第 start 个字符开始截取，直到最后。    |
| ${string: 0-start :length} | 从 string 字符串的右边第 start 个字符开始，向右截取 length 个字符。 |
| ${string: 0-start}         | 从 string 字符串的右边第 start 个字符开始截取，直到最后。    |
| ${string#*chars}           | 从 string 字符串第一次出现 *chars 的位置开始，截取 *chars 右边的所有字符。 |
| ${string##*chars}          | 从 string 字符串最后一次出现 *chars 的位置开始，截取 *chars 右边的所有字符。 |
| ${string%*chars}           | 从 string 字符串第一次出现 *chars 的位置开始，截取 *chars 左边的所有字符。 |
| ${string%%*chars}          | 从 string 字符串最后一次出现 *chars 的位置开始，截取 *chars 左边的所有字符。 |