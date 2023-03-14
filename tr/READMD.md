# tr

tr (translate)主要用于压缩重复字符，删除文件中的控制字符以及进行字符转换操作。

## 语法

```sh
tr [OPTION]... SET1 [SET2]
-s 替换重复的字符
　　-s： squeeze-repeats，用SET1指定的字符来替换对应的重复字符 （replace each input sequence of a repeated character that is listed in SET1 with a single occurrence of that character）
-d 删除字符
　　-d：delete，删除SET1中指定的所有字符，不转换（delete characters in SET1, do not translate）
-t 字符替换
　　-t：truncate，将SET1中字符用SET2对应位置的字符进行替换，一般缺省为-t
-c 字符补集替换
　　-c：complement，用SET2替换SET1中没有包含的字符
```

## 用法
```shell
# 用法1：命令的执行结果交给tr处理，其中string1用于查询，string2用于转换处理
commands|tr 'string1' 'string2'

# 用法2：tr处理的内容来自文件，记住要使用"<"标准输入
tr 'string1' 'string2' < filename

# 用法3：根据选项匹配 string1 进行相应操作，如删除操作
tr [options] 'string1' < filename
```


##  实例

-s 参数

```
[root@localhost ~]# echo "aaabbbaacccfddd" | tr -s [abcdf]
abacfd
```

可以使用这一特点，删除文件中的空白行，实质上跟上面一样，都是用SET1指定的字符来替换对应的重复字符

```sh
[root@localhost ~]# cat b.txt
I like football
Football is very fun!

Hello

[root@localhost ~]# cat b.txt | tr -s ["\n"]
I like football
Football is very fun!
Hello
```

-d 参数

```sh
[root@localhost ~]# echo "a12HJ13fdaADff" | tr -d "[a-z][A-Z]"
1213
[root@localhost ~]# echo "a1213fdasf" | tr -d [adfs]
1213
```

-t 参数

```sh
[root@localhost ~]# echo "a1213fdasf" | tr -t [afd] [AFO]
A1213FOAsF
```

上述代码将a转换为A，f转换为F，d转换为O。

可以利用这一特点，实现大小字母的转换

```sh
[root@localhost ~]# echo "Hello World I Love You" |tr -t [a-z] [A-Z]
HELLO WORLD I LOVE YOU
[root@localhost ~]# echo "HELLO WORLD I LOVE YOU" |tr -t [A-Z] [a-z]
hello world i love you
```

也可以利用字符集合进行转换

```sh
[root@localhost ~]# echo "Hello World I Love You" |tr -t [:lower:] [:upper:]
HELLO WORLD I LOVE YOU
[root@localhost ~]# 
[root@localhost ~]# echo "HELLO WORLD I LOVE YOU" |tr -t [:upper:] [:lower:]
hello world i love you
```

其它示例
```shell
cat << eof > 3.txt 	#自己创建该文件用于测试
ROOT:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
aaaaaaaaaaaaaaaaaaaa
bbbbbb111111122222222222233333333cccccccc
hello world 888
666
777
999
eof

# tr -d '[:/]' < 3.txt 				删除文件中的:和/
# cat 3.txt |tr -d '[:/]'			删除文件中的:和/
# tr '[0-9]' '@' < 3.txt 			将文件中的数字替换为@符号
# tr '[a-z]' '[A-Z]' < 3.txt 		将文件中的小写字母替换成大写字母
# tr -s '[a-z]' < 3.txt 			匹配小写字母并将重复的压缩为一个
# tr -s '[a-z0-9]' < 3.txt 			匹配小写字母和数字并将重复的压缩为一个
# tr -d '[:digit:]' < 3.txt 		删除文件中的数字
# tr -d '[:blank:]' < 3.txt 		删除水平空白
# tr -d '[:space:]' < 3.txt 		删除所有水平和垂直空白
```
字符集合如下:

```
\NNN 八进制值的字符 NNN (1 to 3 为八进制值的字符)
\\ 反斜杠
\a Ctrl-G 铃声
\b Ctrl-H 退格符
\f Ctrl-L 走行换页
\n Ctrl-J 新行
\r Ctrl-M 回车
\t Ctrl-I tab键
\v Ctrl-X 水平制表符
CHAR1-CHAR2 从CHAR1 到 CHAR2的所有字符按照ASCII字符的顺序
[CHAR*] in SET2, copies of CHAR until length of SET1
[CHAR*REPEAT] REPEAT copies of CHAR, REPEAT octal if starting with 0
[:alnum:] 所有的字母和数字
[:alpha:] 所有字母
[:blank:] 水平制表符，空白等
[:cntrl:] 所有控制字符
[:digit:] 所有的数字
[:graph:] 所有可打印字符，不包括空格
[:lower:] 所有的小写字符
[:print:] 所有可打印字符，包括空格
[:punct:] 所有的标点字符
[:space:] 所有的横向或纵向的空白
[:upper:] 所有大写字母
```