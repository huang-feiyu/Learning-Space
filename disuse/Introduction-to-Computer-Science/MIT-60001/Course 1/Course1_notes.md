# Introduction to Computer Science

## Before this course:
* Required Reading:  <a href=../Resources/Python编程导论.pdf>Chapters 1 & 2.1</a>

### Chapter 1
* 计算思维：程序性思维描述信息演绎的过程
* 算法：有穷指令序列，按照明确步骤去产生一个计算结果
* 计算机：通过程序解决一切能够解决的事情
* 现代编程语言将图灵初始指令集复杂化，构成更大、更方便的初始指令集
* 编程语言：基本结构、语法、静态语义、语义

### Chapter 2
* Python: 解释型语言，可以实时反馈
* Python程序：也成为脚本，是一系列定义和命令
* 对象：具有类型，定义程序能够在该对象上做的操作
  * 标量对象：不可分，可以视作原子
    * int: 整数
    * float: 浮点数
    * bool: 布尔值
    * None
  * 非标量对象：存在内部结构
* 表达式：对象和操作符组成，相当于某个类型的对象
  * `>>>`为shell提示符，等待输入
  * `i // j`: 整数除法
  * `i / j`: 浮点数除法
  * `i ** j`: i<sup>j</sup>
  * bool: `and` `or` `not`
* 变量：将名称和对象关联起来，仅仅是名称，没有其他含义
  * 大小写敏感
* 注释：使用`#`
* 赋值操作：Python支持多重赋值

```python
# x = 2, y = 3
x, y = 2, 3
# 交换两个变量的值
x, y = y, x
```

## [In the Course:](https://www.youtube.com/watch?v=nykOeWgQcHM&list=PLUl4u3cNGP63WbdFxL8giv4yhgdMGaZNA&index=1&ab_channel=MITOpenCourseWare) 

* Practice
* 计算机：执行程序，存储结果
* 面向对象的Python
* 对象类型：
  * 标量对象：int, float, bool, None
    * use `type()` to check
    * `float(2)`强转
  * 非标量对象：可分
* 变量：仅仅只是方便记忆和操作，仅仅是名字，代表了一个对象
