
# case

在shell编程中，对于多分支判断，用if 虽然也可以实现，但有些时候，写起来很麻烦，也不容易代码理解。这个时候，可以考虑case。

## case语句

### 语法结构
```shell
case var in     # 定义变量;var代表是变量名
pattern 1)      # 模式1;用 | 分割多个模式，相当于or
    command1    # 需要执行的语句
    ;;          # 两个分号代表命令结束
pattern 2)
    command2
    ;;
pattern 3)
    command3
    ;;
*)              # default，不满足以上模式，默认执行*)下面的语句
    command4
    ;;
esac          esac表示case语句结束
```

### 硬盘挂载示例

下面用case实现配置硬盘分区挂载等操作，代码如下：

```shell
#!/bin/bash
#打印菜单
menu(){
cat <<END
    h   显示命令帮助
    f   显示磁盘分区
    d   显示磁盘挂载
    m   查看内存使用
    u   查看系统负载
    q   退出程序
END
}
menu
while true
do
read -p "请输入你的操作[h for help]:" var1
case $var1 in
    h)
    menu
    ;;
    f)
    read -p "请输入你要查看的设备名字[/dev/sdb]:" var2
    case $var2 in
        /dev/sda)
        fdisk -l /dev/sda
        ;;
        /dev/sdb)
        fdisk -l /dev/sdb
        ;;
    esac
    ;;
    d)
    lsblk
    ;;
    m)
    free -m
    ;;
    u)
    uptime
    ;;
    q)
    exit
    ;;
esac
done
```