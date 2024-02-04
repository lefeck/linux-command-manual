trap命令


## Linux信号

Linux系统利用信号与系统中的进程进行通信。Linux的常见信号有：

| 信号 | 值      | 描述                           |
| :--- | :------ | :----------------------------- |
| 1    | SIGHP   | 挂起进程                       |
| 2    | SIGINT  | 终止进程                       |
| 3    | SIGQUIT | 停止进程                       |
| 9    | SIGKILL | 无条件终止进程                 |
| 15   | SIGTERM | 尽可能终止进程                 |
| 17   | SIGSTOP | 无条件停止进程，但不是终止进程 |
| 18   | SIGTSTP | 停止或暂停进程，但不终止进程   |
| 19   | SIGCONT | 继续运行停止的进程             |


## 信号组合键

Ctrl+C组合键会产生SIGINT信号，Ctrl+Z会产生SIGTSTP信号。

## trap命令

trap命令允许你来指定shell脚本要监视并拦截的Linux信号。trap命令的格式为：trap commands signals。

## 例子

当shell收到 HUP INT PIPE QUIT TERM 这几个命令时，当前执行的程序会执行 exit 1。
```shell
trap "exit 1" HUP INT PIPE QUIT TERM
```

### 清理临时文件

下面展示了如果有人试图从终端中止程序时，如何删除文件然后退出：
```shell
trap "rm -f $WORKDIR/work1 $WORKDIR/dataout; exit" 2
```
执行shell程序，如果程序接收信号为2，那么这两个文件 （work1 和 dataout） 将被自动删除。

添加信号1 SIGHUP：

```shell
trap "rm $WORKDIR/work1 $WORKDIR/dataout; exit" 1 2
```

### 忽略信号

如果陷阱列出的命令是空的，指定的信号接收时，将被忽略：
```shell
trap '' 2
```
忽略多个信号：
```shell
trap '' 1 2 3 15
```
### trap取消

当你改变了收到信号后采取的动作，你可以省略第一个参数来重置到默认行为。

```shell
trap 1 2
```
注意

显示特定SIGNAL的trap action：

```shell
trap -p SIGINT SIGTERM
```