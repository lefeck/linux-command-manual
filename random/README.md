# random

shell下有时需要使用随机数。计算机产生的的只是“伪随机数”，不会产生绝对的随机数（是一种理想随机数）。伪随机数在大量重现时也并不一定保持唯一，但一个好的伪随机产生算法将可以产生一个非常长的不重复的序列。

## 生成随机数的七种方法

### 通过内部系统变量（$RANDOM）
```shell
[gin@Gin ~]$ echo $RANDOM
6936
[gin@Gin ~]$ echo $RANDOM
28058
[gin@Gin ~]$ echo $RANDOM
21427
```
生成0-32767之间的整数随机数，若超过5位可以加个固定10位整数，然后进行求余。

生成400000~500000的随机数：

```shell
#!/bin/bash

function rand(){   
    min=$1   
    max=$(($2-$min+1))   
    num=$(($RANDOM+1000000000)) #增加一个10位的数再求余   
    echo $(($num%$max+$min))
}
random=$(rand 400000 500000)   
echo $random
exit 0
```

### 使用awk的随机函数
```shell
[root@Gin scripts]# awk 'BEGIN{srand();print rand()*1000000}'   ##可以加上if判断，779644
918520
[root@Gin scripts]# awk 'BEGIN{srand();print rand()*1000000}'
379242
```

### openssl rand产生随机数

openssl rand 用于产生指定长度个bytes的随机字符。-base64或-hex对随机字符串进行base64编码或用hex格式显示。
```shell
[root@Gin scripts]# openssl rand -base64 8
wBroG6n//3c=
[root@Gin scripts]# openssl rand -base64 8|md5sum
99b965644182c16b04472ed5f922c5c2  -
[root@Gin scripts]# openssl rand -base64 8|md5sum|cut -c 1-8   #八位字母和数字的组合
567f5d54
[root@Gin scripts]# openssl rand -base64 8|cksum|cut -c 1-8  #八位数字
70083590

```
### 通过时间获得随机数（date）

```shell
[root@Gin scripts]# date +%s%N  #生成19位数字
1486113479463684835
[root@Gin scripts]# date +%s%N|cut -c 6-13  #取八位数字
13578053
[root@Gin scripts]# date +%s%N|md5sum|head -c 8  #八位字母和数字的组合
11f60e3a
```

生成1~50的随机数：

```shell
function rand(){   
  min=$1   
  max=$(($2-$min+1))   
  num=$(date +%s%N)   
  echo $(($num%$max+$min))   
}

rnd=$(rand 1 50)   
echo $rnd

exit 0
```

### 通过系统内唯一数据生成随机数（/dev/random及/dev/urandom）
/dev/random存储系统当前运行的环境的实时数据，可以看作系统某时候的唯一值数据，提供优质随机数。

/dev/urandom是非阻塞的随机数产生器，读取时不会产生阻塞，速度更快、安全性较差的随机数发生器。

```shell
[root@Gin scripts]# cat /dev/urandom|head -n 10|md5sum|head -c 10
dc32c5047f

[root@Gin scripts]# cat /dev/urandom|strings -n 8|head -n 1  #生成全字符的随机字符串
}pFYi%%D~
[root@Gin scripts]# cat /dev/urandom|strings -n 8|head -n 1
M(,FG+=
[root@Gin scripts]# cat /dev/urandom|strings -n 8|head -n 1
|NR{$LY%

[root@Gin scripts]# cat /dev/urandom|sed -e 's#[^a-zA-Z0-9]##g'|strings -n 8|head -n 1
aPdKtMod
#生成数字加字母的随机字符串，其中 strings -n设置字符串的字符数，head -n设置输出的行数。

[root@Gin scripts]# head -200 /dev/urandom|cksum|cut -d " " -f1
1182233652
#urandom的数据很多使用cat会比较慢，在此使用head读200行，cksum将读取文件内容生成唯一的表示整型数据，cut以” “分割然后得到分割的第一个字段数据
```

### 读取Linux的uuid码
UUID码全称是通用唯一识别码 (Universally Unique Identifier, UUID)，UUID格式是：包含32个16进制数字，以“-”连接号分为五段，形式为8-4-4-4-12的32个字符。linux的uuid码也是有内核提供的，在/proc/sys/kernel/random/uuid这个文件内。cat/proc/sys/kernel/random/uuid每次获取到的数据都会不同。

```shell
[root@Gin scripts]# cat /proc/sys/kernel/random/uuid |cksum|cut -f1 -d " "  #获取不同的随机整数
3838247832
[root@Gin scripts]# cat /proc/sys/kernel/random/uuid |md5sum|cut -c 1-8  #数字加字母的随机数
6092539b
```

使用linux uuid 生成100~500随机数：

```shell
function rand() {
	min=$1
	max=$(($2 - $min + 1))
	num=$(cat /proc/sys/kernel/random/uuid | cksum | awk -F ' ' '{print $1}')
	echo $(($num % $max + $min))
}

rnd=$(rand 100 500)
echo $rnd

exit 0
```
### 从元素池中随机抽取

```shell
pool=(a b c d e f g h i j k l m n o p q r s t 1 2 3 4 5 6 7 8 9 10)

num=${#pool[*]}

result=${pool[$((RANDOM%num))]}
```

用于生成一段特定长度的有数字和字母组成的字符串，字符串中元素来自自定义的池子。
```shell
#!/bin/bash
length=8
i=1

seq=(0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)

num_seq=${#seq[@]}

while [ "$i" -le "$length" ]
do
    seqrand[$i]=${seq[$((RANDOM%num_seq))]}
    let "i=i+1"
done

random_str=$(IFS=; echo "${seqrand[*]}")
echo "The random string is: ${random_str}"

```

执行该脚本得到以下结果：

```shell
[root@Gin scripts]# sh seqrand.sh
The random string is: aOvZcYOZ
[root@Gin scripts]# sh seqrand.sh
The random string is: Eylv8JHr
[root@Gin scripts]# sh seqrand.sh
The random string is: 1sJd2GT8
```
### 随机数应用

（1）随机数在互联网中应用广泛如计算机仿真模拟、数据加密、网络游戏等，在登录某些论坛或游戏时，系统会产生一个由随机数字和字母组成的图片，用户必须正确输入，这是防止恶意攻击的很好的方法，因比较难破解图片格式的字符。其关键技术就是产生随机数，再使用ASP.NET等工具将这些字符串封装成图片格式以作为验证图片。

（2）网络游戏中也常利用随机数完成一些功能，比如掷骰子、发扑克牌等。以下是连续掷1000次骰子，然后统计出1～6点的次数：

```shell
#!/bin/bash

#RANDOM=$$

PIPS=6
MAX=1000
throw=1

one=0
two=0
three=0
four=0
five=0
six=0

count() {
	case "$1" in
	0) let "one=one+1" ;;
	1) let "two=two+1" ;;
	2) let "three=three+1" ;;
	3) let "four=four+1" ;;
	4) let "five=five+1" ;;
	5) let "six=six+1" ;;
	esac
}

while [ "$throw" -le "$MAX" ]; do
	let "dice=RANDOM % $PIPS"
	count $dice
	let "throw=throw+1"
done

echo "The statistics results are as follows:"
echo "one=$one"
echo "two=$two"
echo "three=$three"
echo "four=$four"
echo "five=$five"
echo "six=$six"
```