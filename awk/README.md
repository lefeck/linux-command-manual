# awk文本处理

## awk简介

awk是一种编程语言，用于在linux/unix下对文本和数据进行处理，数据可以来自标准输入、一个或多个文件，或其它命令的输出，它支持用户自定义函数和动态正则表达式等先进功能，是linux/unix下的一个强大编程工具，它在命令行中使用，但更多的是作为脚本来使用；

awk 的处理文本和数据的方式是这样的，它逐行扫描文件，从第一行到最后一行，寻找匹配的寻找匹配的特定模式的行，并在这些行上进行你想要的操作，如果没有指定处理动作，则把匹配的行显示到标准输出(屏幕)，如果没有指定模式，则所有被操作所指定的行都被处理；

awk 分别代表其作者是三个人，分别是Alfred Aho、Brian Kernighan、Peter Weinberger。gawk是awk的GNU版本，它提供了Bell实验和GNU的一些扩展。

## awk语法格式
```shell
awk [options] 'commands' filenames
awk [options] -f awk-script-file filenames

说明：

options： -F　　定义输入字段分隔符，默认的分隔符是空格或制表符(tab)
command： 
    BEGIN{}       {}            END{}
    行处理前      行处理         行处理后

```
示例：
```shell
awk 'BEGIN{print 1/2} {print "ok"} END{print "-----------"}' /etc/hosts
0.5
ok
ok
ok
-----------
```
BEGIN{}　通常用于定义一些变量，例如BEGIN{FS=":";OFS="---"}

### awk命令格式

awk 'pattern' filename                //示例：awk -F: '/root/' /etc/passwd        
awk '{action}' filename               //示例：awk -F: '{print $1}' /etc/passwd            
awk 'pattern {action}' filename       //示例：awk -F: '/root/{print $1,$3}' /etc/passwd        
//示例：awk 'BEGIN{FS=":"} /root/{print $1,$3}' /etc/passwd
command |awk 'pattern {action}'       //示例：df -P| grep  '/' |awk '$4 > 25000 {print $4}'

## 工作原理
```shell
# awk -F: '{print $1,$3}' /etc/passwd
$0 root:x:0:0:root:/root:/bin/bash
$1 $2 $3 $4 $5   $6    $7
①、awk 使用一行作为输入，并将这一行赋给这内部变量$0，每行也可以成为一个记录，以换行符结束；
②、然后，行被：(默认为空格或制表符)分解成字段(或域)，每个字段存储在一编号的变量中，从$1开始，最多达100个字段；
③、awk 如何知道用空格来分割字段呢？因为有一个内部变量FS来确定字段分割符。初始时，FS赋为空格；
④、awk 打印字段时，将以设置的方法使用print函数打印，awk在打印字段间加上空格，因为$1，$3之间有一个逗号，逗号比较特殊，它映射为另一个内部变量，称为输出字段分割符OFS，OFS默认为空格；
⑤、awk 输出之后，将从文件中获取另一行，并将其存储在$0中，覆盖原来的内容，然后将新的字符将新的字符串分隔成字段并进行处理，该过程将持续到所有行处理完毕；
```

(四)、记录与字段相关内部变量：man awk

$0：  //awk变量$0保存当前记录的内容              # awk -F: '{print $0}' /etc/passwd
NR：  //在每行行首添加输入记录的总数              # awk -F: '{print NR, $0}' /etc/passwd
FNR： //当前输入文件中的输入记录号	  			# awk -F: '{print FNR, $0}' /etc/passwd /etc/hosts
NF：  //保存记录的字段数，$1,$2...$100           # awk -F: '{print $0,NF}' /etc/passwd
FS：  //输入字段分隔符，默认空格                  # awk -F: '/root/{print $1, $3}' /etc/passwd
# awk -F'[ :\t]' '{print $1,$2,$3}' /etc/passwd    
# awk 'BEGIN{FS=":"} {print $1,$3}' /etc/passwd
OFS：   //输出字段分隔符         # awk 'BEGIN{FS=":"; OFS="+++"} /^root/{print $1,$2,$3,$4}' passwd
RS      //输入记录分隔符，默认情况下为换行。 # awk -F: 'BEGIN{RS=" "} {print $0}' a.txt #用空格取代换行符，完成换行，打印输出。
ORS     //输出记录分隔符，默认情况下为换行。  # awk -F: 'BEGIN{ORS=""} {print $0}' passwd

①、区别：

