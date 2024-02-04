# shift

shift命令用于对参数的移动(左移)，通常用于在不知道传入参数个数的情况下依次遍历每个参数然后进行相应处理（常见于Linux中各种程序的启动脚本）。

## 示例1:

依次读取输入的参数并打印参数个数：
```shell
#!/bin/bash
while [ $# != 0 ]; do
	echo "第一个参数为：$1,参数个数为：$#"
	shift
done
```
output:

```shell
[root@localhost ~]# ./shift.sh a b c d e f
第一个参数为：a,参数个数为：6
第一个参数为：b,参数个数为：5
第一个参数为：c,参数个数为：4
第一个参数为：d,参数个数为：3
第一个参数为：e,参数个数为：2
第一个参数为：f,参数个数为：1
```
从上可知 shift(shift 1) 命令每执行一次，变量的个数($#)减一（之前的$1变量被销毁,之后的$2就变成了$1），而变量值提前一位。

同理，shift n后，前n位参数都会被销毁，比如：

输入5个参数： a b c d e

那么$1=a,$2=b,$3=c,$4=d,$5=e,执行shift 3操作后，前3个参数a、b、c被销毁，就剩下了2个参数：d,e（这时d=$1,e=$2，其中d由$4—>$1,e由$5—>$2）,参考示例如下：

## 示例2:
```shell
#!/bin/bash
echo "参数个数为：$#,其中："
for i in $(seq 1 $#); do
	eval j=\$$i
	echo "第$i个参数($"$i")：$j"
done

shift 3

echo "执行shift 3操作后："
echo "参数个数为：$#,其中："
for i in $(seq 1 $#); do
	#通过eval把i变量的值($i)作为变量j的名字
	eval j=\$$i
	echo "第$i个参数($"$i")：$j"
done
```
output:
```shell
[root@localhost ~]# bash shift2.sh a b c d e
参数个数为：5,其中：
第1个参数($1)：a
第2个参数($2)：b
第3个参数($3)：c
第4个参数($4)：d
第5个参数($5)：e
执行shift 3操作后：
参数个数为：2,其中：
第1个参数($1)：d
第2个参数($2)：e
```