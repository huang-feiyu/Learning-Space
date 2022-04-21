# Part I
> * [Verilog 仓库](https://github.com/jopdorp/nand2tetris-verilog)
> * [课程官网](https://www.nand2tetris.org/)

本文档将会简单记录每一个 project 的结果与 debug 情况。同时，本项目不采用项目推荐的 Verilator ，转而使用 [Xilinx Vivado](https://www.xilinx.com/products/design-tools/vivado.html) 作为测试平台。（主要是因为学校课程下载之后，没有用过多少次）

[TOC]

## Proj 0

```bash
cd 00
iverilog hello_verilog_tb.sv -o hello
./hello
# output: Hello World!
```

环境初始化完毕。

## Proj 1

实现比较简单，就是 #way 的门电路需要看电路图才能够实现。这里简单列举出来多路电路：

* Or8Way: ![HDL API & Gate Design](https://nand2tetris-hdl.github.io/img/or8.png)
* Mux4Way16: ![HDL API & Gate Design](https://nand2tetris-hdl.github.io/img/mux4.png)
* Mux8Way16: ![HDL API & Gate Design](https://nand2tetris-hdl.github.io/img/mux8.png)
* DMux4Way: ![HDL API & Gate Design](https://nand2tetris-hdl.github.io/img/dmux4.png)
* DMux8Way: ![HDL API & Gate Design](https://nand2tetris-hdl.github.io/img/dmux8.png)

---

![proj 1](README.img/image-20220414124836486.png)

## Proj 2

* Half Adder

| A (input) | B (input) | C (output) | S (output) |
| --------- | --------- | ---------- | ---------- |
| 0         | 0         | 0          | 0          |
| 1         | 0         | 0          | 1          |
| 0         | 1         | 0          | 1          |
| 1         | 1         | 1          | 0          |

* Full Adder

|  A   |  B   | Cin  | Sum  | Cout |
| :--: | :--: | :--: | :--: | :--: |
|  0   |  0   |  0   |  0   |  0   |
|  0   |  0   |  1   |  1   |  0   |
|  0   |  1   |  0   |  1   |  0   |
|  0   |  1   |  1   |  0   |  1   |
|  1   |  0   |  0   |  1   |  0   |
|  1   |  0   |  1   |  0   |  1   |
|  1   |  1   |  0   |  0   |  1   |
|  1   |  1   |  1   |  1   |  1   |

* 16-bit Adder

![image-20220416184620846](README.img/image-20220416184620846.png)

* 16-bit Incrementor

![img](https://cdn.hackaday.io/images/6423141561507977935.jpg)

* ALU

![image-20220416195032258](README.img/image-20220416195032258.png)

---

![image-20220416211926547](README.img/image-20220416211926547.png)

## Proj 3

* 1-bit register:

![img](https://zhangruochi.com/Sequential-Logic/2019/05/27/register1.png)

* 16-bit register:

![img](https://zhangruochi.com/Sequential-Logic/2019/05/27/register16.png)

* RAM:

![img](https://zhangruochi.com/Sequential-Logic/2019/05/27/RAM.png)

* PC:

![img](https://zhangruochi.com/Sequential-Logic/2019/05/27/counter.png)

---

![image-20220421225037063](README.img/image-20220421225037063.png)
