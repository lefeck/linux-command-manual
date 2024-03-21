# shell 编程规范

## 前言

与其它的编程规范一样，这里所讨论的不仅仅是编码格式美不美观的问题， 同时也讨论一些约定及编码标准。这份文档主要侧重于我们所普遍遵循的规则， 对于那些不是明确强制要求的，我们尽量避免提供意见。

## 为什么要有编码规范

编码规范对于程序员而言尤为重要，有以下几个原因：

一个软件的生命周期中，80%的花费在于维护几乎没有任何一个软件，在其整个生命周期中，均由最初的开发人员来维护编码规范可以改善软件的可读性，可以让程序员尽快而彻底地理解新的代码
如果你将源码作为产品发布，就需要确任它是否被很好的打包并且清晰无误，一如你已构建的其它任何产品
编码规范原则

本文档中的准则致力于最大限度达到以下原则：

* 正确性
* 可读性
* 可维护性
* 可调试性
* 一致性
* 美观

尽管本文档涵盖了许多基础知识，但应注意的是，没有编码规范可以为我们回答所有问题，开发人员始终需要再编写完代码后，对上述原则做出正确的判断。

代码规范等级定义

* 可选（Optional）：用户可参考，自行决定是否采用；
* 推荐（Preferable）：用户理应采用，但如有特殊情况，可以不采用；
* 必须（Mandatory）：用户必须采用（除非是少数非常特殊的情况，才能不采用）；

注： 未明确指明的则默认为必须（Mandatory）

## 本文档参考

主要参考如下文档:

* Google Shell Style Guide
* Bash Hackers Wiki

## 基础

### 使用场景

仅建议Shell用作相对简单的实用工具或者包装脚本。因此单个shell脚本内容不宜太过复杂。

在选择何时使用shell脚本时时应遵循以下原则：

* 如主要用于调用其他工具且需处理的数据量较少，则shell是一个选择
* 如对性能十分敏感，则更推荐选择其他语言，而非shell
* 如需处理相对复杂的数据结构，则更推荐选择其他语言，而非shell
* 如脚本内容逐渐增长且有可能出现继续增长的趋势，请尽早使用其他语言重写

### 文件名

可执行文件不建议有扩展名，库文件必须使用 .sh 作为扩展名，且应是不可执行的。

执行一个程序时，无需知道其编写语言，且shell脚本并不要求具有扩展名，所以更倾向可执行文件没有扩展名。

而库文件知道其编写语言十分重要，使用 .sh 作为特定语言后缀的扩展名，可以和其他语言编写的库文件加以区分。

文件名要求全部小写, 可以包含下划线 _ 或连字符 -, 建议可执行文件使用连字符，库文件使用下划线。

正例:
```shell
my-useful-bin
my_useful_libraries.sh
myusefullibraries.sh
```

反例：
```shell
My_Useful_Bin
myUsefulLibraries.sh
```

### 文件编码

源文件编码格式为UTF-8。 避免不同操作系统对文件换行处理的方式不同，一律使用LF。

### 单行长度

每行最多不超过120个字符。每行代码最大长度限制的根本原因是过长的行会导致阅读障碍，使得缩进失效。

除了以下两种情况例外：

### 导入模块语句

注释中包含的URL

如出现长度必须超过120个字符的字符串，应尽量使用here document或者嵌入的换行符等合适的方法使其变短。

示例：

```shell
# DO use 'here document's
cat <<END;
I am an exceptionally long
string.
END

# Embedded newlines are ok too
long_string="I am an exceptionally
  long string."
```

### 空白字符

除了在行结束使用换行符，空格是源文件中唯一允许出现的空白字符。

* 字符串中的非空格空白字符，使用转义字符
* 不允许行前使用tab缩进，如果使用tab缩进，必须设置1个tab为4个空格
* 不应在行尾出现没有意义的空白字符

### 垃圾清理 推荐

对从来没有用到的或者被注释的方法、变量等要坚决从代码中清理出去，避免过多垃圾造成干扰。

### 结构

#### 使用bash

Bash 是唯一被允许使用的可执行脚本shell。

可执行文件必须以 #!/bin/bash 开始。请使用 set 来设置shell的选项，使得用 bash <script_name> 调用你的脚本时不会破坏其功能。

限制所有的可执行shell脚本为bash使得我们安装在所有计算机中的shell语言保持一致性。 

