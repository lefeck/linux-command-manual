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
> echo ${A:2:4}		表示从A变量中第3个字符开始截取，截取4个字符
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

