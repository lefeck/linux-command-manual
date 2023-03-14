

# diff

比较给定的两个文件的不同

## 补充说明

**diff命令** 在最简单的情况下，比较给定的两个文件的不同。如果使用“-”代替“文件”参数，则要比较的内容将来自标准输入。diff命令是以逐行的方式，比较文本文件的异同处。如果该命令指定进行目录的比较，则将会比较该目录中具有相同文件名的文件，而不会对其子目录文件进行任何比较操作。

### 语法

```shell
diff(选项)(参数)
```

### 选项

```shell
-<行数>：指定要显示多少行的文本。此参数必须与-c或-u参数一并使用；
-a或——text：diff预设只会逐行比较文本文件；
-b或--ignore-space-change：不检查空格字符的不同；
-B或--ignore-blank-lines：不检查空白行；
-c：显示全部内容，并标出不同之处；
-C<行数>或--context<行数>：与执行“-c-<行数>”指令相同；
-d或——minimal：使用不同的演算法，以小的单位来做比较；
-D<巨集名称>或ifdef<巨集名称>：此参数的输出格式可用于前置处理器巨集；
-e或——ed：此参数的输出格式可用于ed的script文件；
-f或-forward-ed：输出的格式类似ed的script文件，但按照原来文件的顺序来显示不同处；
-H或--speed-large-files：比较大文件时，可加快速度；
-l<字符或字符串>或--ignore-matching-lines<字符或字符串>：若两个文件在某几行有所不同，而之际航同时都包含了选项中指定的字符或字符串，则不显示这两个文件的差异；
-i或--ignore-case：不检查大小写的不同；
-l或——paginate：将结果交由pr程序来分页；
-n或——rcs：将比较结果以RCS的格式来显示；
-N或--new-file：在比较目录时，若文件A仅出现在某个目录中，预设会显示：Only in目录，文件A 若使用-N参数，则diff会将文件A 与一个空白的文件比较；
-p：若比较的文件为C语言的程序码文件时，显示差异所在的函数名称；
-P或--unidirectional-new-file：与-N类似，但只有当第二个目录包含了第一个目录所没有的文件时，才会将这个文件与空白的文件做比较；
-q或--brief：仅显示有无差异，不显示详细的信息；
-r或——recursive：比较子目录中的文件；
-s或--report-identical-files：若没有发现任何差异，仍然显示信息；
-S<文件>或--starting-file<文件>：在比较目录时，从指定的文件开始比较；
-t或--expand-tabs：在输出时，将tab字符展开；
-T或--initial-tab：在每行前面加上tab字符以便对齐；
-u，-U<列数>或--unified=<列数>：以合并的方式来显示文件内容的不同；
-v或——version：显示版本信息；
-w或--ignore-all-space：忽略全部的空格字符；
-W<宽度>或--width<宽度>：在使用-y参数时，指定栏宽；
-x<文件名或目录>或--exclude<文件名或目录>：不比较选项中所指定的文件或目录；
-X<文件>或--exclude-from<文件>；您可以将文件或目录类型存成文本文件，然后在=<文件>中指定此文本文件；
-y或--side-by-side：以并列的方式显示文件的异同之处；
--help：显示帮助；
--left-column：在使用-y参数时，若两个文件某一行内容相同，则仅在左侧的栏位显示该行内容；
--suppress-common-lines：在使用-y参数时，仅显示不同之处。
```

### 参数

- 文件1：指定要比较的第一个文件；
- 文件2：指定要比较的第二个文件。

### 实例

将目录`/usr/li`下的文件"test.txt"与当前目录下的文件"test.txt"进行比较，输入如下命令：

```shell
diff /usr/li test.txt     #使用diff指令对文件进行比较
```

比较目录a和目录b中**文件内容**的差别，会对目录下的每个文件中的每一行都做比较。

```
diff -r /b/ /b/
```

`<`代表的行是directory1中有而directory2没有的文件，`>`则相反，是directory2中有而directory1中没有。

命令结果同上

```
diff -Naur /a/ /b/
```



# rpm2cpio

将RPM软件包转换为cpio格式的文件

## 补充说明

**rpm2cpio命令** 用于将rpm软件包转换为cpio格式的文件。

### 语法

```shell
rpm2cpio(参数)
```

### 参数

文件：指定要转换的rpm包的文件名。

### 实例

```shell
rpm2cpio ../libstdc++-4.3.0-8.i386.rpm | cpio -idv
```


# rmdir 命令