正例：

```shell
#!/bin/bash
set -e
```
反例：
```shell
#!/bin/sh -e
```

许可证或版权信息 推荐

许可证与版权信息需放在源文件的起始位置。例如：

```shell
#
# Licensed under the BSD 3-Clause License (the "License"); you may not use this file except
# in compliance with the License. You may obtain a copy of the License at
#
# https://opensource.org/licenses/BSD-3-Clause
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#

```
### 缩进

#### 块缩进

每当开始一个新的块，缩进增加4个空格（不能使用\t字符来缩进）。当块结束时，缩进返回先前的缩进级别。缩进级别适用于代码和注释。

```shell
main() {
    # 缩进4个空格
    say="hello"
    flag=0
    if [[ $flag = 0 ]]; then
        # 缩进4个空格
        echo "$say"
    fi
```
### 管道

如果一行容不下整个管道操作，那么请将整个管道操作分割成每行一个管段。

如果一行容得下整个管道操作，那么请将整个管道操作写在同一行，管道左右应有空格。

否则，应该将整个管道操作分割成每行一段，管道操作的下一部分应该将管道符放在新行并且缩进4个空格。这适用于管道符 | 以及逻辑运算 || 和 && 。

正例：
```shell
# 单行管道连接，管道左右空格
command1 | command2


#长命令管道换行连接，管道放置于下一个命令开头，缩进4个空格
command1 \
    | command2 \
    | command3 \
    | command4
```

反例：

```shell
# 管道左右无空格
command1|command2

# 换行连接管道放置于行末
command1 | \
    command2 | \
    command3 | \
    command4
```

### 循环

请将 ; do , ; then 和 while , for , if 放在同一行。

shell中的循环略有不同，但是我们遵循跟声明函数时的大括号相同的原则。即： ; do , ; then 应该和 while/for/if 放在同一行。 else 应该单独一行。 结束语句应该单独一行且跟开始语句缩进对齐。

正例：

```shell
for dir in ${dirs_to_cleanup}; do
    if [[ -d "${dir}/${BACKUP_SID}" ]]; then
        log_date "Cleaning up old files in ${dir}/${BACKUP_SID}"
        rm "${dir}/${BACKUP_SID}/"*
        if [[ "$?" -ne 0 ]]; then
            error_message
        fi
    else
        mkdir -p "${dir}/${BACKUP_SID}"
        if [[ "$?" -ne 0 ]]; then
            error_message
        fi
    fi
done
```
反例：

```shell
function getBatchName()
{
    batch_name="batch"
    if [[ "$input5"x == *$batch_name* ]]
    then
        batch_name=$input5
    else if [[ "$input6"x == *$batch_name* ]]
    then
        batch_name=$input6
    else if [[ "$input7"x == *$batch_name* ]]
    then
        batch_name=$input7
        fi
        fi
    fi
}
```


### case语句

通过4个空格缩进可选项。 可选项中的多个命令应该被拆分成多行，模式表达式、操作和结束符 ;; 在不同的行。 匹配表达式比 case 和 esac 缩进一级。多行操作要再缩进一级。 模式表达式前面不应该出现左括号。避免使用 ;& 和 ;;& 符号。 

示例：

```shell
case "${expression}" in
    a)
        variable="..."
        some_command "${variable}" "${other_expr}" ...
        ;;
    absolute)
        actions="relative"
        another_command "${actions}" "${other_expr}" ...
        ;;
    *)
        error "Unexpected expression '${expression}'"
        ;;
esac
```

只要整个表达式可读，简单的单行命令可以跟模式和 ;; 写在同一行。当单行容不下操作时，请使用多行的写法。 单行示例：

```shell
verbose='false'
aflag=''
bflag=''
files=''
while getopts 'abf:v' flag; do
    case "${flag}" in
        a) aflag='true' ;;
        b) bflag='true' ;;
        f) files="${OPTARG}" ;;
        v) verbose='true' ;;
        *) error "Unexpected option ${flag}" ;;
    esac
done
```
### 函数位置

将文件中所有的函数统一放在常量下面。不要在函数之间隐藏可执行代码。

如果你有函数，请将他们统一放在文件头部。只有includes， set 声明和常量设置可能在函数声明之前完成。不要在函数之间隐藏可执行代码。如果那样做，会使得代码在调试时难以跟踪并出现意想不到的结果。

