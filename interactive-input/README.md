# Interactive input

我们在写shell脚本是总是会遇到交互式输入的问题，比如输入回车，输入`Yes/No`, `Y/N`之类，需要我们手动去输入`yes/no`，等操作命令，才能继续一下的执行操作，解决办法：

* 通常对于这个问题比较灵活的解决方法就是tcl的expect。但expect还需要另外安装，平台通用性不高，比较麻烦。            
* 另外一些简单的方法也能解决大多数的问题。 比如有一个安装脚本: `install.sh`, 脚本要求输入回车， 则可以：`echo | install.sh`; 如果要求输入`yes|no`，加回车，则可以
`echo yes|install.sh` 即可解决。

1. 利用重定向

例：以下的`test.sh`是要求我们从stdin中分别输入no，name然后分别打印出来。
```shell
root@localhost test]# cat test.sh
#! /bin/bash
read -p "input your enter number:" no
read -p "input your enter name:" name
echo you have entered $no, $name

#以下是作为输入的文件内容：
[root@localhost test]# cat input.data
1
lufubo

#然后我们利用重定向来完成交互的自动化：
[root@localhost test]# ./test.sh < input.data
you have entered 1, lufubo
```

2. 利用管道完成交互的自动化

让前个命令的输出作为后个命令的输入

举例：
```shell
[root@localhost test]# echo -e "1\nlufbo\n" | ./test.sh
you have entered 1, lufbo
```
上面中的 `"1\nlufbo\n"`中的`\n`是换行符的意思，这个比较简单的。

3. 利用expect

expect是专门用来交互自动化的工具，但它有可能不是随系统就安装好的，有时需要自己手工安装该命令

查看是否已经安装：`rpm -qa | grep expect`

以下脚本完成跟上述相同的功能

```shell
[root@localhost test]# cat expect_test.sh
#! /usr/bin/expect
spawn ./test.sh
expect "enter number:"
send "100\n"
expect "enter name:"
send "tom\n"
expect off
```
详细参数见[expect](https://github.com/lefeck/linux-command-manual/tree/main/expect)