rmdir（remove directory）命令删除空的目录。

### 语法

```
rmdir [-p] dirName
```

**参数**：

- -p 是当子目录被删除后使它也成为空目录的话，则一起删除。

### 实例

将工作目录下，名为 AAA 的子目录删除 :

```
rmdir AAA
```

在工作目录下的 BBB 目录中，删除名为 Test 的子目录。若 Test 删除后，BBB 目录成为空目录，则 BBB 亦予删除。

```
rmdir -p BBB/Test
```



# command

使用 command 命令可以抑制正常的 Shell 函数查找。只有内置命令或在 PATH 中找到的命令才会被执行。

## 用法

```
command [-pVv] command [arg ...]
    Execute a simple command or display information about commands.
    
    Runs COMMAND with ARGS suppressing  shell function lookup, or display
    information about the specified COMMANDs.  Can be used to invoke commands
    on disk when a function with the same name exists.
    
    Options:
      -p    use a default value for PATH that is guaranteed to find all of
            the standard utilities
      -v    print a description of COMMAND similar to the `type' builtin #显示命令的描述
      -V    print a more verbose description of each COMMAND
    
    Exit Status:
    Returns exit status of COMMAND, or failure if COMMAND is not found.
```

## 实例1

```sh
root@ubuntu:~# command -v ls
alias ls='ls --color=auto'
root@ubuntu:~# command -v pwd
pwd

# command -v 可以判断一个命令是否支持
if command -v docker >/dev/null 2>&1;then 
   echo "yes"
else 
   echo "no"
fi
```

### 实例2

判断 shellcheck 命令是否存在，不存在则安装shellcheck ：

```sh
#!/bin/bash

set -eo pipefail

SHELLCHECK_VERSION=0.9.0
INSTALL_DIR="${HOME}/bin/"
mkdir -p "$INSTALL_DIR" || true

function install_shellcheck {
  if ! command -v shellcheck &> /dev/null; then
      MACHINE=$(uname -m);
      TMPFILE=$(mktemp)
      rm "$TMPFILE"
      mkdir -p "$TMPFILE"/
      curl -L -o "$TMPFILE"/out.xz "https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.$(uname -s | tr '[:upper:]' '[:lower:]').${MACHINE}.tar.xz"
      tar -xf "$TMPFILE"/out.xz -C "$TMPFILE"/
      cp "${TMPFILE}/shellcheck-v${SHELLCHECK_VERSION}/shellcheck" "${INSTALL_DIR}/shellcheck"
      rm -rf "$TMPFILE"
      chmod +x "${INSTALL_DIR}"/shellcheck
  fi
}

install_shellcheck
```



# mktemp

Linux使用/tmp目录来存放不需要永久保留的文件。 mktemp命令专门用来创建临时文件，并且其创建的临时文件是唯一的。
shell会根据mktemp命令创建临时文件，但不会使用默认的umask值（管理权限的）。

## 语法

```bash
mktemp [OPTION]... [TEMPLATE]
Create a temporary file or directory, safely, and print its name.
TEMPLATE must contain at least 3 consecutive 'X's in last component.
If TEMPLATE is not specified, use tmp.XXXXXXXXXX, and --tmpdir is implied.
Files are created u+rw, and directories u+rwx, minus umask restrictions.
    Options:
			-q # 执行时若发生错误，不会显示任何信息
			-u # 暂存文件会在mktemp结束前先行删除
			-d # 创建一个目录而非文件
```



## 实例

mktemp命令可以在创建临时文件时指定文件的命名格式，在后面加几个X，就会生成几个字符的文件名,需要注意X最少为3个

如果指定了命名格式，即XXXX，则会在当前目录生成文件，如果没有指定，则会在/tmp目录下创建一个名为（tmp.+任意十个字符)的临时文件

```sh
[root@localhost ~]# mktemp
/tmp/tmp.r1A46FTGmj
[root@localhost ~]# mktemp XXXXX
gC73N
```

-t 参数：

会强制将临时文件创建在系统的临时文件目录下，而不是当前目录，且创建时mktemp命令会返回临时文件的全路径

```sh
[root@localhost ~]# mktemp -t XXXXX
/tmp/EPlRT
```

-d 参数：

会在当前目录下, 创建一个临时目录而不是临时文件; 如果不指定X, 默认会在/tmp目录下创建一个临时目录。

```sh
[root@localhost ~]# mktemp -d XXXXX
TYgOR
[root@localhost ~]# ll
drwx------. 2 root root 6 Feb 21 16:54 TYgOR

