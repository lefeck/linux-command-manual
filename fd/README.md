# 文件描述符

## Overview

了解Linux怎样处理输入和输出是非常重要的。一旦我们了解其原理以后，我们就可以正确熟练地使用脚本把内容输出到正确的位置。同样我们也可以更好地理解输入重定向和输出重定向。

## Linux标准文件描述符

| 文件描述符 | 缩写   | 描述         |
| :--------- | :----- | :----------- |
| 0          | STDIN  | 标准输入     |
| 1          | STDOUT | 标准输出     |
| 2          | STDERR | 标准错误输出 |


就像我上面说的那样，既然它们是默认的，我就可以更改它们。下面的命令就是把标准输出的位置改到xlinsist文件中：

```shell
exec 1> xlinsist1
```

这回如果我输入`ls -al` 或者`ps`命令，我们的终端将不会显示任何东西。现在，我们可以新开一个终端查看xlinsist这个文件中是否有上面两个命令所显示的内容。注意：你必须新开一个终端。

同样的道理，我们也可以改变标准输入的位置。首先，我们先看看没改变的样子：

```shell
vincent@geek:~/test$ read user
xlinsist
vincent@geek:~/test$ echo $user
xlinsist
vincent@geek:~/test$12345
```

也就是我们从键盘输入把xlinsist读入到user变量。这个read需要我输入。现在，我要改变标准输入的默认位置：

```shell
#我只是把当前的标准输出重定向到test文件中
vincent@geek:~/test$ echo 'xlinsist' 1> test
vincent@geek:~/test$ cat test 
xlinsist
#我只是把当前的标准输入重定向到test文件中
vincent@geek:~/test$ read user 0< test 
vincent@geek:~/test$ echo $user
xlinsist
vincent@geek:~/test$ 123456789
```

从上面的read命令中可以看作，我并没有被要求输入什么。

标准错误输出和标准输出的区别是，它在命令出错情况下的输出。这没有什么太大的不同，我们也可以把它的输出修改到任何我们想要的位置。只不过我们需要把上面标准输出的1改成2，命令如下：

```shell
exec 2> xlinsist1
```



当然，除了0， 1，2以外，我们可以分配自己的文件描述符。看下面的例子：

```shell
vincent@geek:~/test$ exec 6>test
vincent@geek:~/test$ echo 'i love linux shell!!!' 1>&6
vincent@geek:~/test$ cat test 
i love linux shell!!!1234
```



上面的命令很有意思：我首先把文件描述符6指向test文件。因为不像描述符1，所有的输出都会自然找它，然后看它是定向到显示器还是某个文件。所以当我们想找描述符6的时候我们要用&来引用它。其实我们可以把文件描述符想像成一个文件的引用，它可以指向任何一个文件（包括显示器），指向的过程就是我们修改默认位置的过程。而用&符号来找到它指向的目标文件，从而向其写入数据。

如果你真正了解了上面的原理后，我们就可以随便玩什么输入重定向啊、输出重定向啊，那都是小case。现在让我们来个更加复杂的例子吧，来帮你们整理一下思路，脚本如下：

```shell
exec 3>&1
exec 1>test
echo "这句话被存到test文件中"
echo "还有这句"
exec 1>&3
echo "这句话输出到显示器"123456
```



我们来一步一步理解上面的命令：首先文件描述符1默认指向的是显示器，用&来找到文件描述符1指向的目标文件，也就是显示器。因此文件描述符3也指向了显示器。然后，我们修改了文件描述符1指向的文件到test文件。接着两个echo命令的输出会自然去找文件描述符1，然后它看到文件描述符1指向的是test文件，所以它会把输出写到test文件中。最后，我们用&来找到文件描述符3指向的目标文件，也就是显示器，然后我们修改了文件描述符1指向的文件到显示器。因此，最后一个echo命令会自然的找文件描述符1然后输出到显示器上。

整个过程就是这样的，只要你理解了它们的原理，以后无论在脚本中怎样处理重定向的你都不会感觉到迷茫了。下面我将介绍一些与文件描述符相关的一些shell命令，这可以让你如虎添翼。

## 文件描述符相关的一些shell命令

```shell
lsof -a -p $$ -d 0,1,2

#下面为这个命令的输出
COMMAND   PID    USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
bash    22609 vincent    0u   CHR 136,13      0t0   16 /dev/pts/13
bash    22609 vincent    1u   CHR 136,13      0t0   16 /dev/pts/13
bash    22609 vincent    2u   CHR 136,13      0t0   16 /dev/pts/131234567
```
