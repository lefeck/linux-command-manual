



脚本修改密码
定时修改密码是对服务器的安全的尊重，然而没事使用交互式修改有点烦：
脚本一：
```shell
#！/bin/bash
#此脚本用于root账号密码修改
echo "password" | passwd  root --stdin > /dev/null 2>&1
```
脚本二：
```shell
#！/bin/bash
# 此脚本用于root账号密码修改
echo root:要修改的密码|chpasswd
# 如果密码中包含 $ 字符，需要使用反斜线（\）进行转义
# 例如：
echo root:test\$|chpasswd  
```
