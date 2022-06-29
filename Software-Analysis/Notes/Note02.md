# Intermediate Representation

[TOC]

* AST vs. IR
    * AST: high-level
    * IR: low-level, close to machine code; language independent; **basis for static analysis**
* 3-Address Code (**3AC**)
    * 等号右侧最多一个操作符
    * 最多三个地址
* Soot and its IR: Jimple(3AC)
    * `:=` 特殊赋值
    * `$v` 临时变量
    * invoke.+ 调用函数(?)
    * `<{method Signature}>` 类名, 返回类型, 方法名, 参数列表
    * clinit 初始化静态属性
* Static Single Assignment(SSA)
    * IR 中经典表示方式
* Basic Bloacks(BB):<br/>满足如下的条件的最大块
    * 入口为 BB 的第一个 3AC
    * 出口为 BB 的最后一个 3AC
    * Algorithm: 找到 leader
* Control Flow Analysis
    * 添加 `Entry`, `Exit` 两个结点, 后建立 CFG
    * 找到基本块
    * 添加边<br/>Algorithm: 满足 Sound 条件
