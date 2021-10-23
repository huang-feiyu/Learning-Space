# 正则表达式再次学习笔记
[TOC]
处理文本的利器。

### 练习
[Website](https://github.com/ziishaned/learn-regex/blob/master/translations/README-cn.md)地址，重新巩固一遍并且练习题目。

### 应用场景
* VSC(vs code): 使用`Ctrl+Shift+h`进行匹配替换，另外还可以通过`Ctrl+Shift+l`快速进行相同字符串匹配替换，以及`Alt+鼠标左键`进行多行匹配
* PowerToys: 批量重命名
* Everything: `Ctrl+Shift+r`开启正则表达式的匹配
* Vim: [Intro](https://www.jianshu.com/p/3abd6fbc3322)
  * 利用正则表达式查找时：使用`/\v`===\>very magic，任何元字符都不需要加反斜杠，也就是如果匹配元字符的话，需要使用转义
  * [搜索替换](https://harttle.land/2016/08/08/vim-search-in-file.html)，`:%s/{RegEx}/{RegEx}/g`全局替换
    * 删除空白行: `:%g/^$/d`
    * 删除行尾空格: `:%s/\s*$//g`
    * 删除行首空格: `:%s/^\s*//g`
* grep: 正则表达式扩展搜索`egrep`，`egrep "RegEx" filename`
* Others

### 正则表达式匹配原理
> 许多编程语言的正则表达式是基于Perl语言实现的。

[链接](https://segmentfault.com/a/1190000021787021)

笔记要点
* 正则表达式的执行通过正则表达引擎执行
* 预编译`re.compile(pattern)`比即用编译`re.match(pattern, text)`快
* DFA(Deterministic finite automaton): 确定型有穷自动机
  * 文本主导顺序
  * 记录当前所有可能: 内存占用多
  * 每个字符只检查一次
  * 不能使用反向引用等功能
* NFA(Non-deterministic finite automaton): 非确定型有穷自动机
  * pattern主导顺序
  * 会记录某个位置
  * 单个字符可能检查多次，可以回溯
  * 可以实现反向引用等功能
* 优化: 绝大多数编程语言采用NFA引擎
  ![](https://image-static.segmentfault.com/639/834/63983400-94e8245e734d3baa)

### re库使用
[链接](https://segmentfault.com/a/1190000022242427)
text: `'string'`
pattern: `r'pattern'` $\Rightarrow$ r means raw

* 常量: `int`
  * `re.IGNORECASE` / `re.I`
  * `re.ASCII` / `re.A`
  * `re.DOTALL` / `re.S`: 匹配所有，包括`\n`
  * `re.MULTILINE` / `re.M`: 多行模式
  * `re.VERBOSE` / `re.X`: 详细模式，可以加注释
* 函数
  * 查找一个匹配项
    ==返回一个匹配对象Match，需要通过`match.group()获取匹配值`==
    * `re.search()`: 查找任意位置匹配项
    * `re.match()`: 从字符串开头匹配
    * `re.fullmatch()`: 整个字符串与pattern完全匹配
  * 查找多个匹配项
    * `re.findall()`: 返回列表
    * `re.finditer()`: 返回一个迭代器
  * 分割
    * `re.split()`
  * 替换
    * `re.sub()`
    * `re.subn()`返回一个元组
  * 编译正则对象
    * `re.compile()`
    * `re.template()`
  * Others
    * `re.purge()`: 清除缓存
* 异常
  * `re.error`: pattern有问题
* 正则对象Pattern
  * `re.compile()`可以预编译返回一个正则对象，Pattern对象与`re`模块具有相同的函数
  * 如果需要多次使用一个正则表达式，可以使用`re.compile()`保存正则对象，以达到更高效的目的