```text
字段分割符：FS OFS 　 默认空格或制表符
记录分割符：RS ORS　　默认换行符
```

lab1:
```shell
[root@linux ~]# awk 'BEGIN{ORS=" "} {print $0}' /etc/passwd                 //#将文件每一行合并为一行,即ORS默认输出一条记录应该回车，加了一个空格

```
lab2:
```shell
[root@linux ~]# head -1 /etc/passwd > passwd1
[root@linux ~]# cat passwd1
root:x:0:0:root:/root:/bin/bash
[root@linux ~]#
[root@linux ~]# awk 'BEGIN{RS=":"} {print $0}' passwd1
root
x
0
0
root
/root
/bin/bash
```

[root@linux ~]# awk 'BEGIN{RS=":"} {print $0}' passwd1 |grep -v '^$' > passwd2


(五)、格式化输出：
①、print函数
# date |awk '{print "Month: " $2 "\nYear: " $NF}' 变量放在双引号外面，
# awk -F: '{print "username is: " $1 "\t uid is: " $3}' /etc/passwd
# awk -F: '{print "\tusername and uid: " $1,$3}' /etc/passwd
\t 同意对齐格式：

②、printf函数
# awk -F: '{printf "%-15s %-10s %-15s\n", $1,$2,$3}'  /etc/passwd
# awk -F: '{printf "|%-15s| %-10s| %-15s|\n", $1,$2,$3}' /etc/passwd
\n 换行

%s 字符类型
%d 数值类型
%f 浮点类型
占15字符
- 表示左对齐，默认是右对齐
  printf默认不会在行尾自动换行，加\n

补充点

关于printf命令

其格式化输出：printf FORMAT,item1,item2....
要点：
1、其与print命令最大不同是，printf需要指定format
2、printf后面的字串定义内容需要使用双引号引起来
3、字串定义后的内容需要使用","分隔，后面直接跟Item1,item2....
4、format用于指定后面的每个item的输出格式
5、printf语句不会自动打印换行符，\n

格式符
%c: 显示字符的ASCII码
%d,%i : 显示十进制整数
%e,%E: 科学计数法数值显示
%f : 显示为浮点数
%g,%G: 以科学数法或浮点形式显示数值
%s: 显示字符串
%u: 无符号整数
%%: 显示%号自身，相当于转义

修饰符
N : 显示宽度
- : 左对齐（默认为右对齐）
+ : 显示数值符号

示例：
awk -F: '{printf "%s\n",$1}' /etc/fstab
awk -F: '{printf "username: %s,UID:%d\n",$1,$3}' /etc/passwd
awk -F: '{printf "username: %-20s shell: %s\n",$1,$NF}' /etc/passwd
free -m | awk 'BEGIN{printf "%.1f\n",'$((10000-28))'/10/12}'


(六)、awk 工作模式和动作
　　任何awk 语句都由模式和动作组成，模式部分决定动作语句何时触发及触发事件，处理即对数据进行的操作。

如果省略模式部分，动作将时刻保持执行状态，模式可以是任何条件语句或复合语句或正则表达式，模式包括两个
特殊字段BEGIN和END，使用BEGIN语句设置计数和打印头，BEGIN语句使用在任何文本浏览动作之前，之后文本浏览
动作依据输入文本开始执行，END语句用来在awk完成文本浏览动作后打印输出文本总数和结尾状态；

①、正则表达式：

匹配记录（整行）：

# awk '/^alice/'  /etc/passwd
# awk '$0 ~ /^alice/'  /etc/passwd
# awk '!/alice/' passwd
# awk '$0 !~ /^alice/'  /etc/passwd

匹配字段：匹配操作符（~ !~）
# awk -F: '$1 ~ /^alice/'  /etc/passwd
# awk -F: '$NF !~ /bash$/'  /etc/passwd

②、比较表达式：

比较表达采用对文本进行比较，只当条件为真，才执行指定的动作，比较表达式使用关系运算符，用于比较数字与字符串；

关系运算符

运算符           含义                          示例
<               小于                            x<y
<=              小于或等于                　　　 x<=y
==              等于                            x==y
!=              不等于                        　x!=y
>=              大于等于                    　　x>=y
>               大于                            x>y

$NF:匹配条件判断后，输出文件的最后一行

