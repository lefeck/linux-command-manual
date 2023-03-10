# Shell 函数
shell 函数的本质是一段可以重复使用的脚本代码，这段代码被提前编写好了，放在了指定的位置，使用时直接调取即可。

## 函数定义
shell中函数的定义格式如下：

```shell
[ function ] name [()] {
    action
    [return value]

}
```
说明：
* function 是Shell中专门用来定义函数的关键字，是可以忽略不写；
* name 是函数名，必须要写；
* action是函数内要执行的代码；
* return value表示函数的返回值，return是Shell关键字，专门用在函数中返回一个值(value 范围0-255)；这一部分可以写也可以不写。

## 函数简写

如果你嫌麻烦，函数定义时也可以不写 function 关键字：
```shell
name() {
    statements
    [return value]
}
```

如果写了 function 关键字，也可以省略函数名后面的小括号：
```shell
function name {
    statements
    [return value]
}
```
建议使用标准的写法，能够做到“见名知意”。

## 函数调用

下面例子定义了一个函数并进行调用：
```shell
#!/bin/bash
function demoFun(){
    echo "hello world"
}
demoFun
```
输出结果：
```shell
hello world
```
## 示例
下面定义一个带有return语句的函数例子：
```shell
#!/bin/bash
function funReturn(){
  read -p "input first number: " firstNum
  read -p "input second number: " secondNum
  return $(($firstNum+$secondNum))
}
funReturn
echo "The sum of two numbers equals: $?"
```
输出结果：
```shell
input first number: 2
input second number: 3
The sum of two numbers equals: 5
```
注意：所有函数在使用前必须定义。这意味着必须将函数放在脚本开始部分，直至shell解释器首次发现它时，才可以使用。调用函数仅使用其函数名即可。

## 函数之间调用
有时候，我们需要一个函数去调用另外一个函数返回处理结果，来继续执行后面的逻辑，举例如下：

```shell
#!/bin/bash
# 
  
function check_ip() {
    IP=$1
    VALID_CHECK=$(echo $IP|awk -F. '$1<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
    if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$">/dev/null; then
        if [ ${VALID_CHECK:-no} == "yes" ]; then
            echo "IP $IP available."
        else
            echo "IP $IP not available!"
        fi
    else
        echo "IP format error!"
    fi
}


function check_network() {
    IpAddr="192.168.10.1"
    check_ip ${IpAddr}
    if [ $? -eq 0 ];then
        ping -c 2  -i 0.5 ${IpAddr} > /dev/null 2>&1
        if [ $? -eq 0 ];then
            echo "ip address is reachable."
        else
            echo "ip address is unreachable"
        fi
    fi
}

check_network
```