[root@localhost ~]# mktemp -d
/tmp/tmp.H7yJ6NP072
```

-u 参数：

仅返回一个文件名，并不会真的创建文件，可以用来生成随机数

```sh
[root@localhost ~]# mktemp -u XXXXXXXXXX
3DOSGBrWNi
```




# set

set命令可以定义脚本的运行方式，变量的获取方式，脚本的执行过程，脚本的测试。

## 用法

```sh
set [-abefhkmnptuvxBCHP] [-o option-name] [--] [arg ...]
		-a 　标示已修改的变量，以供输出至环境变量。
		-b 　使被中止的后台程序立刻回报执行状态。
		-C 　转向所产生的文件无法覆盖已存在的文件。
		-d 　Shell预设会用杂凑表记忆使用过的指令，以加速指令的执行。使用-d参数可取消。
		-e 　若指令传回值不等于0，则立即退出shell。
		-f　 　取消使用通配符。
		-h 　自动记录函数的所在位置。
		-H Shell 　可利用"!"加<指令编号>的方式来执行history中记录的指令。
		-k 　指令所给的参数都会被视为此指令的环境变量。
		-l 　记录for循环的变量名称。
		-m 　使用监视模式。
		-n 　只读取指令，而不实际执行。
		-p 　启动优先顺序模式。
		-P 　启动-P参数后，执行指令时，会以实际的文件或目录来取代符号连接。
		-t 　执行完随后的指令，即退出shell。
		-u 　当执行时使用到未定义过的变量，则显示错误信息。
		-v 　显示shell所读取的输入值。
		-x 　执行指令后，会先显示该指令及所下的参数。
		+<参数> 　取消某个set曾启动的参数。
```



# shell脚本读取文件

主要介绍Shell逐行读取文件的4种方法：while循环法、重定向法、管道法、文件描述符法。

**方法1：while循环中执行效率最高，最常用的方法。**

代码如下:


```sh
function while_read_LINE_bottom(){
while read LINE
do
		echo $LINE
done < $FILENAME
}
```

注释：这种方式在结束的时候需要执行文件，就好像是执行完的时候再把文件读进去一样。



**方法2 ：管道法: **

代码如下:


```sh
Function While_read_LINE(){
cat $FILENAME | while read LINE
do
		echo $LINE
done
}
```

注释：把这种方式叫做管道法，相比大家应该可以看出来了吧。当遇见管道的时候管道左边的命令的输出会作为管道右边命令的输入然后被输入出来。



**方法3： 文件描述符法**

代码如下:


```sh
function while_read_line_fd(){
exec 3<&0
exec 0<$FILENAME
while read LINE
Do
		echo $LINE
exec 0<&<3
}
```

注释： 这种方法分2步骤:

* 第一步: 通过将所有内容重定向到文件描述符3来关闭文件描述符0.为此我们用了语法exec 3<&0 。

* 第二步: 将输入文件放送到文件描述符0，即标准输入。



**方法4 for 循环**

代码如下:

```sh
function for_in_file(){
for line in `cat $FILENAME`
do
		echo $line
done
}
```

注释：这种方式是通过for循环的方式来读取文件的内容相比大家很熟悉了，这里不多说。对各个方法进行测试，看那方法的执行效率最高。



测试用例：

首先编写脚本文件，读取的测试文件在/var/log/syslog。然后通过下面的脚本来测试各个方法的执行效率，脚本很简单。

代码如下:

```sh
#!/bin/bash
FILENAME="$1"
TIMEFILE="/tmp/loopfile.out" > $TIMEFILE
SCRIPT=$(basename $0)

function usage(){
		echo -e "\nUSAGE: $SCRIPT file \n"
exit 1
}

function while_read_bottom(){
while read LINE
do
		echo $LINE
done < $FILENAME
}


function while_read_line(){
cat $FILENAME | while read LINE
do
		echo $LINE
done
}


function while_read_line_fd(){
exec 3<&0
exec 0< $FILENAME
while read LINE
do
		echo $LINE
done
exec 0<&3
}

function for_in_file(){
for i in `cat $FILENAME`
do
	echo $i
done
}