# awk -F: '$3 == 0' /etc/passwd
# awk -F: '$3 < 10' /etc/passwd
# awk -F: '$NF == "/bin/bash"' /etc/passwd
# awk -F: '$1 == "alice"' /etc/passwd
# awk -F: '$1 ~ /alic/ ' /etc/passwd
# awk -F: '$1 !~ /alic/ ' /etc/passwd
# df -P | grep  '/' |awk '$4 > 25000'

条件表达式：

# awk -F: '$3>300 {print $0}' /etc/passwd
# awk -F: '{ if($3>300) print $0 }' /etc/passwd
# awk -F: '{ if($3>300) {print $0} }' /etc/passwd
# awk -F: '{ if($3>300) {print $3} else{print $1} }' /etc/passwd

算术运算：+ - * / %(模) ^(幂2^3)

可以在模式中执行计算，awk 都将按浮点方式执行算术运算

# awk -F: '$3 * 10 > 500' /etc/passwd
# awk -F: '{ if($3*10>500){print $0} }' /etc/passwd

逻辑操作符和复合模式：

&&       	 逻辑与        a&&b
||           逻辑或        a||b
!            逻辑非        !a
# awk -F: '$1~/root/ && $3<=15' /etc/passwd
# awk -F: '$1~/root/ || $3<=15' /etc/passwd
# awk -F: '!($1~/root/ || $3<=15)' /etc/passwd

范围模式：

# awk '/Tom/,/Suzanne/' filename
二、示例
(一)、awk 示例：

# awk '/west/' datafile
# awk '/^north/' datafile
# awk '$3 ~ /^north/' datafile
# awk '/^(no|so)/' datafile
# awk '{print $3,$2}' datafile

# awk '{print $3 $2}' datafile
# awk '{print $0}' datafile
# awk '{print "Number of fields: "NF}' datafile
# awk '/northeast/{print $3,$2}' datafile
# awk '/E/' datafile

# awk '/^[ns]/{print $1}' datafile
# awk '$5 ~ /\.[7-9]+/' datafile
# awk '$2 !~ /E/{print $1,$2}' datafile
# awk '$3 ~ /^Joel/{print $3 " is a nice boy."}' datafile
# awk '$8 ~ /[0-9][0-9]$/{print $8}' datafile

# awk '$4 ~ /Chin$/{print "The price is $" $8 "."}' datafile
# awk '/Tj/{print $0}' datafile
# awk '{print $1}' /etc/passwd
# awk -F: '{print $1}' /etc/passwd
# awk '{print "Number of fields: "NF}' /etc/passwd
# awk -F: '{print "Number of fields: "NF}' /etc/passwd
# awk -F"[ :]" '{print NF}' /etc/passwd
# awk -F"[ :]+" '{print NF}' /etc/passwd
# awk '$7 == 5' datafile
# awk '$2 == "CT" {print $1, $2}' datafile
# awk '$7 != 5' datafile


(二)、awk 进阶：

[root@yang ~]# cat << eof >b.txt
yang sheng:is a::good boy!
eof
[root@yang ~]# awk '{print NF}' b.txt
4
[root@yang ~]# awk -F: '{print NF}' b.txt
4
[root@yang ~]# awk -F"[ :]" '{print NF}' b.txt
7
[root@yang ~]# awk -F"[ :]+" '{print NF}' b.txt
6

# awk '$7 < 5 {print $4, $7}' datafile                      #{if($7<5){print $4,$7}}
# awk '$6 > .9 {print $1,$6}' datafile
# awk '$8 <= 17 {print $8}' datafile
# awk '$8 >= 17 {print $8}' datafile
# awk '$8 > 10 && $8 < 17' datafile

# awk '$2 == "NW" || $1 ~ /south/ {print $1, $2}' datafile
# awk '!($8 == 13){print $8}' datafile                    #$8 != 13
# awk '/southem/{print $5 + 10}' datafile
# awk '/southem/{print $8 + 10}' datafile
# awk '/southem/{print $5 + 10.56}' datafile

# awk '/southem/{print $8 - 10}' datafile
# awk '/southem/{print $8 / 2 }' datafile
# awk '/southem/{print $8 / 3 }' datafile
# awk '/southem/{print $8 * 2 }' datafile
# awk '/southem/{print $8 % 2 }' datafile

# awk '$3 ~ /^Suan/ {print "Percentage: "$6 + .2   " Volume: " $8}' datafile
# awk '/^western/,/^eastern/' datafile
# awk '{print ($7 > 4 ? "high "$7 : "low "$7)}' datafile            //三目运算符 a?b:c 条件?结果1:结果2
# awk '$3 == "Chris" {$3 = "Christian"; print $0}' datafile     //赋值运算符
# awk '/Derek/ {$8+=12; print $8}' datafile                            //$8 += 12等价于$8 = $8 + 12
# awk '{$7%=3; print $7}' datafile                                        //$7 %= 3等价于$7 = $7 % 3




