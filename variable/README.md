# 变量的定义

定义变量的格式：
```shell
KEY="VALUE"
```
变量名的命名须遵循如下规则：
* 变量名区分大小写
* 变量名只能使用英文字母，数字和下划线，首个字符不能以数字开头。
* 变量名不能有特殊符号,比如：不能使用标点符号。
* 等号两边不能有任何空格
* 变量名尽量做到见名知意（一般变量名使用大写）


示例：
```shell
> A="hello world"			#定义变量A
> echo $A			#调用变量A
hello world
> echo ${A}			#还可以这样调用
hello world
> unset A			#取消变量
```


# 变量定义的方式
## 直接赋值
```shell
> A=1234567
> echo $A
1234567
> echo $A:2:4     #表示字符串拼接
1234567:2:4
> echo ${A:2:4}		#表示从A变量中第3个字符开始截取，截取4个字符
3456
```
$变量名 和 ${变量名} 的异同：

* 相同点：都可以调用变量
* 不同点：${变量名} 可以只截取变量的一部分，而 $变量名 不可以

## 赋值给变量
```shell
> B=`date +%F`
> echo $B
2019-04-16

> C=$(uname -r)
> echo $C
2.6.32-696.el6.x86_64
```

## 交互式定义变量（read）
通过终端让用户自己给变量赋值，比较灵活。

语法：read [选项] 变量名

**常见选项：**

| 选项       | 释义                                                       |
| ---------- | ---------------------------------------------------------- |
| -p prompt  | 定义提示用户的信息                                         |
| -n         | 定义字符数（限制变量值的长度）                             |
| -s         | 不显示（不显示用户输入的内容）                             |
| -t timeout | 定义超时时间，默认单位为秒（限制用户输入变量值的超时时间） |

**举例说明：**

用户自己定义变量值
```shell
> read -p "Input your name:" name
Input your name:tom
> echo $name
tom
```
从文件中读取
```shell
> cat 1.txt 
10.1.1.1 255.255.255.0
# read根据变量只读读取文件中的第一行的每一列
> read ip mask < 1.txt 
> echo $ip
10.1.1.1
> echo $mask
255.255.255.0
```
## 定义有类型的变量(declare)

给变量做一些限制，固定变量的类型，比如：整型、只读

用法：declare 选项 变量名=变量值
**常见选项：**

| 选项 | 释义                               | 举例                                         |
| ---- | ---------------------------------- | -------------------------------------------- |
| -i   | 将变量看成整数                     | declare -i A=123                             |
| -r   | 定义只读变量                       | declare -r B=hello                           |
| -a   | 定义普通数组;查看普通数组          |                                              |
| -A   | 定义关联数组;查看关联数组          |                                              |
| -x   | 将变量通过环境导出（定义环境变量） | declare -x AAA=123456 等于 export AAA=123456 |


# 变量的分类

## 本地变量

- 本地变量：当前用户自定义的变量。当前进程中有效，其他进程及当前进程的子进程无效。

## 环境变量

- 环境变量：当前进程有效，并且能够被子进程调用。
  * env：查看系统的环境变量
  * set：查询当前用户的所有变量（本地变量与环境变量）
  * export 变量名=变量值：定义环境变量（或者 变量名=变量值；export 变量名）

## 全局变量

- 全局变量：全局所有的用户和程序都能调用，且继承，新建的用户也默认能调用.

解读相关配置文件

| 文件名              | 说明                               | 备注                                                    |
| ------------------- | ---------------------------------- | ------------------------------------------------------- |
| $HOME/.bashrc       | 当前用户的bash信息,用户登录时读取  | 定义用户的别名、umask、函数等                           |
| $HOME/.bash_profile | 当前用户的环境变量，用户登录时读取 | 定义用户的环境变量                                      |
| $HOME/.bash_logout  | 当前用户退出当前shell时最后读取    | 定义用户退出时执行的程序等                              |
| /etc/bashrc         | 全局的bash信息，所有用户都生效     | 系统和所有用户都生效，用来定义全局的别名、umask、函数等 |
| /etc/profile        | 全局环境变量信息                   | 系统和所有用户都生效，用来定义全局变量                  |

说明：以上文件修改后，都需要重新 source 让其生效或者退出重新登录。

用户登录系统读取相关文件的顺序：

```shell
/etc/profile
$HOME/.bash_profile
$HOME/.bashrc
/etc/bashrc
$HOME/.bash_logout
```

### 内部变量

