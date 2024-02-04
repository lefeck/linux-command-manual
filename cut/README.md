
#  cut

cut 命令在Linux和Unix中的作用是从文件中的每一行中截取出一些部分，并输出到标准输出中。我们可以使用 cut 命令从一行字符串中于以字节，字符，字段（分隔符）等单位截取一部分内容出来。

## cut 命令和语法

cut 命令的基本语法：

```shell
cut OPTION... [FILE]...
```
cut选项:
* -f : 提取指定的字段，cut 命令使用 Tab 作为默认的分隔符。
* -d : Tab 是默认的分隔符，使用这一选项可以指定自己的分隔符。
* -b : 提取指定的字节，也可以指定一个范围。
* -c : 提取指定的字符，可以是以逗号分隔的数字的列表，也可以是以连字符分隔的数字的范围。
* –complement : 补充选中的部分，即反选。
* –output-delimiter : 修改输出时使用的分隔符。
* --only-delimited : 不输出不包含分隔符的列。

### 指定分隔符

最常用的选项是 -d 和 -f 的组合，这会根据 -d 指定的分隔符和 -f 列出的字段来提取内容。
例如在这个例子中只打印出 /etc/passwd 文件每一行的第一个字段，用的分隔符是 :
```shell
$ cut -d':' -f1 /etc/passwd
root
bin
daemon
adm
lp
sync
shutdown
halt
mail
operator
games
alvin
liangxu
```

以如下的名为 context.txt 的文本文件和 /etc/passwd 文件来为例来进行说明。
```text
$ cat  << EOF > content.txt
Ubuntu Linux
Microsoft Windows
OsX El Capitan
Unix
FreeBSD
EOF
```
这个例子用空格作为分隔符打印 content.txt 文件的第一个字段
```text
$ cut -d " " -f1 content.txt
Ubuntu
Microsoft
OsX
Unix
FreeBSD
```

在下面这个例子中我们提取了多个字段。这里，我们使用冒号（:）分隔符从文件 /etc/passwd 中包含字符串 /bin/bash 的行提取第一和第六个字段。
```shell
$ grep "/bin/bash" /etc/passwd | cut -d':' -f1,6
root:/root
alvin:/home/alvin
```
要显示字段的某个范围，可以指定开始和结束的字段，中间用连字符（-）连接，如下所示：
```shell
$ grep "/bin/bash" /etc/passwd | cut -d':' -f1-4,6,7
root:x:0:0:/root:/bin/bash
alvin:x:1000:1000:/home/alvin:/bin/bash
```
### 补全选择的输出

要补全选择输出的字段（即反选），使用 --complement 选项。这一选项输出所有的字段，除了指定的字段。

在下面这个例子中输出 /etc/passwd 文件中包含 /bin/bash 的行中除了第二个字段以外的所有字段：
```shell
$ grep "/bin/bash" /etc/passwd | cut -d':' --complement -f2
root:0:0:root:/root:/bin/bash
```
### 指定输出的分隔符

使用 --output-delimiter 可以指定输出的分隔符。输入的分隔符由 -d 来指定，而输出分隔符和输入分隔符默认是一样的。

我们先以下面的例子来测试不指定输出分隔符时的输出
```shell
$  cut -d: -f1,7  /etc/passwd |  sort |  uniq -u
_apt:/usr/sbin/nologin
backup:/usr/sbin/nologin
bin:/usr/sbin/nologin
daemon:/usr/sbin/nologin
dnsmasq:/usr/sbin/nologin
games:/usr/sbin/nologin
gnats:/usr/sbin/nologin
irc:/usr/sbin/nologin
landscape:/usr/sbin/nologin
list:/usr/sbin/nologin
lp:/usr/sbin/nologin
lxd:/bin/false
```
现在加上--output-delimiter选项，将输出分隔符指定为空格：
```shell
$  cut -d: -f1,7 --output-delimiter ' ' /etc/passwd |  sort |  uniq -u
_apt /usr/sbin/nologin
backup /usr/sbin/nologin
bin /usr/sbin/nologin
daemon /usr/sbin/nologin
dnsmasq /usr/sbin/nologin
games /usr/sbin/nologin
gnats /usr/sbin/nologin
irc /usr/sbin/nologin
landscape /usr/sbin/nologin
list /usr/sbin/nologin
lp /usr/sbin/nologin
lxd /bin/false
```
再测试一个例子，用分隔符让每一行打印一个字段。 将 --output-delimiter 指定为 $'\n' 表换行。

输出结果为：
```shell
$ grep root /etc/passwd | cut -d':' -f1,6,7 --output-delimiter=$'\n'
root
/root
/bin/bash
operator
/root
/sbin/nologin
```
### 以字符的方式提取内容

-c选项可以用来根据字符位置进行提取，注意空格和Tab也以字符来处理。

打印 context.txt 文件每一行的第一个字符，如下：
```shell
$ cut -c 1 content.txt
U
M
O
U
F
```
下面显示 context.txt 文件每一行的第一至七个字符；
```shell
$ cut -c 1-7 content.txt
Ubuntu
Microso
OsX El
Unix
FreeBSD
```
再测试一下只指定开始或结束的位置。

下面提取第二个到最后一个字符：
```shell
$ cut -c2- content.txt
buntu Linux
icrosoft Windows
sX El Capitan
nix
reeBSD
```
提取第一到第四个字符：
```shell
cut -c-4 content.txt
Ubun
Micr
OsX
Unix
Free
```

### 根据字节提取

使用-b选项通过指定字节的位置来选择一行的某一部分，使用逗号分隔每个指定位置，或用连字符 - 指定一个范围。

提取 content.txt 文件每一行的第一，二，三个字节：
```shell
$ cut -b 1,2,3 content.txt
Ubu
Mic
OsX
Uni
Fre
```
我们也可以用如下命令列出一个范围；
```shell
$ cut -b 1-3,5-7 content.txt
Ubutu
Micoso
OsXEl
Uni
FreBSD
```
### 实用示例

cut 是一个实用的命令，常常和其他Linux或Unix命令结合使用 。

例如1: 提取 ps 命令中的 USER，PID和COMMAND：
```shell
ps -L u n | tr -s " " | cut -d " " -f 2,3,14-
USER PID COMMAND
0 676 /sbin/agetty -o -p -- \u --keep-baud 115200,38400,9600 ttyS0 vt220
0 681 /sbin/agetty -o -p -- \u --noclear tty1 linux
0 23174 -bash
0 26737 ps -L u n
0 26738 tr -s
0 26739 cut -d -f 2,3,14-
```

例如2: 提取内存的 total，used和free值，并保存到一个文件中。

```shell
$ free -m | tr -s ' ' | sed '/^Mem/!d' | cut -d" " -f2-4 >> memory.txt
$ cat memory.txt
985 86 234
SHELL

```