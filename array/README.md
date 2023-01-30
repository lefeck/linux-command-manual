# array

Bash 支持普通数组和关联数组(又称map)，前者使用整数作为数组索引，后者使用字符串作为数组索引。 

BASH只支持一维数组，但参数个数没有限制。

## 数组的定义初始化

```bash
# 空数组
arr=()

# 递增索引初始化
arr=("en" "us")

# 自定义索引初始化. 这里的初始化方式和map很类似
arr=([1]="en" [3]="zh" [0]="cn")
```

## array 赋值与获取

与 map 的方式很类似.

```bash
# 赋值
arr[index]=val

# 获取, 获取的方式很固定. 
# ${arr} 代表的是数组的第一个元素.  
# "$arr[key]" 这种方式是错误的.  
echo ${arr[index]}
```

> 注意: `${arr}` 获取的是数组的第一个元素, 不是所有的元素. 数组元素获取的方式只能是 `${arr[index]}`. `$arr[index]` 这种方式看似正确, 其实是错误的. (map也遵循相同的规则)

## 获取array的长度, 所有key, 所有value, 某一个元素

- **长度**: `${#arr[@]}`, 使用 `#`. 与 map 的方式是一致的

- **所有的value**: `${arr[@]}` 或者 `${arr[*]}`. 推荐使用前一种方式. 注意这里的结果是一个元组

- **所有的key**: `${!arr[@]}` 或者 `${!arr[*]}`. 推荐使用前一种方式.

- **某一个元素**: `${arr[num]}`. 这里的num=0,1,2,3...
```bash
# 赋值
arr=("en" "us" "uk")

#查看数组里面的某一个元素;
echo ${arr[2]}

#查看数组里面所有的元素;　
echo ${arr[*]}　或者 echo ${arr[@]}

#查看数组的卷标（所有下标）;　　
echo ${!arr[*]} 或者 echo ${!arr[@]}

#查看数组里面元素的个数,即array的长度;
echo ${#arr[*]} 或者 echo ${#arr[@]}
```

## array 遍历值

> 列表遍历的方式

```bash
for i in ${arr[@]} ; do
    echo "$i"
done
```

> 根据长度遍历

```bash
for (( i = 0; i < ${#arr[@]}; ++i )); do
    echo "${arr[$i]}"
done
```

## 示例

1、从“标准输入”读入n次字符串，每次输入的字符串保存在数组array里
```shell
i=0
n=5
while [ "$i" -lt $n ] ; do
    echo "Please input strings ... `expr $i + 1`"
    read array[$i]
    b=${array[$i]}
    echo "$b"
    i=`expr $i + 1`
done
```
2、将字符串里的字母逐个放入数组，并输出到“标准输出”
```shell
chars='abcdefghijklmnopqrstuvwxyz'
for (( i=0; i<26; i++ )) ; do
    array[$i]=${chars:$i:1}
    echo ${array[$i]}
done
```
* note:  ${chars:$i:1}，表示从chars字符串的 $i 位置开始，获取 1 个字符。如果将 1 改为 3 ，就获取 3 个字符


# 数组合并
所谓 Shell 数组拼接（数组合并），就是将两个数组连接成一个数组。

拼接数组的思路是：先利用`@`或`*`，将数组扩展成列表，然后再合并到一起。格式如下：

> array_new=(${array1[@]}  ${array2[@]})
> array_new=(${array1[\*]}  ${array2[*]})

两种方式是等价的，选择其一即可。其中，array1 和 array2 是需要拼接的数组，array_new 是拼接后形成的新数组。

## 示例

```sh
#!/bin/bash

array1=(23 56)
array2=(99 "name")
array_new=(${array1[@]} ${array2[*]})
echo ${array_new[@]}  #也可以写作 ${array_new[*]}
```

运行结果：

```sh
23 56 99 name
```



# 删除数组元素

在 Shell 中，使用 unset 关键字来删除数组元素，格式如下：

> unset array_name[index]

其中，array_name 表示数组名，index 表示数组下标。

如果不写下标，而是写成下面的形式：

> unset array_name

那么就是删除整个数组，所有元素都会消失。

## 示例

```sh
#!/bin/bash

arr=(23 56 99 "name")
unset arr[1]
echo ${arr[@]}

unset arr
echo ${arr[*]}
```

运行结果：

```
23 99 name

```

注意最后的空行，它表示什么也没输出，因为数组被删除了，所以输出为空