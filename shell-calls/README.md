# Shell脚本之间调用

shell脚本之间调用，采用fork、exec和source方式之间的区别：

| Command | Explanation                                                  |
| ------- | ------------------------------------------------------------ |
| fork    | 新开一个子 Shell 执行，子 Shell 可以从父 Shell 继承环境变量，但是子 Shell 中的环境变量不会带回给父 Shell。 |
| exec    | 在同一个 Shell 内执行，但是父脚本中 exec 行之后的内容就不会再执行了 |
| source  | 在同一个 Shell 中执行，在被调用的脚本中声明的变量和环境变量, 都可以在主脚本中进行获取和使用，相当于合并两个脚本在执行。 |

## 示例

第一个脚本，命名为 `dispatcher.sh`:

```sh
#!/bin/bash

echo "The PID of the shell script $0 before it is executed is $$"

export A=1
echo "In dispatcher.sh: variable A=$A"

case $1 in
        --exec)
                echo -e "using the exec method of execution\n"
                exec ./task.sh ;;
        --source)
                echo -e "using the source method of execution\n"
                . ./task.sh ;;
        *)
                echo -e "using the exec method of execution by default\n"
                ./task.sh ;;
esac

echo "The PID of the shell script $0 after it is executed is $$"
echo -e "In  $0: variable A=$A\n"
```

第二个脚本，命名为 `task.sh`：

```sh
#!/bin/bash

echo "The PID of the shell script task.sh: $$"
echo "In task.sh get variable A=$A from dispatcher.sh"

export A=2

echo -e "In task.sh: variable A=$A\n"
```

注：这两个脚本中的参数 $$ 用于返回脚本的 PID , 也就是进程 ID。是想通过显示 PID 判断两个脚本是分开执行还是同一进程里执行，也就是是否有新开子 Shell。当执行完脚本 task.sh 后，脚本 dispatcher.sh 后面的内容是否还执行。

给脚本加上可执行权限：
```
chmod +x dispatcher.sh task.sh 
```

## fork

```sh
root@ubuntu:~# ./dispatcher.sh
The PID of the shell script ./dispatcher.sh before it is executed is 19633
In ./dispatcher.sh: variable A=1
using the fork method of execution by default

The PID of the shell script task.sh: 19634
In task.sh get variable A=1 from dispatcher.sh
In task.sh: variable A=2

The PID of the shell script ./dispatcher.sh after it is executed is 19633
In ./dispatcher.sh: variable A=1
```

fork 方式可以看出，两个脚本都执行了，运行顺序为dispatcher-task-dispatcher，从两者的PID值(dispatcher.sh PID=19633, task.sh PID=19634)，可以看出，两个脚本是分成两个进程运行的。

## exec

```sh
root@ubuntu:~# ./dispatcher.sh --exec
The PID of the shell script ./dispatcher.sh before it is executed is 19654
In ./dispatcher.sh: variable A=1
using the exec method of execution

The PID of the shell script task.sh: 19654
In task.sh get variable A=1 from dispatcher.sh
In task.sh: variable A=2
```

exec 方式运行的结果是，task.sh 执行完成后，不再回到 dispatcher.sh。运行顺序为 dispatcher-task。从pid值看，两者是在同一进程 PID=19654 中运行的。

## source

```sh
root@ubuntu:~#  ./dispatcher.sh --source
The PID of the shell script ./dispatcher.sh before it is executed is 19704
In ./dispatcher.sh: variable A=1
using the source method of execution

The PID of the shell script task.sh: 19704
In task.sh get variable A=1 from dispatcher.sh
In task.sh: variable A=2

The PID of the shell script ./dispatcher.sh after it is executed is 19704
In ./dispatcher.sh: variable A=2
```

source方式的结果是两者在同一进程里运行。该方式相当于把两个脚本先合并再运行。

