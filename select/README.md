
# select

select 表达式是 bash 的一种扩展应用，擅长于交互式场合。用户可以从一组不同的值中进行选择。格式如下：

```shell
select ITEM in [LIST]
do
  [COMMANDS]
done
```

## 单独使用 select
```shell
#!/bin/bash
PS3="Select the operation: "

select opt in add subtract multiply divide quit; do

  case $opt in
    add)
      read -p "Enter the first number: " n1
      read -p "Enter the second number: " n2
      echo "$n1 + $n2 = $(($n1+$n2))"
      ;;
    subtract)
      read -p "Enter the first number: " n1
      read -p "Enter the second number: " n2
      echo "$n1 - $n2 = $(($n1-$n2))"
      ;;
    multiply)
      read -p "Enter the first number: " n1
      read -p "Enter the second number: " n2
      echo "$n1 * $n2 = $(($n1*$n2))"
      ;;
    divide)
      read -p "Enter the first number: " n1
      read -p "Enter the second number: " n2
      echo "$n1 / $n2 = $(($n1/$n2))"
      ;;
    quit)
      break
      ;;
    *) 
      echo "Invalid option $REPLY"
      ;;
  esac
done

```
运行结果：
```shell
[root@localhost ~]# sh select.sh
1) add
2) subtract
3) multiply
4) divide
5) quit
Select the operation: 1
Enter the first number: 4
Enter the second number: 5
4 + 5 = 9
Select the operation: 2
Enter the first number: 4
Enter the second number: 5
4 - 5 = -1
Select the operation: 9
Invalid option 9
Select the operation: 5
```

## select 高级用法

如果忽略了in list列表,那么select命令将使用传递到脚本的命令行参数($@),或者是函数参数(当select是在函数中时）与忽略in list时的for语句相比较：for variable [in list]

```shell

function calculate () {
  read -p "Enter the first number: " n1
  read -p "Enter the second number: " n2
  echo "$n1 $1 $n2 = " $(bc -l <<< "$n1$1$n2")
}

PS3="Select the operation: "

function operate() {
  select opt  do
  # [in list] 被忽略, 所以'select'用传递给函数的参数.
  case $opt in
    add)
      calculate "+";;
    subtract)
      calculate "-";;
    multiply)
      calculate "*";;
    divide)
      calculate "/";;
    quit)
      break;;
    *) 
      echo "Invalid option $REPLY";;
  esac
done
}

operate add subtract multiply divide quit

exit 0
```
运行结果：
```shell
[root@controller ~]# bash select.sh 
1) add
2) subtract
3) multiply
4) divide
5) quit
Select the operation: 1
Enter the first number: 2
Enter the second number: 3
2 + 3 =  5
```

## 结合 case 使用
```shell
#!/bin/bash
Hostname=( 'host1' 'host2' 'host3' )
PS3="Please input the number of host: "
select host in ${Hostname[@]}; do
case ${host} in
    'host1')
        echo "This host is: ${host}. "
        ;;
    'host2')
        echo "This host is: ${host}. "
        ;;
    'host3')
        echo "This host is: ${host}. "
        ;;
    *)
        echo "The host is not exist! "
        break;
esac
done
```
运行结果：

```shell
[root@localhost ~]# sh select.sh
1) host1
2) host2
3) host3
   Please input the number of host: 1
   This host is: host1.
   Please input the number of host: 3
   This host is: host3.
   Please input the number of host: 4
   The host is not exist!

```
在很多场景中，结合 case 语句使用显得更加方便。上面的脚本中，重新定义了 PS3 的值，默认情况下 PS3 的值是:"#?"。

