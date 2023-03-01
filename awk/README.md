# awk文本处理

## awk简介

awk是一种编程语言，用于在linux/unix下对文本和数据进行处理，数据可以来自标准输入、一个或多个文件，或其它命令的输出，它支持用户自定义函数和动态正则表达式等先进功能，是linux/unix下的一个强大编程工具，它在命令行中使用，但更多的是作为脚本来使用；

awk 的处理文本和数据的方式是这样的，它逐行扫描文件，从第一行到最后一行，寻找匹配的寻找匹配的特定模式的行，并在这些行上进行你想要的操作，如果没有指定处理动作，则把匹配的行显示到标准输出(屏幕)，如果没有指定模式，则所有被操作所指定的行都被处理；

awk 分别代表其作者是三个人，分别是Alfred Aho、Brian Kernighan、Peter Weinberger。gawk是awk的GNU版本，它提供了Bell实验和GNU的一些扩展。

## awk语法格式
```shell
awk命令形式:

awk [-F|-f|-v] 'BEGIN{} //{command1; command2} END{}' file

说明：

options： 
    [-F|-f|-v]   
        -F　　 定义输入字段分隔符，默认的分隔符是空格或制表符(tab)
        -f    调用脚本
        -v    定义变量 var=value
command：
大体分3个模块组成，分别是：
     BEGIN{}            {}               END{}
    命令行处理前      命令行处理中         命令行处理后
' '          引用代码块
BEGIN{}      初始化代码块，在对每一行进行处理之前，初始化代码，主要是引用全局变量，设置FS分隔符
//           用来定义需要匹配的模式（字符串或者正则表达式），对满足匹配模式的行进行上条代码块的操作
{}           命令代码块，包含一条或多条命令
;            多条命令使用分号分隔
END{}        结尾代码块，在对每一行进行处理之后再执行的代码块，主要是进行最终计算或输出结尾摘要信息
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

### awk命令格式
```shell
awk 'pattern' filename                #示例：awk -F: '/root/' /etc/passwd        
awk '{action}' filename               #示例：awk -F: '{print $1}' /etc/passwd            
awk 'pattern {action}' filename       #示例：awk -F: '/root/{print $1,$3}' /etc/passwd        
command | awk 'pattern {action}'      #示例：df -P| grep  '/' |awk '$4 > 25000 {print $4}'
```


## 工作原理
以示例说明：
```shell
# awk -F: '{print $1,$3}' /etc/passwd
$0 root:x:0:0:root:/root:/bin/bash
    $1 $2 $3 $4 $5  $6    $7
处理文本的流程：
①、awk 使用一行作为输入，并将这一行赋给这内部变量$0，每行也可以成为一个记录，以换行符结束；
②、然后，行被：(默认为空格或制表符)分解成字段(或域)，每个字段存储在一编号的变量中，从$1开始，最多达100个字段；
③、awk 如何知道用空格来分割字段呢？因为有一个内部变量FS来确定字段分割符。初始时，FS赋为空格；
④、awk 打印字段时，将以设置的方法使用print函数打印，awk在打印字段间加上空格，因为$1，$3之间有一个逗号，逗号比较特殊，它映射为另一个内部变量，称为输出字段分割符OFS，OFS默认为空格；
⑤、awk 输出之后，将从文件中获取另一行，并将其存储在$0中，覆盖原来的内容，然后将新的字符将新的字符串分隔成字段并进行处理，该过程将持续到所有行处理完毕；
```

#### -F指定分隔符

内部变量

| 变量        | 描述                                                       |
| :---------- | :--------------------------------------------------------- |
| $n          | 当前记录的第n个字段，字段间由FS分隔                        |
| $0          | 完整的输入记录                                             |
| ARGC        | 命令行参数的数目                                           |
| ARGIND      | 命令行中当前文件的位置(从0开始算)                          |
| ARGV        | 包含命令行参数的数组                                       |
| CONVFMT     | 数字转换格式(默认值为%.6g)ENVIRON环境变量关联数组          |
| ERRNO       | 最后一个系统错误的描述                                     |
| FIELDWIDTHS | 字段宽度列表(用空格键分隔)                                 |
| FILENAME    | 当前文件名                                                 |
| FNR         | 各文件分别计数的行号                                       |
| FS          | 字段分隔符(默认是任何空格)                                 |
| IGNORECASE  | 如果为真，则进行忽略大小写的匹配                           |
| NF          | 一条记录的字段的数目                                       |
| NR          | 已经读出的记录数，就是行号，从1开始                        |
| OFMT        | 数字的输出格式(默认值是%.6g)                               |
| OFS         | 输出记录分隔符（输出换行符），输出时用指定的符号代替换行符 |
| ORS         | 输出记录分隔符(默认值是一个换行符)                         |
| RLENGTH     | 由match函数所匹配的字符串的长度                            |
| RS          | 记录分隔符(默认是一个换行符)                               |
| RSTART      | 由match函数所匹配的字符串的第一个位置                      |
| SUBSEP      | 数组下标分隔符(默认值是/034)                               |

示例：
```shell

