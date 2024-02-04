# eval

**作用：在执行命令前扫描后面的命令**

* 如果是普通的命令
  - 直接执行命令

* 如果含有间接引用
  - 执行变量替换
  - 执行替换以后的命令

## 示例

假设 employee.txt 文件的每一行描述了一个员工的基本信息，包含三列，分别是：姓名，邮箱，岗位类型，例如：
```shell
$ cat << eof > employee.txt
zhoumin zhoumin@abc.cn dev
zhangsan zhangsan@abc.cn test
eof
```
则 info_employee.sh 脚本可以根据员工的姓名查看其它信息：
```shell
#!/bin/bash

[ -z "$1" ] && echo "Usage: $0 name" && exit -1
 
file=employee.txt
 
name=$1
email=-
job=-
 
eval $(cat $file |sed -n -e "/^$name[ ]*\([0-9a-z@.]*\)[ ]*\(.*\)/s//email='\1';job='\2'/p")
 
echo "user: $name"
echo "email: $email"
echo "job: $job"
```
output:

其中，eval 很好的解决了在 sed 中对变量进行赋值的问题，我们可以通过bash -x参数debug这个参数解析的流程，执行效果如下：
```shell
[root@localhost ~]# bash -x eval.sh zhoumin
+ '[' -z zhoumin ']'
+ file=employee.txt
+ name=zhoumin
+ email=-
+ job=-
++ cat employee.txt
++ sed -n -e '/^zhoumin[ ]*\([0-9a-z@.]*\)[ ]*\(.*\)/s//email='\''\1'\'';job='\''\2'\''/p'
+ eval 'email='\''zhoumin@abc.cn'\'';job='\''dev'\'''
++ email=zhoumin@abc.cn
++ job=dev
+ echo 'user: zhoumin'
user: zhoumin
+ echo 'email: zhoumin@abc.cn'
email: zhoumin@abc.cn
+ echo 'job: dev'
job: dev
[root@master ~]# bash -x eval.sh -h
+ '[' -z -h ']'
+ file=employee.txt
+ name=-h
+ email=-
+ job=-
++ cat employee.txt
++ sed -n -e '/^-h[ ]*\([0-9a-z@.]*\)[ ]*\(.*\)/s//email='\''\1'\'';job='\''\2'\''/p'
+ eval
+ echo 'user: -h'
user: -h
+ echo 'email: -'
email: -
+ echo 'job: -'
job: -
```
output：

非debug模式输出信息
```shell
[root@localhost ~]# ./info_employee.sh zhoumin
user: zhoumin
email: zhoumin@abc.cn
job: dev
 
[root@localhost ~]#  ./info_employee.sh zhangsan
user: zhangsan
email: zhangsan@abc.cn
job: test


```