### 主函数main

对于包含至少了一个其他函数的足够长的脚本，建议定义一个名为 main 的函数。对于功能简单的短脚本， main函数是没有必要的。

为了方便查找程序的入口位置，将主程序放入一个名为 main 的函数中，作为最底部的函数。这使其和代码库的其余部分保持一致性，同时允许你定义更多变量为局部变量（如果主代码不是一个函数就不支持这种做法）。 文件中最后的非注释行应该是对 main 函数的调用：

```shell
main "$@"
```

### 注释

代码注释的基本原则：

* 注释应能使代码更加明确
* 避免注释部分的过度修饰
* 保持注释部分简单、明确
* 在编码以前就应开始写注释
* 注释应说明设计思路而不是描述代码的行为

注释与其周围的代码在同一缩进级别，#号与注释文本间需保持一个空格以和注释代码进行区分。

### 文件头

每个文件的开头是其文件内容的描述。除版权声明外，每个文件必须包含一个顶层注释，对其功能进行简要概述。

例如：

```shell
#!/bin/bash
#
# Perform hot backups of databases.
```

### 功能注释

主体脚本中除简洁明了的函数外都必须带有注释。库文件中所有函数无论其长短和复杂性都必须带有注释。

这使得其他人通过阅读注释即可学会如何使用你的程序或库函数，而不需要阅读代码。

所有的函数注释应该包含：

* 函数的描述
* 全局变量的使用和修改
* 使用的参数说明
* 返回值，而不是上一条命令运行后默认的退出状态

例如：

```shell
#!/bin/bash
#
# Perform hot backups of databases.

export PATH='/usr/sbin/bin:/usr/bin:/usr/local/bin'

#######################################
# Cleanup files from the backup dir
# Globals:
#   BACKUP_DIR
#   BACKUP_SID
# Arguments:
#   None
# Returns:
#   None
#######################################
cleanup() {
    ...
}
```
### 实现部分的注释

注释你代码中含有技巧、不明显、有趣的或者重要的部分。

这部分遵循代码注释的基本原则即可。不要注释所有代码。如果有一个复杂的不易理解的逻辑，请进行简单的注释。

#### TODO注释

对那些临时的, 短期的解决方案, 或已经够好但仍不完美的代码使用 TODO 注释.

TODO 注释要使用全大写的字符串 TODO, 在随后的圆括号里写上你的名字,邮件地址, bug ID, 或其它身份标识和与这一 TODO 相关的 issue。 主要目的是让添加注释的人 (也是可以请求提供更多细节的人) 可根据规范的TODO 格式进行查找。 添加 TODO 注释并不意味着你要自己来修正,因此当你加上带有姓名的 TODO 时, 一般都是写上自己的名字。

这与C++ Style Guide中的约定相一致。

例如：

```shell
# TODO(mrmonkey): Handle the unlikely edge cases (bug ####)
# TODO(--bug=123456): remove the "Last visitors" feature
```

### 命名

#### 函数名

使用小写字母，并用下划线分隔单词。使用双冒号 :: 分隔包名。函数名之后必须有圆括号。

如果你正在写单个函数，请用小写字母来命名，并用下划线分隔单词。如果你正在写一个包，使用双冒号 :: 来分隔包名。 函数名和圆括号之间没有空格，大括号必须和函数名位于同一行。 当函数名后存在 () 时，关键词 function 是多余的，建议不带 function 的写法，但至少做到同一项目内风格保持一致。 

正例：

```shell
# Single function
my_func() {
  ...
}

# Part of a package
mypackage::my_func() {
  ...
}
```
反例：

```shell
function my_func
{
    ...
}
```
### 变量名

规则同函数名一致。

循环中的变量名应该和正在被循环的变量名保持相似的名称。 示例：

```shell
for zone in ${zones}; do
    something_with "${zone}"
done
```
### 常量和环境变量名

全部大写，用下划线分隔，声明在文件的顶部。

常量和任何导出到环境中的变量都应该大写。 示例：

```shell
# Constant
readonly PATH_TO_FILES='/some/path'

# Both constant and environment
declare -xr BACKUP_SID='PROD'
```
有些情况下首次初始化及常量（例如，通过getopts），因此，在getopts中或基于条件来设定常量是可以的，但之后应该立即设置其为只读。 值得注意的是，在函数中使用 declare 对全局变量无效，所以推荐使用 readonly 和 export 来代替。 示例：