以冒号: 作为分隔符，获取文件/etc/passwd中信息，打印输出
# awk -F: '{print $0}' /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync

以冒号: 作为分隔符，获取文件/etc/passwd中信息，每行的开头输出行号和原内容
# awk -F: '{print NR, $0}' /etc/passwd
1 root:x:0:0:root:/root:/bin/bash
2 bin:x:1:1:bin:/bin:/sbin/nologin
3 daemon:x:2:2:daemon:/sbin:/sbin/nologin
4 adm:x:3:4:adm:/var/adm:/sbin/nologin
5 lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
6 sync:x:5:0:sync:/sbin:/bin/sync

以冒号: 作为分隔符，获取文件/etc/passwd中信息，将每行内容和第NF个字段的值打印出来
# awk -F: '{print $0,NF}' /etc/passwd
root:x:0:0:root:/root:/bin/bash 7
bin:x:1:1:bin:/bin:/sbin/nologin 7
daemon:x:2:2:daemon:/sbin:/sbin/nologin 7
adm:x:3:4:adm:/var/adm:/sbin/nologin 7
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin 7
sync:x:5:0:sync:/sbin:/bin/sync 7
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown 7
halt:x:7:0:halt:/sbin:/sbin/halt 7

以冒号: 作为分隔符，获取文件/etc/passwd中信息，输出$1与$3相连，不分隔
awk -F":" '{print $1 $3}'  /etc/passwd  
root0
bin1
daemon2
adm3
lp4
sync5

以冒号: 作为分隔符，获取文件/etc/passwd中信息，输出第1列与第3列信息，中间使用空格分隔
# awk -F":" '{print $1 " " $3}'  /etc/passwd  #$1与$3之间手动添加空格分隔
# awk -F":" '{print $1,$3}'  /etc/passwd  #等同上
root 0
bin 1
daemon 2
adm 3
lp 4

 以冒号: 作为分隔符，获取文件/etc/passwd中，匹配root关键字的行，输出每行的第一列和第三列。注意：$1与$3使用空格分隔
# awk -F: '/root/{print $1, $3}' /etc/passwd
root 0
operator 11

以冒号: 作为分隔符，获取文件/etc/passwd中，匹配空格，冒号和制表符关键字的行，输出每行的第一列和第三列。注意：$1与$3使用空格分隔
# awk -F'[ :\t]' '{print $1,$3}' /etc/passwd    
root x 0
bin x 1
daemon x 2
adm x 3
lp x 4
sync x 5
shutdown x 6

以冒号: 作为分隔符，获取文件/etc/passwd中信息，显示每行有多少字段数
# awk -F: '{print NF}' /etc/passwd     
7
7

以冒号: 作为分隔符，获取文件/etc/passwd中信息，将每行第NF个字段的值打印出来
# awk -F: '{print $NF}' /etc/passwd  
/bin/bash
/sbin/nologin
/sbin/nologin
/sbin/nologin
/sbin/nologin
/bin/sync

以冒号: 作为分隔符，获取文件/etc/passwd中信息，显示第5行数据
# awk -F: 'NR==5{print}'  /etc/passwd                         
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin

