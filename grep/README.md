# grep命令

功能：输入文件的每一行中查找字符串。

基本用法：
```shell
grep [-acinv] [--color=auto] [-A n] [-B n] '搜寻字符串' 文件名
参数说明：
-a：将二进制文档以文本方式处理
-c：显示匹配次数
-i：忽略大小写差异
-n：在行首显示行号
-A：After的意思，显示匹配字符串后n行的数据
-B：before的意思，显示匹配字符串前n行的数据
-v：显示没有匹配行-A：After的意思，显示匹配部分之后n行-B：before的意思，显示匹配部分之前n行
--color：以特定颜色高亮显示匹配关键字
```
--color 选项是个非常好的选项，可以让你清楚的明白匹配了那些字符。最好在自己的.bashrc或者.bash_profile文件中加入：
```shell
alias grep=grep --color=auto
```

每次grep搜索之后，自动高亮匹配效果了。‘搜寻字符串’是正则表达式，注意为了避免shell的元字符对正则表达式的影响，请用单引号（’’）括起来，千万不要用双引号括起来（””）或者不括起来。


### 基本正则表达式BRE集合

- 匹配字符
- 匹配次数
- 位置锚定

| 符号          | 作用                                                  |
|-------------|-----------------------------------------------------|
| ^           | 尖角号，用于模式的最左侧，如 "^oldboy"，匹配以oldboy单词开头的行            |
| $           | 美元符，用于模式的最右侧，如"oldboy$"，表示以oldboy单词结尾的行             |
| ^$          | 组合符，表示空行                                            |
| .           | 匹配任意一个且只有一个字符，不能匹配空行                                |
| \           | 转义字符，显示特殊含义的字符本身的含义，例如`\.`代表小数点                |
| \n          | 换行符                                                 |
| \r          | 匹配回车                                                |
| \w          | 匹配任意一个字符和数字                                         |
| \d          | 匹配数字                                        |
| \s          | 匹配任意的空白符                                        |
| *           | 匹配前一个字符（连续出现）0次或1次以上 ，重复0次代表空，即匹配所有内容               |
| .*          | 匹配所有字符。例：^.* 以任意多个字符开头，.*$以任意多个字符结尾                 |
| ^.*         | 组合符，匹配任意多个字符开头的内容                                   |
| .*$         | 组合符，匹配以任意多个字符结尾的内容                                  |
| [abc]       | 匹配[]集合内的任意一个字符，a或b或c，可以写[a-c]                       |
| `[^abc]`    | 匹配除了^后面的任意字符，a或b或c，^表示对[abc]的取反                     |
| `<pattern>` | 匹配完整的内容                                             |
| <或>         | 定位单词的左侧，和右侧，如`<chao>`可以找出"The chao ge"，缺找不出"yuchao" |
| [1-9]       | 表示匹配括号内的范围内的任意字符 |
| a\{n,m\}    | 重复n到m次前一个重复的字符。若用egrep、sed -r可以去掉斜线 |
| \{n,\}      | 重复至少n 次前一个重复的字符。若用egrep、sed -r可以去掉斜线 |
| \{n\}       | 重复n 次前一个重复的字符。若用egrep、sed -r可以去掉斜线 |
| \{,m}\      | 重复少于m次 |


### 扩展正则表达式ERE集合

扩展正则必须用 grep -E 才能生效

| 字符     | 作用                                         |
|--------| -------------------------------------------- |
| +      | 匹配前一个字符1次或多次，前面字符至少出现1次 |
| [:/]+  | 匹配括号内的":"或者"/"字符1次或多次          |
| ?      | 匹配前一个字符0次或1次，前面字符可有可无     |
| ｜      | 表示或者，同时过滤多个字符串                 |
| ()     | 分组过滤，被括起来的内容表示一个整体         |
|        |                                              |
| a{n,m} | 匹配前一个字符最少n次，最多m次               |
| a{n,}  | 匹配前一个字符最少n次                        |
| a{n}   | 匹配前一个字符正好n次                        |
| a{,m}  | 匹配前一个字符最多m次                        |

Tip:

BRE与ERE元字符对应表

| 基本正则表达式 | 扩展正则表达式 |
|--------|---------|
| \\?     | ?       |
| \\+     | +       |
| \\|     | \|      |
| \\{ \\} | { }     |
| \\( \\) | ( )     |

## 示例

