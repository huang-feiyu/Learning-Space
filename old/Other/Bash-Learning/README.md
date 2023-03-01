---
title:      Notes-of-Bash
subtitle:   Bash学习笔记
date:       2021-10-30
author:     Huang
---

[TOC]

### Bash学习笔记

 学习[Bash](https://wangdoc.com/bash/)使用的资料是阮一峰的bash教程。（当然，这篇文章中的bash和Shell是同义的）

###### 简单介绍

* Shell: 人与计算机系统交互的工具
* `echo`: 输出文本（多行使用双引号）
  * -n: 取消换行符
  * -e: 解释特殊字符
* `;`：命令结束符
*  command1 `&&` command 2: 1运行成功，则继续运行2
* command1 `||` command 2: 1运行失败，则运行2
* `type`: 查看命令类型

###### 行操作

```bash
set editing-mode vi
```

使用vim可以更加迅速，推荐使用zsh的vi-mode

* `ctrl+l`: 清屏
* `ctrl+c`: 中止
* `shift+Pageup`: 向上滚动
* `shift+Pagedown`: 向下滚动
* `ctrl+u`: 删除光标前所有
* `ctrl+k`: 删除光标后所有
* `ctrl+d`: 关闭shell会话
* `ctrl+a`: 回到行首

###### 模式扩展

* 模式扩展：特殊字符、通配符的扩展。bash先进行扩展，再执行命令
  * 并没有[正则表达式](https://github.com/huang-feiyu/Learning-Space/tree/master/Other/RegEx-Learning)那样强大灵活，但是胜在简单和方便
* `~`: 扩展为当前用户(Huang)的主目录
* `?`: 扩展为文件路径中任意一个非空格字符
* `*`: 扩展为文件路径中任意数量的任意字符
* `[]`: 当文件存在时扩展，取任意方括号中的一个字符
* `[start-end]`: 连续范围扩展
* `{}`: 表示分别扩展括号里的所有值
* `{start..end}`: 连续范围扩展
  * 建立文件(夹)
  * 在for循环中使用
  * {start..end..step}: 指定步长
* `$`: 变量扩展、子命令扩展`$()`、算术扩展`$(())`
* `[[:class:]]`: 字符类扩展
* `shopt`：可以调整bash行为 (zsh无法使用)
  * -s: 打开
  * -u: 关闭
  * shopt [optionname]: 查询参数打开还是关闭
  * dotglob: 隐藏文件显示
  * nullglob: 通配符不匹配任何文件名的时候，返回空字符
  * failglob: 不匹配任何文件名，报错
  * extglob: 支持量词语法
  * nocaseglob: 让通配符扩展不区分大小写
  * globstar

###### 转义和引号

* 特殊字符`\`转义
* `''` `""`:字符串
*  here 文档是一种输入多行字符串的方法

```here
<< token
text
token
```

###### 变量

* 环境变量: 
  * `env`查看
* 用户变量:
  * `set`查看
  * `unset`: 删除变量
* `export`: 输出变量
* 特殊变量

###### 字符串操作

* `${#varname}`: 查看字符串长度
* `${varname:offset:length}`: 字符串提取子串
* 搜索和替换
* 改变大小写
  * `${varname^^}`: 转为大写
  * `${varname,,}`: 转为小写

###### 算术运算

`$(())`支持算术运算

* 逻辑运算
  
	* `<`：小于
	
	* `>`：大于
	* `<=`：小于或相等
	* `>=`：大于或相等
	* `==`：相等
	* `!=`：不相等
	* `&&`：逻辑与
	* `||`：逻辑或
	* `!`：逻辑否

###### 目录堆栈

* `cd -`: 回到上一次的目录
* `pushd` 和 `popd`: 操作目录堆栈
* `dirs`: 显示堆栈的内容

###### 脚本入门

脚本：包含一系列命令的文本文件，可以重复使用、自动调用

* Shebang: 脚本第一行的名称，指定脚本通过什么解释器执行
  * 脚本文件通常使用`.sh`后缀名

```bash
#!/bin/bash
#或者
#!/bin/zsh
```

* 执行权限和路径

```bash
# 给所有用户执行权限
$ chmod +x script.sh

# 给所有用户读权限和执行权限
$ chmod +rx script.sh
# 或者
$ chmod 755 script.sh

# 只给脚本拥有者读权限和执行权限
$ chmod u+rx script.sh
```

* `env`命令

```bash
# 新建一个不带任何环境变量的shell
env -i /bin/sh
```

* 注释

```bash
# 注释
echo 'hello world' # 注释
```

* 脚本参数
  * 在脚本文件内部通过特殊变量来调用这些参数
  * `$0`：脚本文件名，即`script.sh`。
  * `$1`~`$9`：对应脚本的第一个参数到第九个参数。
  * `$#`：参数的总数。
  * `$@`：全部的参数，参数之间使用空格分隔。
  * `$*`：全部的参数，参数之间使用变量`$IFS`值的第一个字符分隔，默认为空格，但是可以自定义。
  * `$?`: 前一个命令返回值
  
* `shift`命令：删除第一个参数

* `getopts`: 用于脚本内部，可以解析复杂的脚本命令行参数。通常与`while`循环一起使用，去除脚本所有带有前置连词线`-`的参数

  ```bash
  getopts optstring name
  #       连词线参数  存储参数的变量名
  ```
* `--`配置项参数终止符

###### `read`命令
* 读入用户输入的值，设置为一个变量，方便后续使用
* 参数
* `IFS`变量: 修改`read`的分隔标志


###### 条件判断
```bash
# if
if commands; then
  commands
[elif commands; then
  commands...]
[else 
  commands]
fi

# test, if结构的判断条件一般使用test
  # 文件判断
  # 字符串判断
  # 整数判断
  # 正则判断
  # 逻辑判断 AND(&& -a) OR(|| -o) NOT(!)
  # 算术判断 ((...))
  # 普通命令逻辑运算
# 写法一
test expression
# 写法二
[ expression ]
# 写法三
[[ expression ]]

# case结构，可使用通配符
case expression in
  pattern )
    commands ;;
  pattern )
    commands ;;
  ...
esac
```

###### 循环
```bash
# while循环
while condition; do
  commands
done

# until循环
until condition; do
  commands
done

# for...in循环
for variable in list
do
  commands
done

# for循环
for (( expression1; expression2; expression3)); do
  commands
done

# 提供了break, continue的类c用法

# select结构，生成简单菜单
select name
[in list]
do
  commands
done
```

###### 函数
```bash
# 第一种
fn() {
  # codes
  # 可定义return
}

# 第二种
function fn() {
  # codes
  # 可定义return
}

# 取消一个函数
unset -f functionName

# 查看定义的所有函数
declare -f

# 查看单个函数定义
declare -f functionName
```

###### 数组
```bash
# 创建三成员数组
array[0]=val
array[1]=val
array[2]=val

ARRAY=(value1 value2 ... valueN)
# 等同于
ARRAY=(
  value1
  value2
  value3
)

# 读取数组
echo ${array[i]}
echo ${array[@]}
echo ${array[*]}

# 数组长度
${@array[*]}
${@array[@]}

# 提取数组序号，返回成员序号
echo ${!arr[@]}
echo ${!arr[*]}

# 提取数组元素
${array[@]:position:length}

# 追加数组元素
foo+=(d e f)

# 删除一个数组成员
unset foo[2]
# 删除数组
unset ARRAY
```

---

上面是非常非常简单的笔记，因为bash教程我看了很久、时间间隔很长，所以笔记并不会有任何帮助。最重要的还是去联系bash脚本编写。

这段学习就告一段落，后面还有很多更深入的东西需要学习，我会结合Linux一起学习的。