以冒号: 作为分隔符，获取文件/etc/passwd中信息，显示第5行和第6行
#awk -F: 'NR==5 || NR==6{print}'  /etc/passwd 
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync

以冒号: 作为分隔符，获取文件/etc/passwd中数据，输出每行的第一列和第三列。注意：$1与$3使用空格分隔
# awk 'BEGIN{FS=":"} {print $1,$3}' /etc/passwd
root 0
bin 1
daemon 2

以冒号: 作为分隔符，获取文件/etc/passwd中数据，匹配root关键字的行，将冒号:替换成+++输出每行的第一列和第三列。注意：$1与$3使用空格分隔
# awk 'BEGIN{FS=":"; OFS="+++"} /^root/{print $1,$3}' /etc/passwd
root+++0

用空格取代换行符，完成换行，打印输出。
# awk -F: 'BEGIN{ORS=""} {print $0}' /etc/passwd
root:x:0:0:root:/root:/bin/bashbin:x:1:1:bin:/bin:/sbin/nologindaemon:x:2:2:daemon:/sbin:/sbin/nologinadm:x:3:4:adm:/var/adm:/sbin/nologinlp:x:4:7:lp:/var/spool/lpd:/sbin/nologinsync:x:5:0:sync:/sbin:/bin/syncshutdown:x:6:0:shutdown:/sbin:/sbin/shutdownhalt:x:7:0:halt:/sbin:/sbin/halt
```

### FS&RS区别

```text
字段分割符：FS OFS 　 默认空格或制表符
记录分割符：RS ORS　　默认换行符
```


### awk 使用外部变量

方法一：在双引号的情况下使用
```shell
# var="bash"
# echo "unix script" |awk "gsub(/unix/,\"$var\")"
bash script
```
方法二：在单引号的情况下使用

```shell
# var="bash"
# echo "unix script" |awk 'gsub(/unix/,"'"$var"'")'
bash script


# df -h
Filesystem           Size  Used Avail Use% Mounted on
/dev/mapper/cl-root  2.8T  246G  2.5T   9% /
tmpfs                 24G   20K   24G        1% /dev/shm
/dev/sda2           1014M  194M  821M   20% /boot

# df -h |awk '{ if(int($5)>5){print $6":"$5} }'
/:9%
/boot:20%

# i=10
# df -h |awk '{ if(int($5)>'''$i'''){print $6":"$5} }'
/boot:20%
```

方法：awk 参数-v(建议)
```shell
# echo "unix script" |awk -v var="bash" 'gsub(/unix/,var)'
bash script

# awk -v user=root  -F: '$1 == user' /etc/passwd
root:x:0:0:root:/root:/bin/bash
```

### 格式化输出
①、print函数
```shell
# date |awk '{print "Month: " $2 "\nYear: " $NF}' #变量放在双引号外面
# awk -F: '{print "username is: " $1 "\t uid is: " $3}' /etc/passwd
# awk -F: '{print "\tusername and uid: " $1,$3}' /etc/passwd
```
\t 同意对齐格式：

②、printf函数
```shell
# awk -F: '{printf "%-15s %-10s %-15s\n", $1,$2,$3}'  /etc/passwd
# awk -F: '{printf "|%-15s| %-10s| %-15s|\n", $1,$2,$3}' /etc/passwd
```
\n 换行

%s 字符类型
%d 数值类型
%f 浮点类型
占15字符
- 表示左对齐，默认是右对齐
  printf默认不会在行尾自动换行，加\n

### 补充点

#### printf命令

其格式化输出：printf FORMAT,item1,item2....
要点： 
1. 其与print命令最大不同是，printf需要指定format
2. printf后面的字串定义内容需要使用双引号引起来
3. 字串定义后的内容需要使用","分隔，后面直接跟Item1,item2....
4. format用于指定后面的每个item的输出格式
5. printf语句不会自动打印换行符，\n

#### 格式符
```shell
%c: 显示字符的ASCII码
%d,%i : 显示十进制整数
%e,%E: 科学计数法数值显示
%f : 显示为浮点数
%g,%G: 以科学数法或浮点形式显示数值
%s: 显示字符串
%u: 无符号整数
%%: 显示%号自身，相当于转义
```

#### 修饰符
```shell
N : 显示宽度
- : 左对齐（默认为右对齐）
+ : 显示数值符号
```

示例：
```shell
awk -F: '{printf "%s\n",$1}' /etc/fstab
awk -F: '{printf "username: %s,UID:%d\n",$1,$3}' /etc/passwd
awk -F: '{printf "username: %-20s shell: %s\n",$1,$NF}' /etc/passwd
free -m | awk 'BEGIN{printf "%.1f\n",'$((10000-28))'/10/12}'
```

#### 正则表达式

匹配记录（整行）

语法格式：
```text
 awk '条件/关键字/' file