```shell

cat /proc/meminfo |grep -e Mem -e Cache -e Swap     ##查看系统内存、缓存、交换分区-e的作用是匹配多个表达式

grep -R -o -n -E  '[a-z0-9_]+\@[a-z0-9_]+\.[a-z]{2,4}' /etc/     ##查找/etc目录下的所有文件中的邮件地址；-R递归，-n表示匹配的行号，-o只输出匹配内容，-E支持扩展正则表达式，

grep -R -c 'HOSTNAME' /etc/ |grep -v "0$"     ##查找/etc/目录下文件中包含“HOSTNAME”的次数，-c统计匹配次数，-v取反

grep -R -l 'HOSTNAME' /etc/           ##查找包含“HOSTNAME”的文件名，-l显示匹配的文件名，-L显示不匹配的文件名

dmesg | grep -n --color=auto 'eth'       ##查找内核日志中eth的行，显示颜色及行号
dmesg | grep -n -A3 -B2 --color=auto 'eth'     ##用 dmesg 列出核心信息，再以 grep 找出内含 eth 那行,在关键字所在行的前两行与后三行也一起找出出来显示

cat /etc/passwd |grep -c bash$         ##统计系统中能登录的用户的个数

touch /tmp/{123,123123,456,1234567}.txt   ##创建测试文件，以下三条命令是一样的效果，匹配文件名123，可以包含1个到多个
ls |grep -E '(123)+'
ls |grep '\(123\)\+'
ls |egrep '(123)+'

ps -ef |grep -c httpd             ##统计httpd进程数量
grep -C 4 'games' --color /etc/passwd       ##显示games匹配的“-C”前后4行
grep ^adm /etc/group             ##查看adm组的信息
ip a |grep -E '^[0-9]' |awk -F : '{print $2}'     ##获取网卡名称
ifconfig eth0 |grep -E -o 'inet addr:[^ ]*' |grep -o '[0-9.]*'   ##截取ip地址，[^ ]*表示以非空字符作为结束符，[0-9.]*表示数字和点的组合
ip a |grep inet |grep eth0 |grep -o "inet[^/]*" |grep -o "[0-9.]*"  ##截取ip地址
ifconfig eth0 |grep -i hwaddr |awk '{print $5}'   ##截取MAC地址
ip a |grep -A 3 "eth0" |grep link/ether |grep -o "ether[^r]*" |grep -o -E "[0-9a-f:]+"|grep -E "[0-9a-f:]{2}$"      ##截取MAC地址

# 获取本机的ip地址
ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"

grep "^m" .log      ##过滤输出以m开头的行
grep "m$" test.log 
grep -vn "^$" test.log       ##过滤空行
grep -o "0*" test.log 
grep -o "oldb.y" test.log 
grep "\.$" test.log       ##以.结尾的行
grep "0\{3\}" test.log       ##重复三次


# 获取某一段时间的日志
方法一： 使用sed 命令
sed -n '/2022-12-28 23:15:00/,/2022-12-29 00:15:00/p' f5-openstack-agent.log-20220620.log  <  <f5-agent-2022622.log

方法二 ：使用grep命令
# 获取2023-01-04 15:00:00 - 2023-01-04 15:30:00 日志追加到其它文件中
grep -E '2023-01-04 15:[0-2][0-9]:[0-5][0-9]' /var/log/messages.log  > messages-tmp.log 

## 获取2023-01-07 00:00:00 - 2023-01-07 04:00:00 的日志追加到其它文件中
grep -E '2023-01-07 00:[0-5][0-9]:[0-5][0-9]|2023-01-07 03:[0-5][0-9]:[0-5][0-9]' /var/log/messages.log  > messages-tmp.log 

```

### Grep 'OR' 或操作
```shell
grep "pattern1\|pattern2" file.txt
grep -E "pattern1|pattern2" file.txt
grep -e pattern1 -e pattern2 file.txt
egrep "pattern1|pattern2" file.txt

awk '/pattern1|pattern2/' file.txt
sed -e '/pattern1/b' -e '/pattern2/b' -e d file.txt

#找出文件（filename）中包含123或者包含abc的行
grep -E '123|abc' filename 
#用egrep同样可以实现
egrep '123|abc' filename 
#awk 的实现方式
awk '/123|abc/' filename 
```

