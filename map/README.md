# map

当使用字符串(站点名、用户名、非顺序数字等)作为索引时，关联数组（又称map）要比数字索引更容易使用。

**使用 map 的时候, 需要先声明**, 否则结果可能与预期不同. array可以不声明.

**map 的遍历的结果是无序的, 但是对于同一个 map 多次遍历的结果的顺序是一致的**

## map的定义

方式一: 声明后再赋值

```bash
declare -A m
m["name"]=jack
```

方式二: 声明与赋值同时进行

```bash
# 使用行内“索引-值”进行赋值
declare -A m=(["name"]=jack ["age"]=20)

# 使用独立的”索引-值“进行赋值
m["name"]="john"
m["age"]="23"

```

需要注意: `=` 的前后没有任何空格, 赋值语句也是一样的. 初始化的时候是 `小括号` + `空格` 的方式进行初始化的.

## map的初始化

```bash
# 赋值
m[key]=val

# 获取, 获取的方式很固定.  "$m[key]" 这种方式是错误的.
_=${m[key]}
```

## 获取map的长度, 所有key, 所有value

- **所有的key**: `${!m[@]}`, 带有 `!`. 注意这里的结果是一个元组

- **所有的value**: `${m[@]}`, 不带 `!`. 注意这里的结果是一个元组

- **长度**: `${#m[@]}`, 带有的是 `#`

```shell
#输出所有的key
echo ${!m[@]}

#输出所有的value
echo ${m[@]}

#输出map长度
echo ${#m[@]}
```

> 顺便说一下, 元组是可以直接使用 `for...in` 的方式进行遍历的

## map遍历

根据 key 找到 value:

```bash
for key in ${!m[@]}; do
    echo "key: $key, value: ${m[$key]}"
done
```

遍历所有的 key:

```bash
for key in ${!m[@]}; do
    echo "key: $key"
done
```

遍历所有的 value:

```bash
for value in ${m[@]}; do
    echo "value: $value"
done
```

查找插入和删除，找到就删掉，没找到就插入
```bash
declare -A mymap;	#定义
#查找和删除
key="name"
value="tom"
# 查找
echo ${mymap[$key]}

if [ ! -n "${mymap[$key]}" ]; then
    mymap[$key]=$value
else
    echo "find value"
    unset mymap[$key]
fi
```

## 示例
下面有一个简单的下载安装包的例子：
```bash
./strings-to-array-output.sh ubuntu18.04
```