if [ $# -lt 1 ] ; then
usage
fi

echo -e " \n starting file processing of each method\n"
echo -e "method 1:"
echo -e "function while_read_bottom"
time while_read_bottm >> $TIMEFILE
echo -e "\n"
echo -e "method 2:"
echo -e "function while_read_line "
time while_read_line >> $TIMEFILE
echo -e "\n"
echo -e "method 3:"
echo "function while_read_line_fd"
time while_read_line_fd >>$TIMEFILE
echo -e "\n"
echo -e "method 4:"
echo -e "function for_in_file"
time for_in_file >> $TIMEFILE
```

脚本输出内容如下：

```sh
root@ubuntu:~# ll -h /var/log/syslog                   
-rw-r----- 1 syslog adm 1.9M Jan 10 13:18 /var/log/syslog
# 执行脚本：
root@ubuntu:~# ./whiles  /var/log/syslog                                  
 
 starting file processing of each method

method 1:
function while_read_bottom

real    0m2.238s
user    0m1.387s
sys     0m0.848s


method 2:
function while_read_line 

real    0m4.266s
user    0m1.759s
sys     0m3.428s


method 3:
function while_read_line_fd

real    0m2.261s
user    0m1.418s
sys     0m0.842s


method 4:
function for_in_file

real    0m3.110s
user    0m2.022s
sys     0m1.091s
```

下面我们对各个方法按照速度进行排序。
代码测试结果如下:

```sh
real    0m2.238s method 1 （while bottom尾部读取法）
real    0m2.261s method 3 （while fd标识符法）
real    0m4.266s method 2 （while 管道法）
real    0m3.110s method 4 （for 循环法）
```

由此可见在各个方法中，while bottom尾部读取法效率最高，而for循环执行效率最低。

# paste工具

paste 工具用于合并两个文件的文件行（file1第一行后面接file2第一行）

## 常用选项：

    -d：自定义间隔符，默认是tab
    -s：串行处理，非并行（第一行全第一个文件，第二行全第二个文件）

## 示例
合并两个文件，将file2追加到file1后面：
```shell
> cat file1 file2 > file1
> cat file2 >> file1
```

# tr工具

tr 用于字符转换，替换和删除；主要用于删除文件中控制字符或进行字符转换

## 语法和选项

**语法**

用法1：命令的执行结果交给tr处理，其中string1用于查询，string2用于转换处理
> commands|tr 'string1' 'string2'

用法2：tr处理的内容来自文件，记住要使用"<"标准输入
> tr 'string1' 'string2' < filename

用法3：根据选项匹配 string1 进行相应操作，如删除操作
> tr [options] 'string1' < filename

**常用选项：**

    -d 删除字符串1中所有输入字符。
    -s 删除所有重复出现字符序列，只保留第一个；即将重复出现字符串压缩为一个字符串 "abcaaa" > "abca"

常匹配字符串：

| 字符串         | 含义                 | 备注                                                         |
| -------------- | -------------------- | ------------------------------------------------------------ |
| a-z或[:lower:] | 匹配所有小写字母     | 所有大小写和数字[a-zA-Z0-9]                                  |
| A-Z或[:upper:] | 匹配所有大写字母     |                                                              |
| 0-9或[:digit:] | 匹配所有数字         |                                                              |
| [:alnum:]      | 匹配所有字母和数字   |                                                              |
| [:alpha:]      | 匹配所有字母         |                                                              |
| [:blank:]      | 所有水平空白         |                                                              |
| [:punct:]      | 匹配所有标点符号     |                                                              |
| [:space:]      | 所有水平或垂直的空格 |                                                              |
| [:cntrl:]      | 所有控制字符         | \n Ctrl-J 换行<br/>\r Ctrl-M 回车<br/>\f Ctrl-L 走行换页<br/>\t Ctrl-I tab键 |

## 举例
```shell
> cat 3.txt 	自己创建该文件用于测试
ROOT:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
aaaaaaaaaaaaaaaaaaaa
bbbbbb111111122222222222233333333cccccccc
hello world 888
666
777
999

# 测试命令
tr -d '[:/]' < 3.txt 				删除文件中的:和/
cat 3.txt |tr -d '[:/]'			删除文件中的:和/
tr '[0-9]' '@' < 3.txt 			将文件中的数字替换为@符号
tr '[a-z]' '[A-Z]' < 3.txt 		将文件中的小写字母替换成大写字母
tr -s '[a-z]' < 3.txt 			匹配小写字母并将重复的压缩为一个
tr -s '[a-z0-9]' < 3.txt 			匹配小写字母和数字并将重复的压缩为一个
tr -d '[:digit:]' < 3.txt 		删除文件中的数字
tr -d '[:blank:]' < 3.txt 		删除水平空白
tr -d '[:space:]' < 3.txt 		删除所有水平和垂直空白
```

