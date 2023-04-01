# expect

expect是建立在tc基础上的一个工具，它可以让一些需要交互的任务自动化地完成。相当于模拟了用户和命令行的交互操作。 

## 安装expect工具包
```shell
yum install -y expect
```

expect 依赖于 tcl, 所以需要首先安装 tcl。可以使用rpm检查是否已经安装tcl:
```shell
rpm -qa | grep tcl
```

## expect用法

这里我们用一个示例来说明，各个命令的含义：
```sh
#!/usr/bin/expect
set timeout 30
spawn ssh -l username 192.168.1.1
expect "password:"
send "admin\r"

# expect "password:" {send "${admin}\r"} # 等同上面2行
interact
```
### 解析：

| #!/usr/bin/expect                 | 表示操作系统中该脚本使用哪一个shell来执行。这一行需要在脚本的第一行。                                                                                                         |
|-----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------|
| set timeout 30                    | set  自定义变量名：设置超时时间的，默认计时单位是：秒   。timeout -1 为永不超时                                                                                             |
| spawn ssh -l username 192.168.1.1 | spawn是进入expect环境后才可以执行的expect内部命令，如果没有装expect，需要安装expect工具包。它主要的功能是给ssh运行进程，用来传递交互指令。可以理解为启动一个新进程                                             |
| expect "password:"                | 从进程接收字符串，这里的expect是expect的一个内部命令，expect的shell命令和内部命令是一样的，但不是一个功能。这个命令的意思是判断上次输出结果里是否包含“password:”的字符串，如果有则立即返回，否则就等待一段时间后返回，这里等待时长就是前面设置的30秒； |
| send "admin\r"                    | send接收一个字符串参数admin，并将该参数发送到进程。这里就是执行交互动作，与手工输入密码的动作等效。 命令字符串结尾别忘记加上“\r”，表示“回车键”。                                                              |
| interact                          | 执行完成后保持交互状态，把控制权交给控制台，这个时候就可以手工操作了。如果没有这一句登录完成后会退出，而不是留在远程终端上。                                                                                |
| expect eof                        | 与spawn对应，表示捕捉终端输出信息终止，结束交互。                                                                                                                   |
| set username [lindex $argv n]     | expect脚本可以接受从bash传递过来的参数。可以使用[lindex $argv n]获得，n从0开始，分别表示第一个，第二个，第三个....参数，传入的参数会赋值给username变量，便于，后面调用，可以达到命令行传惨效果。                          |

示例：
```shell
#!/usr/bin/expect
#
# 参数存在argv中，使用第一个参数如下：
set param0 [lindex $argv 0]

# $argc表示参数个数,判断语句如下:
if {$argv < 1} {
    #do something
    send_user "usage: $argv0 <param1> <param2> ... "
    exit
}
```
注：

$argv0 是脚本名，但[lindex $argv 0]是第一个参数 param1, [lindex $argv 1]是第二个参数 param2, 以此类推

send_user 用来显示信息到父进程(一般为用户的shell)的标准输出。

## 重点

expect最常用的语法是来自tcl语言的模式-动作。这种语法极其灵活，下面我们就各种语法分别说明。

单一分支模式语法：
```shell
expect "hi" {send "You said hi"}
```

匹配到hi后，会输出"you said hi"

多分支模式语法：

这种模式很有用，我们在登录ssh的时候，当你是第一次登录机器和第二次登录机器的时候，交互模式是不一样的。因此，我们可以使用这种模式去解决交互模式单一的问题。

```shell
expect "hi" { send "You said hi\n" } \
"hello" { send "Hello yourself\n" } \
"bye" { send "dat was unexpected\n" }
```
匹配到hi,hello,bye任意一个字符串时，执行相应的输出。等同于如下写法：
```shell
expect {
"hi" { send "You said hi\n"}
"hello" { send "Hello yourself\n"}
"bye" { send "That was unexpected\n"}
}

```

## 示例

实现远程登录服务器，并切换到root用户下执行关闭防火墙的命令，然后退出
```shell
#!/usr/bin/expect
 
if {$argv < 4} {
    #do something
    send_user "usage: $argv0 <remote_user> <remote_host> <remote_pwd> <remote_root_pwd>"
    exit
}
 
set timeout -1
set remote_user [ lindex $argv 0 ] # 远程服务器用户名
set remote_host [ lindex $argv 1 ] # 远程服务器ip
set remote_pwd [ lindex $argv 2 ] # 远程服务器密码
set remote_root_pwd [ lindex $argv 3 ] # 远程服务器根用户密码
 
# 远程登录
spawn ssh ${remote_user}@${remote_host}
expect "*assword:" {send "${remote_pwd}\r"}
expect "Last login:"
 
# 切换到 root
send "su\r"
expect "*assword:" {send "${remote_root_pwd}\r"}
 
# 执行关闭防火墙命令
send "systemctl stop firewalld\r"
send "exit\r"
send "exit\r"
expect eof
```

批量实现多台服务器之间ssh无密码登录的相互信任关系

## 生产环境示例1

