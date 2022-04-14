# Part I
> [nand2tetris](https://github.com/jopdorp/nand2tetris-verilog) 仓库

本文档将会简单记录每一个 project 的结果与 debug 情况。同时，本项目不采用项目推荐的 Verilator ，转而使用 [Xilinx Vivado](https://www.xilinx.com/products/design-tools/vivado.html) 作为测试平台。（主要是因为学校课程下载之后，没有用过多少次）

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

![proj 1](README.img/image-20220414124836486.png)