## 条件判断

### if 语句

格式
```text
{if(表达式){动作；动作；...}}
```


示例：
```shell
awk -F: '{if($3==0) {print $1 " is administrator."}}' /etc/passwd //查找root用户
awk -F: '{if($3>0 && $3<1000){count++;}}  END{print count}' /etc/passwd    　　//统计系统用户数
```

### if...else语句
格式
```text
{if(表达式){动作;动作;...}
else{动作;动作;...}
}
```
示例：
```shell
awk -F: '{if($3==0){print $1} else {print $7}}' /etc/passwd
awk -F: '{if($3==0) {count++} else{i++} }' /etc/passwd
awk -F: '{if($3==0){count++} else{i++}} END{print "管理员个数: "count ; print "系统用户数: "i}' /etc/passwd
```

### if...else if...else语句
格式
```text
{ if(表达式１){动作；动作；...} 
 else if (表达式２) {动作；动作；...} 
 else if (表达式３) {动作；动作；...} 
 else {动作；动作；...}
}
```

示例：
```shell

awk -F: '{if($3==0){i++} else if($3>999){k++} else{j++}} END{print i; print k; print j}' /etc/passwd
awk -F: '{if($3==0){i++} else if($3>999){k++} else{j++}} END{print "管理员个数: "i; print "普通用个数: "k; print "系统用户: "j}' /etc/passwd

```

## 循环
### while
示例：
```shell
[root@linux ~]# awk 'BEGIN{ i=1; while(i<=10){print i; i++}  }'
[root@linux ~]# awk -F: '/^root/{i=1; while(i<=7){print $i; i++}}' passwd
[root@linux ~]# awk  '{i=1; while(i<=NF){print $i; i++}}' /etc/hosts
[root@linux ~]# awk -F: '{i=1; while(i<=10) {print $0;  i++}}' /etc/passwd       //将每行打印10次
[root@linux ~]# cat b.txt
111 222
333 444 555
666 777 888 999
[root@linux ~]# awk '{i=1; while(i<=NF){print $i; i++}}' b.txt                       //分别打印每行的每列

```

### for
for循环语法格式1
```shell
for(初始化;布尔表达式;更新){
//代码语句
}

```
for循环语法格式2
```shell
for(变量in数组){
//代码语句
}
```

```shell
awk 'BEGIN{for(i=1;i<=5;i++){print i} }'   //C风格for
awk -F: '{ for(i=1;i<=10;i++) {print $0} }' /etc/passwd   //将每行打印10次
awk -F: '{ for(i=1;i<=NF;i++) {print $i} }' passwd        //分别打印每行的每列
```

## 数组

AWK 可以使用关联数组这种数据结构，索引可以是数字或字符串。
AWK关联数 组也不需要提前声明其大小，因为它在运行时可以自动的增大或减小。

数组使用的语法格式：

	array_name[index]=value

	array_name：数组的名称
	index：数组索引
	value：数组中元素所赋予的值

创建数组

接下来看一下如何创建数组以及如何访问数组元素：
awk 'BEGIN {
sites["runoob"]="www.runoob.com";
sites["google"]="www.google.com"
print sites["runoob"] "\n" sites["google"]
}'

```shell
# awk -F: '{username[++i]=$1} END{print username[1]}' /etc/passwd #$1赋值给usernamei
root
# awk -F: '{username[i++]=$1} END{print username[1]}' /etc/passwd
bin
# awk -F: '{username[i++]=$1} END{print username[0]}' /etc/passwd
root
```

④、数组遍历：

１．按索引遍历

```shell
# awk -F: '{username[x++]=$1} END{for(i in username) {print i,username[i]} }' /etc/passwd
# awk -F: '{username[++x]=$1} END{for(i in username) {print i,username[i]} }' /etc/passwd
```

将用户名保存到数组当中，然后对数组遍历，i是索引
注：变量i是索引

２．按元数个数遍历

```shell
# awk -F: '{username[x++]=$1} END{for(i=0;i<x;i++) print i,username[i]}' /etc/passwd
# awk -F: '{username[++x]=$1} END{for(i=1;i<=x;i++) print i,username[i]}' /etc/passwd

```

