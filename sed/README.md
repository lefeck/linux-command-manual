# sed

功能强大的流式文本编辑器

## 说明

**sed** 是一种流编辑器，它是文本处理中非常重要的工具，能够完美的配合正则表达式使用，功能不同凡响。处理时，把当前处理的行存储在临时缓冲区中，称为“模式空间”（pattern space），接着用sed命令处理缓冲区中的内容，处理完成后，把缓冲区的内容送往屏幕。接着处理下一行，这样不断重复，直到文件末尾。文件内容并没有 改变，除非你使用重定向存储输出。Sed主要用来自动编辑一个或多个文件；简化对文件的反复操作；编写转换程序等。

## 语法

**命令格式**

```shell
sed [options] 'command' file(s)
sed [options] -f scriptfile file(s)
```

### 选项

```shell
-e<script>或--expression=<script>：以选项中的指定的script来处理输入的文本文件；
-f<script文件>或--file=<script文件>：以选项中指定的script文件来处理输入的文本文件；
-h或--help：显示帮助；
-n或--quiet或——silent：仅显示script处理后的结果；
-V或--version：显示版本信息。
```

### 参数

文件：指定待处理的文本文件列表。

### sed命令

```shell
a\ # 在当前行下面插入文本。
i\ # 在当前行上面插入文本。
c\ # 把选定的行改为新的文本。
d # 删除，删除选择的行。
D # 删除模板块的第一行。
s # 替换指定字符
h # 拷贝模板块的内容到内存中的缓冲区。
H # 追加模板块的内容到内存中的缓冲区。
g # 获得内存缓冲区的内容，并替代当前模板块中的文本。
G # 获得内存缓冲区的内容，并追加到当前模板块文本的后面。
l # 列表不能打印字符的清单。
n # 读取下一个输入行，用下一个命令处理新的行而不是用第一个命令。
N # 追加下一个输入行到模板块后面并在二者间嵌入一个新行，改变当前行号码。
p # 打印模板块的行。
P # (大写) 打印模板块的第一行。
q # 退出Sed。
b lable # 分支到脚本中带有标记的地方，如果分支不存在则分支到脚本的末尾。
r file # 从file中读行。
t label # if分支，从最后一行开始，条件一旦满足或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾。
T label # 错误分支，从最后一行开始，一旦发生错误或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾。
w file # 写并追加模板块到file末尾。  
W file # 写并追加模板块的第一行到file末尾。  
! # 表示后面的命令对所有没有被选定的行发生作用。  
= # 打印当前行号码。  
# # 把注释扩展到下一个换行符以前。  
```

### sed替换标记

```shell
g # 表示行内全面替换。  
p # 表示打印行。  
w # 表示把行写入一个文件。  
x # 表示互换模板块中的文本和缓冲区中的文本。  
y # 表示把一个字符翻译为另外的字符（但是不用于正则表达式）
\1 # 子串匹配标记
& # 已匹配字符串标记
```

### sed元字符集

```shell
^ # 匹配行开始，如：/^sed/匹配所有以sed开头的行。
$ # 匹配行结束，如：/sed$/匹配所有以sed结尾的行。
. # 匹配一个非换行符的任意字符，如：/s.d/匹配s后接一个任意字符，最后是d。
* # 匹配0个或多个字符，如：/*sed/匹配所有模板是一个或多个空格后紧跟sed的行。
[] # 匹配一个指定范围内的字符，如/[sS]ed/匹配sed和Sed。  
[^] # 匹配一个不在指定范围内的字符，如：/[^A-RT-Z]ed/匹配不包含A-R和T-Z的一个字母开头，紧跟ed的行。
\(..\) # 匹配子串，保存匹配的字符，如s/\(love\)able/\1rs，loveable被替换成lovers。
& # 保存搜索字符用来替换其他字符，如s/love/ **&** /，love这成 **love** 。
\< # 匹配单词的开始，如:/\<love/匹配包含以love开头的单词的行。
\> # 匹配单词的结束，如/love\>/匹配包含以love结尾的单词的行。
x\{m\} # 重复字符x，m次，如：/0\{5\}/匹配包含5个0的行。
x\{m,\} # 重复字符x，至少m次，如：/0\{5,\}/匹配至少有5个0的行。
x\{m,n\} # 重复字符x，至少m次，不多于n次，如：/0\{5,10\}/匹配5~10个0的行。  
```

**Tip:**

- 如果变量中有 `-`、`/` 等字符要用 `\` 进行转义

## sed用法实例

### 替换

* 语法：sed 's/正则匹配条件/s/old/new/g' 文件

```shell
sed -i  '/^SELINUX/s/=.*/=disabled/g' /etc/selinux/config   ##修改，不显示
sed 's/dhcp/static/g' /etc/sysconfig/network-scripts/ifcfg-eth1 ##只是显示，不修改
sed -i 's/dhcp/static/g' /etc/sysconfig/network-scripts/ifcfg-eth1 ##只修改，不显示
sed -i 's/dhcp/static/g' ip ##将所有的dhcp替换为static
sed -i '/^IP1/s/static/dhcp/g' ip ##将IP1开头的行替换
sed -i '2s/static/dhcp/g' ip ##指定特定行号2行替换
sed -i '7s/disabled/enforcing/g' /etc/selinux/config ##修改第7行，disabled为enforcing，开启selinux
```

### 删除

* 语法：sed '/表达式/d' 文件

```shell
sed '/^$/d' ip ##删除空行并显示在屏幕上
sed -i '/IP1/d' ip ##删除包含IP1的行
sed -i '/^IP2/d' ip ##删除以IP2开头的行
sed -i '2d' ip ##删除第二行