| 内部变量          | 说明                                                         |
| ----------------- | ------------------------------------------------------------ |
| $BASH             | Bash二进制程序文件的路径                                     |
| $BASH_ENV         | 该环境变量保存一个Bash启动文件路径，当启动一个脚本程序时会去读该环境变量指定的文件。 |
| $BASH_SUBSHELL    | 一个指示子shell(subshell)等级的变量。它是Bash版本3新加入的。 |
| $BASH_VERSINFO[n] | 这个数组含有6个元素，指示了安装的Bash版本的信息。它和$BASH_VERSION相似，但它们还是有一些小小的不同。 |
| $BASH_VERSION     | 安装在系统里的Bash版本。                                     |
| $DIRSTACK         | 在目录堆栈里面最顶端的值(它受pushd和popd的控制)              |
| $EDITOR           | 由脚本调用的默认的编辑器，一般是vi或是emacs。                |
| $EUID             | 有效用户ID                                                   |
| $FUNCNAME         | 当前函数的名字                                               |
| $GLOBIGNORE       | 由通配符(globbing)扩展的一列文件名模式。                     |
| $GROUPS           | 目前用户所属的组                                             |
| $HOME             | 用户的家目录，通常是/home/username                           |
| $HOSTNAME         | 在系统启动时由一个初始化脚本中用hostname命令给系统指派一个名字。然而，gethostname()函数能设置Bash内部变量E$HOSTNAME。 |
| $HOSTTYPE         | 机器类型，像$MACHTYPE一样标识系统硬件。                      |
| $IFS              | 内部字段分隔符                                               |
| $IGNOREEOF        | 忽略EOF：在退出控制台前有多少文件结尾标识（end-of-files,control-D）会被shell忽略。 |
| $LC_COLLATE       | 它常常在.bashrc或/etc/profile文件里被设置，它控制文件名扩展和模式匹配的展开顺序。 |
| $LINENO           | 这个变量表示在本shell脚本中该变量出现时所在的行数。它只在脚本中它出现时有意义，它一般可用于调试。 |
| $MACHTYPE         | 机器类型，识别系统的硬件类型。                               |
| $OLDPWD           | 上一次工作的目录("OLD-print-working-directory",你上一次进入工作的目录) |
| $TZ               | 时区                                                         |
| $MAILCHECK        | 每隔多少秒检查是否有新的信件                                 |
| $OSTYPE           | 操作系统类型                                                 |
| $MANPATH man      | 指令的搜寻路径                                               |
| $PATH             | 可执行程序文件的搜索路径。一般有/usr/bin/, /usr/X11R6/bin/, /usr/local/bin,等等。 |
| $PIPESTATUS       | 此数组变量保存了最后执行的前台管道的退出状态。相当有趣的是，它不一定和最后执行的命令的退出状态一样。 |
| $PPID             | 一个进程的$PPID变量保存它的父进程的进程ID(pid)。用这个变量和pidof命令比较。 |
| $PROMPT_COMMAND   | 这个变量在主提示符前($PS1显示之前)执行它的值里保存的命令。   |
| $PS1              | 这是主提示符（第一提示符），它能在命令行上看见。             |
| $PS2              | 副提示符（第二提示符），它在期望有附加的输入时能看见。它显示像">"的提示。 |
| $PS3              | 第三提示符。它在一个select循环里显示 (参考例子 10-29)。      |
| $PS4              | 第四提示符，它在用-x选项调用一个脚本时的输出的每一行开头显示。它通常显示像"+"的提示。 |
| $PWD              | 工作目录(即你现在所处的目录) ，它类似于内建命令pwd。         |
| $REPLY            | 没有变量提供给read命令时的默认变量．这也适用于select命令的目录，但只是提供被选择的变量项目编号而不是变量本身的值。 |
| $SECONDS          | 脚本已运行的秒数。                                           |
| $SHELLOPTS        | 已经激活的shell选项列表，它是一个只读变量。                  |
| $SHLVL            | SHELL的嵌套级别．指示了Bash被嵌套了多深．在命令行里，$SHLVL是1，因此在一个脚本里，它是2 |
| $TMOUT            | 如果$TMOUT环境变量被设为非零值时间值time，那么经过time这么长的时间后，shell提示符会超时．这将使此shell退出登录 |
| $UID              | 用户ID号，这是当前用户的用户标识号，它在/etc/passwd文件中记录。 |


## 系统变量

- 系统变量（内置bash中变量）：shell 本身已经固定好了它的名字和作用.

| 内置变量  | 含义                                              |
|-----|-------------------------------------------------|
| $#  | 传给脚本的参数个数                                       |
| $0  | 当前执行程序的脚本名称                                     |
| $1  | 传递给该shell脚本的第一个参数                               |
| $2  | 传递给该shell脚本的第二个参数                               |
| $@  | 传给脚本的所有参数的列表, 参数当成一个整体输出，每一个变量参数之间以空格隔开         |
| $*  | 传给脚本的所有参数的列表, 参数是独立的，也是全部输出                     |
| $$  | 脚本运行的当前进程ID号                                    |
| $?  | 上一条命令执行后返回的状态；状态值为0表示执行成功，非0表示执行异常或错误           |
| $!  | Shell最后运行的后台Process的PID(后台运行的最后一个进程的进程ID号)      |
| !$  | 调用最后一条命令历史中的参数      |


### 示例
```shell
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
```
⚠️：if后面的中括号[  $? -eq 0 ]，括号的两边各需要有一个空格。

输出结果：
```shell
root@ubuntu:~# bash dollar.sh 1 2 3 4
Number of parameters of the script: 4
Process PID of the current script: 1282607
Name of the current script: dollar.sh
The first parameter passed in by the current script: 1
The second parameter passed in by the current script: 2
List of all parameters passed in by the current script: 1 2 3 4
List of all parameters passed in by the current script: 1 2 3 4

Traversal using "$@" method
1 :  1
2 :  2
3 :  3
4 :  4

Traversal using "$*" method
1 :  1 2 3 4

Traversal using $* method
1 :  1
2 :  2
3 :  3
4 :  4

Get the current script process.
Process dollar.sh is running!
```

**分析：**
  - $#：传给脚本的参数个数
  - $$：脚本自己的PID 
  - $0：脚本自身的名字 
  - $1 ~ $n：参数1 ~ 参数n 
  - $?：获取函数的返回值或者上一个命令的退出状态 。如果成功就是0，失败为非0。

**$@与$\*的区别：**

$@与$*都可以使用一个变量来来表示所有的参数内容，但这两个变量之间有一些不同之处。
- $@：将输入的所有参数作为一个列表对象
- $*：将输入的所有参数作为一个变量

在上面的例子中，使用$@与$*是，都是用双引号引起来，但当$*不使用双引号时，结果与$@的结果相同。

