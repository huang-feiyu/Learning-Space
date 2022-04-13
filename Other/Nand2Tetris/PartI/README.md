# Part I
> [nand2tetris](https://github.com/jopdorp/nand2tetris-verilog) 仓库

本文档将会简单记录每一个 project 的实现与 debug 情况。同时，本项目不采用项目推荐的 Verilator ，转而使用 [Xilinx Vivado](https://www.xilinx.com/products/design-tools/vivado.html) 作为测试平台。（主要是因为学校课程下载之后，没有用过多少次）

## Proj 0

```bash
cd 00
iverilog hello_verilog_tb.sv -o hello
./hello
# output: Hello World!
```

环境初始化完毕。

## Proj 1