expect是交互性很强的脚本语言，可以帮助运维人员实现批量管理成千上百台服务器操作，是一款很实用的批量部署工具！(适用与大型服务器集群)
```shell
[root@localhost ~]# cat << eof >> /root/hosts
192.168.10.202
192.168.10.203
192.168.10.205
192.168.10.206
192.168.10.207
192.168.10.208
eof

[root@localhost ~]# vim /opt/ssh_auth.sh
#!/bin/sh
DEST_USER=$1
PASSWORD=$2
HOSTS_FILE=$3
if [ $# -ne 3 ]; then
    echo "Usage:"
    echo "$0 remoteUser remotePassword hostsFile"
    exit 1
fi
    
SSH_DIR=~/.ssh
SCRIPT_PREFIX=./tmp
echo ===========================
  
# 1. prepare  directory .ssh
mkdir $SSH_DIR
chmod 700 $SSH_DIR
    
# 2. generat ssh key
TMP_SCRIPT=$SCRIPT_PREFIX.sh
echo  "#!/usr/bin/expect">$TMP_SCRIPT
echo  "spawn ssh-keygen -b 1024 -t rsa">>$TMP_SCRIPT
echo  "expect *key*">>$TMP_SCRIPT
echo  "send \r">>$TMP_SCRIPT
if [ -f $SSH_DIR/id_rsa ]; then
    echo  "expect *verwrite*">>$TMP_SCRIPT
    echo  "send y\r">>$TMP_SCRIPT
fi
echo  "expect *passphrase*">>$TMP_SCRIPT
echo  "send \r">>$TMP_SCRIPT
echo  "expect *again:">>$TMP_SCRIPT
echo  "send \r">>$TMP_SCRIPT
echo  "interact">>$TMP_SCRIPT
    
chmod +x $TMP_SCRIPT
    
/usr/bin/expect $TMP_SCRIPT
rm $TMP_SCRIPT
    
# 3. generat file authorized_keys
cat $SSH_DIR/id_rsa.pub >> $SSH_DIR/authorized_keys
    
# 4. chmod 600 for file authorized_keys
chmod 600 $SSH_DIR/authorized_keys
echo ===========================
  
# 5. copy all files to other hosts
for ip in $(cat $HOSTS_FILE)  
do
    if [ "x$ip" != "x" ]; then
        echo -------------------------
        TMP_SCRIPT=${SCRIPT_PREFIX}.$ip.sh
        # check known_hosts
        val=`ssh-keygen -F $ip`
        if [ "x$val" == "x" ]; then
            echo "$ip not in $SSH_DIR/known_hosts, need to add"
            val=`ssh-keyscan $ip 2>/dev/null`
            if [ "x$val" == "x" ]; then
                echo "ssh-keyscan $ip failed!"
            else
                echo $val >> $SSH_DIR/known_hosts
            fi
        fi
        echo "copy $SSH_DIR to $ip"
                    
        echo  "#!/usr/bin/expect">$TMP_SCRIPT
        echo  "spawn scp -r  $SSH_DIR $DEST_USER@$ip:~/">>$TMP_SCRIPT
        echo  "expect *assword*">>$TMP_SCRIPT
        echo  "send $PASSWORD\r">>$TMP_SCRIPT
        echo  "interact">>$TMP_SCRIPT
            
        chmod +x $TMP_SCRIPT
        #echo "/usr/bin/expect $TMP_SCRIPT" > $TMP_SCRIPT.do
        #sh $TMP_SCRIPT.do&
        
        /usr/bin/expect $TMP_SCRIPT
        rm $TMP_SCRIPT
        echo "copy done."                
    fi
done
    
echo done.
```
最后就可以运行这个脚本ssh_auth.sh文件，ssh_auth.sh接受三个参数，远程机器用户名、密码和hosts文件名（相对路径或绝对路径均可）


## 生产环境示例2

（适用于机器数量不算多的情况下）灵活性强，遇到不同的主机密码不一致的情况，可以采用如下方式。
```shell
首先在其中任一台服务器，如192.168.10.202上生产公私钥文件：
[root@localhost ~]# cat << eof >> /root/hosts
192.168.10.202
192.168.10.203
192.168.10.205
192.168.10.206
192.168.10.207
192.168.10.208
eof

[root@localhost ~]# /root/ssh_auth.sh
#!/usr/bin/expect
# /root/ssh_auth.sh
# author wangjinhuai

SSH_DIR=/root/.ssh
SCRIPT_PREFIX=./tmp

# 自动产生ssh秘钥
TMP_SCRIPT=$SCRIPT_PREFIX.sh
echo  "#!/usr/bin/expect">$TMP_SCRIPT
echo  "spawn ssh-keygen -b 1024 -t rsa">>$TMP_SCRIPT
echo  "expect *key*">>$TMP_SCRIPT
echo  "send \r">>$TMP_SCRIPT
if [ -f $SSH_DIR/id_rsa ]; then
    echo  "expect *verwrite*">>$TMP_SCRIPT
    echo  "send y\r">>$TMP_SCRIPT
fi
echo  "expect *passphrase*">>$TMP_SCRIPT
echo  "send \r">>$TMP_SCRIPT
echo  "expect *again:">>$TMP_SCRIPT
echo  "send \r">>$TMP_SCRIPT
echo  "interact">>$TMP_SCRIPT

chmod +x $TMP_SCRIPT

/usr/bin/expect $TMP_SCRIPT

#将生产的公钥追加到authorized_keys中
cat $SSH_DIR/id_rsa.pub >> $SSH_DIR/authorized_keys

# 修改authorized_keys的权限
chmod 600 $SSH_DIR/authorized_keys        #一定要保证私钥id_rsa文件权限是600！

#读取hosts文件，ssh登录远程主机，拷贝authorized_keys到指定的文件中。
for i in `cat /root/hosts`;do 
  rsync -e "ssh -p22" -avpgolr /root/.ssh root@$i:/root/
done
```