```shell
VERBOSE='false'
while getopts 'v' flag; do
  case "${flag}" in
    v) VERBOSE='true' ;;
  esac
done
readonly VERBOSE
```

### 只读变量

使用 readonly 或者 declare -r 来确保变量只读。

因为全局变量在shell中广泛使用，所以在使用它们的过程中捕获错误是很重要的。当你声明了一个变量，希望其只读，那么请明确指出。 示例：

```shell
zip_version="$(dpkg --status zip | grep Version: | cut -d ' ' -f 2)"
if [[ -z "${zip_version}" ]]; then
  error_message
else
  readonly zip_version
fi
```
### 局部变量

每次只声明一个变量,不要使用组合声明，比如a=1 b=2;

使用 local 声明特定功能的变量。声明和赋值应该在不同行。

必须使用 local 来声明局部变量，以确保其只在函数内部和子函数中可见。这样可以避免污染全局名称空间以及避免无意中设置可能在函数外部具有重要意义的变量。

当使用命令替换进行赋值时，变量声明和赋值必须分开。因为内建的 local 不会从命令替换中传递退出码。

正例：

```shell
my_func2() {
    local name="$1"
    # 命令替换赋值，变量声明和赋值需放到不同行:
    local my_var
    my_var="$(my_func)" || return
    ...
}
```
反例：

```shell
my_func2() {
    # 禁止以下写法: $? 将获取到'local'指令的返回值, 而非 my_func
    local my_var="$(my_func)"
    [[ $? -eq 0 ]] || return

    ...
}
```
### 异常与日志

#### 异常

使用shell返回值来返回异常，并根据不同的异常情况返回不同的值。

#### 日志

所有的错误信息都应被导向到STDERR，这样将有利于出现问题时快速区分正常输出和异常输出。

建议使用与以下函数类似的方式来打印正常和异常输出：

```shell
err() {
    echo "[$(date +'%FT%T%z')]: $@" >&2
}

if ! do_something; then
    err "Unable to do_something"
    exit "${E_DID_NOTHING}"
fi
```

### 变量扩展 推荐

通常情况下推荐为变量加上大括号如 "${var}" 而不是 "$var" ，但具体也要视情况而定。

以下按照优先顺序列出建议：
* 与现有代码保持一致
* 单字符变量在特定情况下才需要被括起来
* 使用引号引用变量，参考下一节：变量引用

详细示例如下： 

正例：

```shell
# 位置变量和特殊变量，可以不用大括号:
echo "Positional: $1" "$5" "$3"
echo "Specials: !=$!, -=$-, _=$_. ?=$?, #=$# *=$* @=$@ \$=$$ ..."

# 当位置变量大于等于10，则必须有大括号:
echo "many parameters: ${10}"

# 当出现歧义时，必须有大括号:
# Output is "a0b0c0"
set -- a b c
echo "${1}0${2}0${3}0"

# 使用变量扩展赋值时，必须有大括号：
DEFAULT_MEM=${DEFUALT_MEM:-"-Xms2g -Xmx2g -XX:MaxDirectMemorySize=4g"}

# 其他常规变量的推荐处理方式:
echo "PATH=${PATH}, PWD=${PWD}, mine=${some_var}"
while read f; do
    echo "file=${f}"
done < <(ls -l /tmp)
```

反例：

```shell
# 无引号, 无大括号, 特殊变量，单字符变量
echo a=$avar "b=$bvar" "PID=${$}" "${1}"
# 无大括号产生歧义场景：以下会被解析为 "${1}0${2}0${3}0",
# 而非 "${10}${20}${30}
set -- a b c
echo "$10$20$30"
```

### 变量引用 推荐

变量引用通常情况下应遵循以下原则：