# 删除指定行的上一行或下一行
# 删除指定文件的上一行
sed -i -e :a -e '$!N;s/.*n(.*directory)/1/;ta' -e 'P;D' server.xml
 
# 删除指定文件的下一行
sed -i '/pattern="%/{n;d}' server.xml



# 完整实例:
#文件转化成列表
	VIRTUAL=$(tmsh list ltm virtual |grep -E 'virtual'|awk '{print $3}')
	POOL=$(tmsh list ltm virtual |grep -E 'pool'|awk '{print $2}')
	VIRTUAL_ALL=(${VIRTUAL})
	POOL_ALL=(${POOL})
	length=${#VIRTUAL_ALL[@]}
	len=`expr ${length} - 1`
	#获取i索引对应的值
	for((i=0;i<=${len};i++));
	do  
		tmsh show ltm virtual ${VIRTUAL_ALL[$i]} | grep -E 'Ltm|State|Availability|Reason';
		tmsh show ltm pool ${POOL_ALL[$i]} | grep -E 'Ltm|State|Availability|Reason';
	done
} >> vs.log

HANDLE_VIRTUAL_SERVER() {
	#获取重复的值,通过行号打印出来
	NUMBER=`nl -ba vs.log  | grep ${VIRTUAL_ALL[0]}  |  tail -1 | awk  '{print $1}'`
	# 通过行号,删除重复的值,注意:传入的变量NUMBER,需要通过单引号引用
	nl -ba vs.log  | grep ${VIRTUAL_ALL[0]}  |  tail -1 | sed -i ''${NUMBER}',$d' vs.log
}
main(){
	CHECK_VIRTUAL_SERVER
	HANDLE_VIRTUAL_SERVER
}

main
```

### 增加

* 语法：sed ' /表达式/a "需要添加的文字"' 文件

```sh
sed 'a IP3=static' ip ##每一行后都加上IP3=static
sed '3a IP3=static' ip ##只在第3行后加上IP3=static，并显示不修改
sed '3i IP3=static' ip ##只在第3行前加上IP3=static，显示不修改
sed -i '3a IP3=static' ip ##修改，不显示
sed -i '/^IP3/a "test add"' ip ##在以IP3开头的行后添加

#在某行的前一行或后一行添加内容
#匹配行前加
sed -i '/allow 361way.com/i\allow www.361way.com' the.conf.file
 
#匹配行前后
sed -i '/allow 361way.com/a\allow www.361way.com' the.conf.file

# 在某行（指具体行号）前或后加一行内容
# 这里指定的行号是第四行 
sed -i 'N;4a\ddpdf' a.txt
 
sed -i 'N;4i\eepdf' a.txt

```

### 查找

* 语法：sed -n '/表达式/p' 文件

```sh
sed -n '2p' /etc/hosts ##查看第二行
sed -n '/www/p' /var/named/chroot/var/named/linuxfan.cn.zone ##查看包含www的解析记录
sed -n '/.100$/p' /var/named/chroot/var/named/linuxfan.cn.zone ##查看以.100结尾的行
sed -n '2~2p' ip ##从第二行，每隔两行显示

## 找出文件（filename）中包含123和包含abc的行，必须同时满足
cat filename | grep '123' | grep 'abc' 

## 找出文件（filename）中包含123或者包含abc的行,只满足一个条件
grep -E '123|abc' filename

## 用egrep同样可以实现
egrep '123|abc' filename

#获取ip地址

方式一：
ifconfig ens192 | sed -n '2p'| sed 's/.*net //g'| sed 's/ ne.*//g'
192.168.10.168 
注释：
2p: 2表示查找第2行，p表示打印输出
.*net: 查找任意字符串开头，包含net字符的行为开始
 ne.*： 查找以 ne开头的行，以任意字符串结束
sed 's/.*net //g'| sed 's/ ne.*//g' ： 找到以.*net到 ne.*结束，中间的那部分值，这部分也可以用awk截取

ifconfig eth0|sed -n '2p'|sed 's/.*dr://g'|sed 's/ Bc.*//g'    ##注：当sed命令处理的内容为多行内容，则以/作为表达式的分隔，若sed命令处理的内容为单行内容，作为截取的作用，以#号作为分隔符；
10.0.0.9 

方式二：
ifconfig ens192|sed -n '2p'|sed -r 's/(.*net)(.*)(netmask.*$)/\2/g' 
192.168.10.168 
ifconfig eth0|sed -n '2p'|sed -r 's/(.*dr:)(.*)(Bc.*$)/\2/g'    ##-r支持扩展正则，\2将2转义，打印出第二个范围(.*)
10.0.0.9 

