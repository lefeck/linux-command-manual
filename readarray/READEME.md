## readarray

bash提供了两个内置命令：readarray和mapfile，它们是同义词。它们的作用是从标准输入读取一行行的数据，然后每一行都赋值给一个数组的各元素。
显然，在shell编程中更常用的是从文件、从管道读取，不过也可以从文件描述符中读取数据。

## 示例
```shell
$ cat alpha.log | readarray arr
$ echo ${#arr[@]}
0
```
从结果中可以看到，myarr1根本就不存在。为什么？在shell中while循环有陷阱。这里简单说明一下，对于管道组合的多个命令，它们都会放进同一个进程组中，会进入子shell执行相关操作。当执行完毕后，进程组结束，子shell退出。而子shell中设置的环境是不会粘滞到父shell中的(即不会影响父shell)，所以myarr1数组是子shell中的数组，回到父shell就消失了。

方式一：解决方法是在子shell中操作数组
```shell
$ cat alpha.log | { readarray arr;echo ${arr[@]}; }
```

方式二：通过重定向读取
```shell
delcare -a lines
readarray -t lines < <(cat alpha.log)
for line in "${lines[@]}"; do
    echo "${line}"
done
```
⚠️：两个<之间一定要有一个空格。第2个<要与小括号紧挨着。


疑问解答：

1. 为什么<之间要有空格？因为<(cmd)是固定形式。
2. 第1个<是什么作用？是输入重定向，将后面的文件的描述符，重定向到前面的命令的标准输入。
3. 如何解释echo <(ls)的输出是/proc/self/fd/11？这也验证之前的说明，<(ls)是一个文件描述符，bash里的实现应该是从文件描述符中read，然后write到前面的命令标准输入中。与文件重定向的区别是，bash会自动区分，输入的是文件描述符还是文件。文件就先打开再读，描述符就直接读。