```

```shell
//纯字符匹配   !//纯字符不匹配   ~//字段值匹配    !~//字段值不匹配   ~/a1|a2/字段值匹配a1或a2 

匹配alice关键字整行输出  
# awk '/alice/' /etc/passwd
# awk '/alice/{print }' /etc/passwd
# awk '/alice/{print $0}' /etc/passwd                   #三条指令结果一样
alice:x:1000:1000::/home/alice:/bin/bash

匹配除了alice关键字整行输出
# awk '!/alice/{print $0}' /etc/passwd                  //输出不匹配alice的行

匹配alice或mail关键字，整行输出
# awk '/alice|mail/{print}' /etc/passwd
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
alice:x:1000:1000::/home/alice:/bin/bash

匹配排除alice或mail关键字，整行输出
# awk '!/alice|mail/{print}' /etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync

匹配alice和mail区间关键字整行输出
# awk -F: '/mail/,/alice/{print}' /etc/passwd 
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
polkitd:x:999:998:User for polkitd:/:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
postfix:x:89:89::/var/spool/postfix:/sbin/nologin
clickhouse:x:998:996::/nonexistent:/bin/false
nginx:x:997:995:nginx user:/var/cache/nginx:/sbin/nologin
nms:x:996:994:nms user added by manager:/nonexistent:/bin/false
alice:x:1000:1000::/home/alice:/bin/bash

匹配包含27为数字开头的行，如27，277，2777...
# awk '/[2][7][7]*/{print $0}' /etc/passwd 
27test:x:1001:1001::/home/27test:/bin/bash
276test:x:1004:1004::/home/276test:/bin/bash
27777test:x:1005:1005::/home/27777test:/bin/bash
```

#### 匹配字段

操作符

| 运算符 | 描述             |
| ------ | ---------------- |
| ~      | 匹配正则表达式   |
| !~     | 不匹配正则表达式 |


```shell
$1匹配指定内容输出
# awk -F: '{if($1~/mail/) print $1}' /etc/passwd #等同下
# awk -F: '$1~/mail/{print $1}' /etc/passwd
mail

$1不匹配指定内容包含mail关键字输出
# awk -F: '$1!~/mail/{print $1}' /etc/passwd  # 等同下
postfix
clickhouse
nginx
nms
alice

$1不匹配指定内容包含mail和alice关键字输出
# awk -F: '$1!~/mail|alice/{print $1}' /etc/passwd 
postfix
clickhouse
nginx
nms
test
```

#### 条件表达式

比较表达采用对文本进行比较，只当条件为真，才执行指定的动作，比较表达式使用关系运算符，用于比较数字与字符串；

##### 关系运算符

| 运算符 |   含义   |   示例  |
|-----|-----|-----|
| <   |  小于    |     x<y |
| <=  |  小于或等于   |  x<=y   |
| ==  |   等于   |    x==y  |
| !=  |   不等于  |   x!=y  |
| >=  |  大于等于   |    x>=y |
| \>  |  大于   |      x>y |


##### 条件表达式

```shell
以冒号: 作为分隔符，获取文件/etc/passwd中，每行第一列关键字，如果是mysql，打印每行第三列的数据 
# awk -F":" '$1=="mysql"{print $3}' /etc/passwd  
# awk -F":" '{if($1=="mysql") print $3}' /etc/passwd          //与上面相同 
1006