### Grep 'NOT' 非操作
```shell

grep -v 'pattern1' file.txt
# 去除文件中的空行/空格/tab
grep -vE '^\s*$' file.txt

# 去除文件中的空行
grep -vE '^$' file.txt

# 去除文件中的空行和#开头的行
grep -vE '^#|^$' file.txt

# 去除文件中的空行/空格/tab和#开头的行
grep -vE '^\s*$|^#'  file.txt

awk '!/pattern1/' file.txt
sed -n '/pattern1/!p' file.txt

##删除两个文件相同部分
grep -v -f file1 file2 && grep -v -f file2 file1 

##计算并集
sort -u a.txt b.txt

##计算交集
grep -F -f a.txt b.txt | sort | uniq

##计算差集
grep -F -v -f b.txt a.txt | sort | uniq
```

### Grep 'AND'  与操作

```shell
grep -E 'pattern1.*pattern2' file.txt # in that order
grep -E 'pattern1.*pattern2|pattern2.*pattern1' file.txt # in any order
grep 'pattern1' file.txt | grep 'pattern2' # in any order

awk '/pattern1.*pattern2/' file.txt # in that order
awk '/pattern1/ && /pattern2/' file.txt # in any order
sed '/pattern1.*pattern2/!d' file.txt # in that order
sed '/pattern1/!d; /pattern2/!d' file.txt # in any order

#显示既匹配 pattern1 又匹配 pattern2 的行。
grep pattern1 files | grep pattern2 
```

## 字符集

标识字符集，有如下几种：
```shell
[[:upper:]]   [A-Z]
[[:lower:]]   [a-z]
[[:digit:]]   [0-9]
[[:alnum:]]   [0-9a-zA-Z]
[[:space:]]   空格或tab
[[:alpha:]]   [a-zA-Z]
[[:punct:]]   标点符号字符,如：,;.:等
[[:blank:]]   空格与定位符
```

### **grep实例**

(1).显示/proc/meminfo文件中以大写或小写s开头的行；

```crystal
# grep -i '^[Ss]' /proc/meminfo
```

(2).显示/etc/passwd文件中其默认shell为非/sbin/nologin的用户；

```crystal
# grep -v '/sbin/nologin$' /etc/passwd | cut -d: -f1
```

(3).显示/etc/passwd文件中其默认shell为/bin/bash的用户

进一步：仅显示上述结果中其ID号最大的用户

```lua
# grep '/bin/bash$' /etc/passwd | cut -d: -f1 | sort -n -r | head -1
```

(4).找出/etc/passwd文件中的一位数或两位数；

```objectivec
# grep '\<[[:digit:]]\{1,2\}\>' /etc/passwd
```

(5).显示/boot/grub/grub.conf中至少一个空白字符开头的行

```crystal
# grep '^[[:space:]]\+.*' /boot/grub/grub.conf
```

(6).显示/etc/rc.d/rc.sysinit文件中，以#开头，后面跟至少一个空白字符，而后又有至少一个非空白字符的行；

```crystal
# grep '^#[[:space:]]\+[^[:space:]]\+' /etc/rc.d/rc.sysinit
```

(7).找出netstat -tan命令执行结果中包含’LISTEN’的行；

```crystal
# netstat -tan | grep 'LISTEN[[:space:]]*$
```

(8).添加用户bash,testbash,basher,nologin(SHELL为/sbin/nologin)，而找出当前系统上其用户名和默认SHELL相同的用户；

```objectivec
# grep '\(\<[[:alnum:]]\+\>\).*\1$' /etc/passwd
```

(9).扩展题：新建一个文本文件，假设有如下内容：

```shell
# cat grep.txt
He like his lover.

He love his lover.

He like his liker.

He love his liker.
```

找出其中最后一个单词是由此前某单词加r构成的行；

```objectivec
# grep '\(\<[[:alpha:]]\+\>\).*\1r' grep.txt
```

(10).显示当前系统上root、centos或user1用户的默认shell及用户名；

```crystal
# grep -E '^(root|centos|user1\>)' /etc/passwd
```

(11).找出/etc/rc.d/init.d/functions文件中某单词后面跟一对小括号’()”的行；

```objectivec
# grep -o '\<[[:alpha:]]\+\>()' /etc/rc.d/init.d/functions
```

(12).使用echo输出一个路径，而使用egrep取出其基名；

```dart
# echo /etc/rc.d/ | grep -o '[^/]\+/\?$' | grep -o '[^/]\+'
```

https://codeantenna.com/a/V6dMlVcmif