* 默认情况下推荐使用引号引用包含变量、命令替换符、空格或shell元字符的字符串
* 在有明确要求必须使用无引号扩展的情况下，可不用引号
* 字符串为单词类型时才推荐用引号，而非命令选项或者路径名
* 不要对整数使用引号
* 特别注意 [[ 中模式匹配的引号规则
* 在无特殊情况下，推荐使用 $@ 而非 $*

以下通过示例说明：
```shell

# '单引号' 表示禁用变量替换
# "双引号" 表示需要变量替换

# 示例1： 命令替换需使用双引号
flag="$(some_command and its args "$@" 'quoted separately')"

# 示例2：常规变量需使用双引号
echo "${flag}"

# 示例3：整数不使用引号
value=32
# 示例4：即便命令替换输出为整数，也需要使用引号
number="$(generate_number)"

# 示例5：单词可以使用引号，但不作强制要求
readonly USE_INTEGER='true'

# 示例6：输出特殊符号使用单引号或转义
echo 'Hello stranger, and well met. Earn lots of $$$'
echo "Process $$: Done making \$\$\$."

# 示例7：命令参数及路径不需要引号
grep -li Hugo /dev/null "$1"

# 示例8：常规变量用双引号，ccs可能为空的特殊情况可不用引号
git send-email --to "${reviewers}" ${ccs:+"--cc" "${ccs}"}

# 示例9：正则用单引号，$1可能为空的特殊情况可不用引号
grep -cP '([Ss]pecial|\|?characters*)$' ${1:+"$1"}

# 示例10：位置参数传递推荐带引号的"$@"，所有参数作为单字符串传递用带引号的"$*"
# content of t.sh
func_t() {
    echo num: $#
    echo args: 1:$1 2:$2 3:$3
}

func_t "$@"
func_t "$*"
# 当执行 ./t.sh a b c 时输出如下：
num: 3
args: 1:a 2:b 3:c
num: 1
args: 1:a b c 2: 3:
```

### 命令替换

使用 $(command) 而不是反引号。

因反引号如果要嵌套则要求用反斜杠转义内部的反引号。而 $(command) 形式的嵌套无需转义，且可读性更高。

正例：

```shell
var="$(command "$(command1)")"
```
反例：

```shell
var="`command \`command1\``"
```
### 条件测试

使用 [[ ... ]] ，而不是 [ , test , 和 /usr/bin/[ 。

因为在 [[ 和 ]] 之间不会出现路径扩展或单词切分，所以使用 [[ ... ]] 能够减少犯错。且 [[ ... ]] 支持正则表达式匹配，而 [ ... ] 不支持。 参考以下示例：

```shell
# 示例1：正则匹配，注意右侧没有引号
# 详尽细节参考：http://tiswww.case.edu/php/chet/bash/FAQ 中E14部分
if [[ "filename" =~ ^[[:alnum:]]+name ]]; then
    echo "Match"
fi

# 示例2：严格匹配字符串"f*"(本例为不匹配)
if [[ "filename" == "f*" ]]; then
    echo "Match"
fi

# 示例3：[]中右侧不加引号将出现路径扩展，如果当前目录下有f开头的多个文件将报错[: too many arguments
if [ "filename" == f* ]; then
    echo "Match"
fi
```

### 字符串测试

尽可能使用变量引用，而非字符串过滤。

Bash可以很好的处理空字符串测试，请使用空/非空字符串测试方法，而不是过滤字符，让代码具有更高的可读性。 

正例：
```shell
if [[ "${my_var}" = "some_string" ]]; then
    do_something
fi
```

反例：

```shell
if [[ "${my_var}X" = "some_stringX" ]]; then
    do_something
fi
```

正例：

```shell
# 使用-z测试字符串为空
if [[ -z "${my_var}" ]]; then
    do_something
fi
```
反例：

```shell
# 使用空引号测试空字符串，能用但不推荐
if [[ "${my_var}" = "" ]]; then
    do_something
fi
```
正例：

```shell
# 使用-n测试非空字符串
if [[ -n "${my_var}" ]]; then
    do_something
fi
```
反例：
```shell
# 测试字符串非空，能用但不推荐
if [[ "${my_var}" ]]; then
    do_something
fi
```

### 文件名扩展

当进行文件名的通配符扩展时，请指定明确的路径。

当目录中有特殊文件名如以 - 开头的文件时，使用带路径的扩展通配符 ./* 比不带路径的 * 要安全很多。

```shell
# 例如目录下有以下4个文件和子目录：
# -f  -r  somedir  somefile

# 未指定路径的通配符扩展会把-r和-f当作rm的参数，强制删除文件：
psa@bilby$ rm -v *
removed directory: `somedir'
removed `somefile'

# 而指定了路径的则不会:
psa@bilby$ rm -v ./*
removed `./-f'
removed `./-r'
rm: cannot remove `./somedir': Is a directory
removed `./somefile'
```

### 慎用eval

应该避免使用eval。

Eval在用于分配变量时会修改输入内容，但设置变量的同时并不能检查这些变量是什么。

反例：
```shell

# 以下设置的内容及成功与否并不明确
eval $(set_my_variables)
```

### 慎用管道连接while循环

请使用进程替换或者for循环，而不是通过管道连接while循环。

这是因为在管道之后的while循环中，命令是在一个子shell中运行的，因此对变量的修改是不能传递给父shell的。

这种管道连接while循环中的隐式子shell使得bug定位非常困难。 

反例：

```shell
last_line='NULL'
your_command | while read line; do
    last_line="${line}"
done

# 以下会输出'NULL'：
echo "${last_line}"
如果你确定输入中不包含空格或者其他特殊符号（通常不是来自用户输入），则可以用for循环代替。 例如：

total=0
# 仅当返回结果中无空格等特殊符号时以下可正常执行：
for value in $(command); do
    total+="${value}"
done
```

使用进程替换可实现重定向输出，但是请将命令放入显式子shell，而非while循环创建的隐式子shell。 例如：

```shell
total=0
last_file=
# 注意两个<之间有空格，第一个为重定向，第二个<()为进程替换
while read count filename; do
    total+="${count}"
    last_file="${filename}"
done < <(your_command | uniq -c)

echo "Total = ${total}"
echo "Last one = ${last_file}"
```

### 检查返回值

总是检查返回值，且提供有用的返回值。

对于非管道命令，使用 $? 或直接通过 if 语句来检查以保持其简洁。

例如：

```shell
# 使用if语句判断执行结果
if ! mv "${file_list}" "${dest_dir}/" ; then
    echo "Unable to move ${file_list} to ${dest_dir}" >&2
    exit "${E_BAD_MOVE}"
fi

# 或者使用$?
mv "${file_list}" "${dest_dir}/"
if [[ $? -ne 0 ]]; then
    echo "Unable to move ${file_list} to ${dest_dir}" >&2
    exit "${E_BAD_MOVE}"
fi
```
### 内建命令和外部命令

**当内建命令可以完成相同的任务时，在shell内建命令和调用外部命令之间，应尽量选择内建命令。**

因内建命令相比外部命令而言会产生更少的依赖，且多数情况调用内建命令比调用外部命令可以获得更好的性能（通常外部命令会产生额外的进程开销）。

正例：

```shell
# 使用内建的算术扩展
addition=$((${X} + ${Y}))
# 使用内建的字符串替换
substitution="${string/#foo/bar}"
```
反例：

```shell
# 调用外部命令进行简单的计算
addition="$(expr ${X} + ${Y})"
# 调用外部命令进行简单的字符串替换
substitution="$(echo "${string}" | sed -e 's/^foo/bar/')"

```
### 文件加载

加载外部库文件不建议用使用，建议使用source，已提升可阅读性。 正例：

```shell
source my_libs.sh
```
反例：

```shell
. my_libs.sh
```

### 内容过滤与统计

除非必要情况，尽量使用单个命令及其参数组合来完成一项任务，而非多个命令加上管道的不必要组合。 

常见的不建议的用法例如：
cat和grep连用过滤字符串; 
cat和wc连用统计行数; 
grep和wc连用统计行数等。

正例：

```shell
grep net.ipv4 /etc/sysctl.conf
grep -c net.ipv4 /etc/sysctl.conf
wc -l /etc/sysctl.conf
```
反例：
```shell
cat /etc/sysctl.conf | grep net.ipv4
grep net.ipv4 /etc/sysctl.conf | wc -l
cat /etc/sysctl.conf | wc -l
```

### 正确使用返回与退出

除特殊情况外，几乎所有函数都不应该使用exit直接退出脚本，而应该使用return进行返回，以便后续逻辑中可以对错误进行处理。

正例：
```shell
# 当函数返回后可以继续执行cleanup
my_func() {
    [[ -e /dummy ]] || return 1
}

cleanup() {
    ...
}

my_func
cleanup
```
反例：

```shell
# 当函数退出时，cleanup将不会被执行
my_func() {
    [[ -e /dummy ]] || exit 1
}

cleanup() {
    ...
}

my_func
cleanup

```
