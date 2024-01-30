# xargs 命令

xargs命令是一个方便的 Linux 实用程序，用于将输入数据转换为参数字符串。

xargs（eXtended ARGuments）是给命令传递参数的一个过滤器，也是组合多个命令的一个工具。

xargs 可以将管道或标准输入（stdin）数据转换成命令行参数，也能够从文件的输出中读取数据。

xargs 也可以将单行或多行文本输入转换为其他格式，例如多行变单行，单行变多行。

xargs 默认的命令是 echo，这意味着通过管道传递给 xargs 的输入将会包含换行和空白，不过通过 xargs 的处理，换行和空白将被空格取代。

xargs 是一个强有力的命令，它能够捕获一个命令的输出，然后传递给另外一个命令。

xargs命令的作用，是将标准输入转为命令行参数, 不会去执行转为命令行参数。

**命令格式：**

```
COMMAND |xargs -item  COMMAND
```

**参数：**

- -a file 从文件中读入作为 stdin
- -e flag ，注意有的时候可能会是-E，flag必须是一个以空格分隔的标志，当xargs分析到含有flag这个标志的时候就停止。
- -p 当每次执行一个argument的时候询问一次用户。
- -n num 后面加次数，表示命令在执行的时候一次用的argument的个数，默认是用所有的。
- -t 表示先打印命令，然后再执行。
- -i 或者-I，后面跟着一个占位符字符串用于实现替换。每次占位符出现在目标命令中时，xargs都会将其替换为标准输入中的数据。在命令 中find /path -name '*.txt' | xargs -I {} cp {} ~/backups，只要该%符号出现在目标cp命令中，xargs就会将其替换为 中的输入find。同一命令中可以发生多个替换。此命令设置-L为1一次仅处理一行。
- -r no-run-if-empty 当xargs的输入为空的时候则停止xargs，不用再去执行了。
- -s num 命令行的最大字符数，指的是 xargs 后面那个命令的最大命令行字符数。
- -L num 从标准输入一次读取 num 行送给 command 命令。
- -l 同 -L。
- -d delim 分隔符，默认的xargs分隔符是回车，argument的分隔符是空格，这里修改的是xargs的分隔符。
- -x exit的意思，主要是配合-s使用。。
- -P 修改最大的进程数，默认是1，为0时候为as many as it can。



### 实例

xargs 用作替换工具，读取输入数据重新格式化后输出。

定义一个测试文件，内有多行文本数据：

```
# cat << eof > test.txt
a b c d e f g
h i j k l m n
o p q
r s t
u v w x y z
eof
```

多行输入单行输出：

```
# cat test.txt | xargs
a b c d e f g h i j k l m n o p q r s t u v w x y z
```


#### -n 参数

-n 参数指定每次传递几个参数，作为命令行参数。

```
# cat test.txt | xargs -n3
a b c
d e f
g h i
j k l
m n o
p q r
s t u
v w x
y z
```
上面命令指定将每3项（-n 3）标准输入作为命令行参数，分别执行一次命令（cat test.txt）。

-d 选项可以自定义一个定界符：

```shell
# echo "nameXnameXnameXname" | xargs -dX

name name name name
```

结合 -n 选项使用：

```shell
# echo "nameXnameXnameXname" | xargs -dX -n2
name name
name name
```

#### -I 参数

xargs 使用 -I 指定一个占位符字符串{}，这个字符串在 xargs 扩展时会被替换掉，当 -I 与 xargs 结合使用，每一个参数命令都会被执行一次：

备份当前目录下所有*.jpg文件将每个文件重命名为原来的文件名后加上.bak后缀。
```shell
find . -name "*.jpg" -print0 | xargs -0 -I {} mv {} {}.bak
# 还原成之前的内容
find . -name "*.jpg.bak" -print0 | xargs -0 -I {} sh -c 'mv "$1" "${1%.bak}"' _ {}
```

复制所有图片文件到 /data/images 目录下：
```shell
ls *.jpg | xargs -I {} cp {} /data/images
```


#### -d 参数与分隔符

默认情况下，xargs将换行符和空格作为分隔符，把标准输入分解成一个个命令行参数。
```shell
$ echo "one two three" | xargs mkdir
```
上面代码中，mkdir会新建三个子目录，因为xargs将one two three分解成三个命令行参数，执行mkdir one two three。

-d 参数可以更改分隔符。

```shell
$ echo -e "a\tb\tc" | xargs -d "\t" echo a b c
```
上面的命令指定制表符\t作为分隔符，所以a\tb\tc就转换成了三个命令行参数。echo命令的-e参数表示解释转义字符。


#### -p 参数，-t 参数

使用xargs命令以后，由于存在转换参数过程，有时需要确认一下到底执行的是什么命令。

-p 参数打印出要执行的命令，询问用户是否要执行。
```shell
$ echo 'one two three' | xargs -p touch 
```
上面的命令执行以后，会打印出最终要执行的命令，让用户确认。用户输入y以后（大小写皆可），才会真正执行。

-t 参数则是打印出最终要执行的命令，然后直接执行，不需要用户确认。
```shell
$ echo 'one two three' | xargs -t rm 
```

#### xargs 结合 find 使用

xargs特别适合find命令。用 rm 删除太多的文件时候，可能得到一个错误信息 **/bin/rm Argument list too long.**，而无法执行，改用xargs就可以，因为它对每个参数执行一次命令。
```shell
find . -type f -name "*.log" -print0 | xargs -0 rm -f
```

由于xargs默认将空格作为分隔符，所以不太适合处理文件名，因为文件名可能包含空格。

find命令有一个参数-print0，当使用这个参数时，找到的每个文件路径后添加一个空字符（null）作为分隔符，而不是换行符。然后，xargs命令的-0参数表示用null当作分隔符。
```shell
$ find /tmp -type f -print0 | xargs -0 rm
```
上面命令删除/path路径下的所有文件。由于分隔符是null，所以处理包含空格的文件名，也不会报错。


找出所有 txt 文件以后，对每个文件搜索一次是否包含字符串abc。

```shell
$ find . -name "*.txt" | xargs grep "abc"
```

xargs -0 将 \0 作为定界符。

统计一个源代码目录中所有 php 文件的行数：

```shell
find . -type f -name "*.php" -print0 | xargs -0 wc -l
```

查找所有的 jpg 文件，并且压缩它们：

```shell
find . -type f -name "*.jpg" -print | xargs tar -czvf images.tar.gz
```

### xargs 其它应用

假如你有一个文件包含了很多你希望下载的 URL，你能够使用 xargs下载所有链接：
```shell
# cat url-list.txt | xargs wget -c
```

批量创建目录

```shell
$ echo "model repository service controller db" | xargs mkdir
```
等同于mkdir model repository service controller db。