以冒号: 作为分隔符，获取文件/etc/passwd中，每行第一列关键字，如果不是mysql，打印每行第三列的数据 
# awk -F":" '$1!="mysql"{print $3}' /etc/passwd                 //不等于
0
1
2
3
以冒号: 作为分隔符，获取文件/etc/passwd中，每行第3列的用户ID，如果用户ID大于1000，打印每行第3列的用户ID
# awk -F":" '$3>1000{print $3}' /etc/passwd                      //大于
1001
1002
1003
1004
1005
1006
以冒号: 作为分隔符，获取文件/etc/passwd中，每行第3列的用户ID，如果用户ID大于等于100，打印每行第3列的用户ID
# awk -F":" '$3>=100{print $3}' /etc/passwd                     //大于等于
192
999
998
997
996
1000
1001
1002
1003
1004
1005
1006

以冒号: 作为分隔符，获取文件/etc/passwd中，每行第3列的用户ID，如果用户ID小于1，打印每行第3列的用户ID
# awk -F":" '$3<1{print $3}' /etc/passwd                            //小于
0

以冒号: 作为分隔符，获取文件/etc/passwd中，每行第3列的用户ID，如果用户ID小于等于1，打印每行第3列的用户ID
# awk -F":" '$3<=1{print $3}' /etc/passwd                         //小于等于
0
1
```

#### 算术运算

| 运算符 | 描述                       |
| ------ | -------------------------- |
| + -    | 加，减                     |
| * / &  | 乘，除与求余               |
| + - !  | 一元加，减和逻辑非         |
| ^ ***  | 求幂                       |
| ++ --  | 增加或减少，作为前缀或后缀 |


可以在模式中执行计算，awk 都将按浮点方式执行算术运算

```shell
以冒号: 作为分隔符，获取文件/etc/passwd中，每行第3列的用户ID，如果用户ID乘10大于500，打印每行所有信息
# awk -F: '$3 * 10 > 500' /etc/passwd
nobody:x:99:99:Nobody:/:/sbin/nologin
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
polkitd:x:999:998:User for polkitd:/:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
postfix:x:89:89::/var/spool/postfix:/sbin/nologin
clickhouse:x:998:996::/nonexistent:/bin/false
nginx:x:997:995:nginx user:/var/cache/nginx:/sbin/nologin
nms:x:996:994:nms user added by manager:/nonexistent:/bin/false
alice:x:1000:1000::/home/alice:/bin/bash

# awk -F: '{ if($3*10>500){print $0} }' /etc/passwd #等同于上
```
#### 逻辑运算符

| 运算符  | 描述   |
|------| ------ |
| `||` | 逻辑或 |
| &&   | 逻辑与 |
| !    | 逻辑非 |


示例：
```shell
# awk -F: '$1~/root/ && $3<=15' /etc/passwd
# awk -F: '$1~/root/ || $3<=15' /etc/passwd
# awk -F: '!($1~/root/ || $3<=15)' /etc/passwd
```


## 条件判断

### if 语句

格式
```text
{if(表达式){动作；动作；...}}
```


示例：
```shell
查找root用户
# awk -F: '{if($3==0) {print $1 " is administrator."}}' /etc/passwd
root is administrator.

统计系统用户数
# awk -F: '{if($3>0 && $3<1000){count++;}}  END{print count}' /etc/passwd   
20　　
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
以冒号: 作为分隔符，获取文件/etc/passwd中，每行第3列的用户ID，如果用户ID等于0，打印每行第1列的用户，否则，打印输出每行第7列的用户默认的命令解释器的路径
# awk -F: '{if($3==0){print $1} else {print $7}}' /etc/passwd
root
/sbin/nologin
/sbin/nologin
/bin/sync
/sbin/shutdown
/sbin/halt
/sbin/nologin
/bin/false
/sbin/nologin
/bin/false
/bin/bash

获取管理员和系统用户数总数
# awk -F: '{if($3==0){count++} else{i++}} END{print "管理员个数: "count ; print "系统用户数: "i}' /etc/passwd
管理员个数: 1
系统用户数: 27
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
打印1到10
# awk 'BEGIN{ i=1; while(i<=10){print i; i++}  }'
1
2
3
4
5
6
7
8
9
10