四、实例练习
(一)、统计shell
<统计/etc/passwd中各种类型shell的数量>

[root@linux ~]# awk -F: '{shells[$NF]++} END{ for(i in shells){print i,shells[i]} }' /etc/passwd

(二)、网站访问状态统计
<当前实时状态netstat>
netstat -ant |grep :80 |awk '{access_stat[$NF]++} END{for(i in access_stat ){print i,access_stat[i]}}'

netstat -ant |grep :80 |awk '{access_stat[$NF]++} END{for(i in access_stat ){print i,access_stat[i]}}' |sort -k2 -n |head

ss -an |grep :80 |awk '{access_stat[$2]++} END{for(i in access_stat){print i,access_stat[i]}}'

ss -an |grep :80 |awk '{access_stat[$2]++} END{for(i in access_stat){print i,access_stat[i]}}' |sort -k2 -rn


(三)、统计当前访问的每个IP的数量
<当前实时状态netstat，ss>
netstat -ant |grep :80 |awk -F: '{ip_count[$8]++} END{for(i in ip_count){print i,ip_count[i]} }' |sort

ss -an |grep :80 |awk -F":" '!/LISTEN/{ip_count[$(NF-1)]++} END{for(i in ip_count){print i,ip_count[i]}}' |sort -k2 -rn |head

(四)、统计Apache/Nginx日志PV量
<统计Apache/Nginx日志中某一天的PV量，统计日志>
grep '22/Mar/2017' cd.mobiletrain.org.log |wc -l


(五)、统计Apache/Nginx日志
<统计Apache/Nginx日志中某一天不同IP的访问量，日志统计>

grep '07/Aug/2012' access.log |awk '{ips[$1]++} END{for(i in ips){print i,ips[i]} }' |sort -k2 -rn |head

grep '07/Aug/2012' access.log |awk '{ips[$1]++} END{for(i in ips){print i,ips[i]} }' |awk '$2>100' |sort -k2 -rn

awk '/22\/Mar\/2017/{ips[$1]++} END{for(i in ips){print i,ips[i]}}' sz.mobiletrain.org.log |awk '$2>100' |sort -k2 -rn|head

awk '/22\/Mar\/2017/{ips[$1]++} END{for(i in ips){if(ips[i]>100){print i,ips[i]}}}' sz.mobiletrain.org.log|sort -k2 -rn|head

思路：将需要统计的内容（某一个字段）作为数组的索引++

(六)、awk 函数
统计用户名为４个字符的用户：

[root@linux ~]# awk -F: '$1~/^....$/{count++; print $1} END{print "count is: " count}' /etc/passwd
root
sync
halt
mail
news
uucp
nscd
vcsa
pcap
sshd
dbus
jack
count is: 12

[root@linux ~]#  awk -F: 'length($1)==4{count++; print $1} END{print "count is: "count}' /etc/passwd
root
sync
halt
mail
news
uucp
nscd
vcsa
pcap
sshd
dbus
jack
count is: 12

(七)、awk 使用外部变量：
①方法一：在双引号的情况下使用

[root@linux ~]# var="bash"
[root@linux ~]# echo "unix script" |awk "gsub(/unix/,\"$var\")"
bash script
②方法二：在单引号的情况下使用

[root@linux ~]# var="bash"
[root@linux ~]# echo "unix script" |awk 'gsub(/unix/,"'"$var"'")'
bash script


[root@linux ~]# df -h
Filesystem           Size  Used Avail Use% Mounted on
/dev/mapper/cl-root  2.8T  246G  2.5T   9% /
tmpfs                 24G   20K   24G        1% /dev/shm
/dev/sda2           1014M  194M  821M   20% /boot

[root@linux ~]# df -h |awk '{ if(int($5)>5){print $6":"$5} }'
/:9%
/boot:20%


[root@linux ~]# i=10
[root@linux ~]# df -h |awk '{ if(int($5)>'''$i'''){print $6":"$5} }'
/boot:20%

方法：awk 参数-v(建议)

[root@linux ~]# echo "unix script" |awk -v var="bash" 'gsub(/unix/,var)'
bash script

[root@linux ~]# awk -v user=root  -F: '$1 == user' /etc/passwd
root:x:0:0:root:/root:/bin/bash

常用方法：
head 默认为前十；
cat a.txt | awk 'BEGIN{FS="/"}{dict[$3]++}END{for (i in dict)print dict[i],i}' | sort -r | head -20