# 正则表达式再次学习笔记

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