以冒号: 作为分隔符，获取文件/etc/passwd中，循环打印以root开头的每行的列信息
# awk -F: '/^root/{i=1; while(i<=7){print $i; i++}}'/etc/passwd 
root
x
0
0
root
/root
/bin/bash

分别打印每行的每列
# awk  '{i=1; while(i<=NF){print $i; i++}}' /etc/hosts
127.0.0.1
localhost
localhost.localdomain
localhost4
localhost4.localdomain4
::1
localhost
localhost.localdomain
localhost6
localhost6.localdomain6

以冒号: 作为分隔符，获取文件/etc/passwd中数据每行打印10次
# awk -F: '{i=1; while(i<=10) {print $0;  i++}}' /etc/passwd       
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash

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

接下来看一下如何创建数组以及如何访问数组元素：
```shell
awk 'BEGIN {
sites["runoob"]="www.runoob.com";
sites["google"]="www.google.com"
print sites["runoob"] "\n" sites["google"]
}'
```
示例
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

２．按元数个数遍历

```shell
# awk -F: '{username[x++]=$1} END{for(i=0;i<x;i++) print i,username[i]}' /etc/passwd
# awk -F: '{username[++x]=$1} END{for(i=1;i<=x;i++) print i,username[i]}' /etc/passwd

```

## 实例练习
### 统计shell

统计/etc/passwd中各种类型shell的数量
```shell
# awk -F: '{shells[$NF]++} END{ for(i in shells){print i,shells[i]} }' /etc/passwd
/bin/sync 1
/bin/bash 8
/sbin/nologin 15
/sbin/halt 1
/bin/false 2
/sbin/shutdown 1
```

### 网站访问状态统计
当前实时状态netstat
```shell
netstat -ant |grep :80 |awk '{access_stat[$NF]++} END{for(i in access_stat ){print i,access_stat[i]}}'

netstat -ant |grep :80 |awk '{access_stat[$NF]++} END{for(i in access_stat ){print i,access_stat[i]}}' |sort -k2 -n |head

ss -an |grep :80 |awk '{access_stat[$2]++} END{for(i in access_stat){print i,access_stat[i]}}'

ss -an |grep :80 |awk '{access_stat[$2]++} END{for(i in access_stat){print i,access_stat[i]}}' |sort -k2 -rn

```

### 统计当前访问的每个IP的数量
当前实时状态netstat，ss
```shell
netstat -ant |grep :80 |awk -F: '{ip_count[$8]++} END{for(i in ip_count){print i,ip_count[i]} }' |sort

ss -an |grep :80 |awk -F":" '!/LISTEN/{ip_count[$(NF-1)]++} END{for(i in ip_count){print i,ip_count[i]}}' |sort -k2 -rn |head

```
### 统计Apache/Nginx日志PV量
统计Apache/Nginx日志中某一天的PV量，统计日志
```shell
grep '22/Mar/2017' cd.mobiletrain.org.log |wc -l
```


### 统计Apache/Nginx日志
统计Apache/Nginx日志中某一天不同IP的访问量，日志统计
```shell
grep '07/Aug/2012' access.log |awk '{ips[$1]++} END{for(i in ips){print i,ips[i]} }' |sort -k2 -rn |head

grep '07/Aug/2012' access.log |awk '{ips[$1]++} END{for(i in ips){print i,ips[i]} }' |awk '$2>100' |sort -k2 -rn

awk '/22\/Mar\/2017/{ips[$1]++} END{for(i in ips){print i,ips[i]}}' sz.mobiletrain.org.log |awk '$2>100' |sort -k2 -rn|head

awk '/22\/Mar\/2017/{ips[$1]++} END{for(i in ips){if(ips[i]>100){print i,ips[i]}}}' sz.mobiletrain.org.log|sort -k2 -rn|head

```

### 统计用户名为４个字符的用户

```shell
方法一：
# awk -F: '$1~/^....$/{count++; print $1} END{print "count is: " count}' /etc/passwd
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

方法二：
#  awk -F: 'length($1)==4{count++; print $1} END{print "count is: "count}' /etc/passwd
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
```