方式三：
ifconfig ens192|sed -n '2p'|sed -r 's/.*net (.*) netmask.*$/\1/g' 
192.168.10.168 
ifconfig eth0|sed -n '2p'|sed -r 's/.*dr:(.*) Bc.*$/\1/g'
10.0.0.9 

方式四：
ifconfig ens192 | sed -nr '2s/.*net (.*) netmask.*$/\1/gp' 
192.168.10.168 
ifconfig eth0 | sed -nr '2s/.*dr:(.*) Bc.*$/\1/gp'
10.0.0.9

#获取mac地址
ifconfig ens192 | sed -nr '3s/^.*er (.*)/\1/gp' | awk '{print $1}'
00:0c:29:04:5a:b9
ifconfig eth0|sed -nr '1s/^.*dr (.*)/\1/gp'
00:0C:29:33:C8:75 
ifconfig eth0|sed -n '1p'|sed -r 's/(^.*dr )(.*)/\2/g'
00:0C:29:33:C8:75
ifconfig ens192|sed -n '3p'|sed 's/^.*er //g' | awk '{print $1}'
00:0c:29:04:5a:b9
ifconfig eth0|sed -n '1p'|sed 's/^.*dr //g'     
00:0C:29:33:C8:75
ifconfig eth0|sed -nr '1s/^.*t (.*) 00.*$/\1/gp'
HWaddr
stat /etc/hosts|sed -n '4p'               
Access: (0644/-rw-r--r--) Uid: (  0/  root)  Gid: (  0/  root)
stat /etc/hosts|sed -n '4p'|sed 's#^.*ss: (##g'|sed 's#/-.*$##g'
0644
stat /etc/hosts|sed -n '4p'|sed -r 's#^.*s: \((.*)/-.*$#\1#g'
0644
stat /etc/hosts|sed -nr '4s#^.*s: \((.*)/-.*$#\1#gp'
0644
stat /etc/hosts|sed -nr '4s#(^.*s: \()(.*)(/-.*$)#\2#gp'
0644

# 获取ip地址
ifconfig eth0 | sed -nr 's/(.*)\..*/\1/gp'
注释：
-n  ##读入下一输入行，并从下一条命令开始处理
-r  ##从文件中读取输入行，支持扩展正则表达式。
s   ##尝试根据模式空间匹配扩展正则表达式；
/   ##作为分隔符,默认的格式；
.*  ##匹配所有字符。例：^.*以任意多个字符开头, .*$以任意多个字符结尾
\.  ##例：\.只代表点本身，转义符号，让有特殊身份意义的字符，还原本身
(.*) ##为第一个域,匹配所有字符
\1  ##截取符合第一个域正则的数据
p   ##打印行
注：当sed命令处理的内容为多行内容，则以/作为表达式的分隔，若sed命令处理的内容为单行内容，作为截取的作用，以#号作为分隔符；

sed -nr 's/^ *([0-9]{1,}).*/\1/gp' 
s #这个不用说了吧
^ * #按照文本的格式,匹配前面有任意数量空格的字符.
\([0-9]\{1,\}\) #为第一个域,匹配至少有1个数字
.* #\1正则匹配后面的字符
\1 #截取符合第一个域正则的数据
```


## 常用命令

1. 获取某一段时间内的日志

方法一： 使用sed 命令

```shell
sed -n '/Mar 21 10:10:10/,/Mar 21 10:15:11/p' /var/log/messages < <
```

方法二 ：使用grep命令

```shell
# 获取2023-01-04 15:00:00 - 2023-01-04 15:30:00 日志追加到其它文件中
grep -E '2023-01-04 15:[0-2][0-9]:[0-5][0-9]' /var/log/messages  > messages-tmp.log

## 获取2023-01-07 00:00:00 - 2023-01-07 04:00:00 的日志追加到其它文件中
grep -E '2023-01-07 00:[0-5][0-9]:[0-5][0-9]|2023-01-07 03:[0-5][0-9]:[0-5][0-9]' /var/log/messages  > messages-tmp.log 

```

# 去除行首空格

1. **行首空格 **

```sh
sed 's/^[ \t]*//g' 
```

说明：

* 第一个/的左边是s表示替换，即将空格替换为空
* 第一个/的右边是表示后面的以xx开头中括号表示“或”，空格或tab中的任意一种。这是正则表达式的规范。 中括号右边是*，表示一个或多个。
* 第二个和第三个\中间没有东西，表示空
* g表示替换原来buffer中的，sed在处理字符串的时候并不对源文件进行直接处理，先创建一个buffer，但是加g表示对原buffer进行替换

含义：用空字符去替换一个或多个用空格或tab开头的字符串

2. **行末空格 **

```sh
sed 's/[ \t]*$//g' 
```

表示以xx结尾的字符串为对象,删除后面的空格



3. **删除所有的空格**

```sh
sed s/[[:space:]]//g
```
