# NEMU Lab

本仓库为南京大学 [icspa-public](https://github.com/ics-nju-wl/icspa-public) 实验代码。

在 [docs](./docs) 中将会记录每一个 PA 的具体实现。

* [C programming language](https://zh.cppreference.com/w/c/language)
* [CMake](https://cmake.org/cmake/help/latest/guide/tutorial/index.html)
* [GDB Tutorial](https://www.cs.cmu.edu/~gilpin/tutorial/)

| PA                           | 课本对应章节         |
| ---------------------------- | -------------------- |
| PA 1: 数据的表示、存取和运算 | 第 $2$ 章            |
| PA 2: 程序执行               | 第 $3$ 章、第 $4$ 章 |
| PA 3: 存储管理               | 第 $6$ 章            |
| PA 4: 异常、中断和 I/O       | 第 $7$ 章、第 $8$ 章 |

---
* [PA 0](./docs/PA0.md): 实验环境配置
* [PA 1](./docs/PA1.md): 数据的表示、存取和运算
* PA 2: 程序的执行
  * [PA 2-3](./docs/PA2-3.md): 完善调试器
  * [PA 2-1](./docs/PA2-1.md): 指令的解码与执行
  * [PA 2-2](./docs/PA2-2.md): 装载 ELF 文件
* PA 3: 存储管理
  * [PA 3-1](./docs/PA3-1.md): Cache 模拟
  * [PA 3-2](./docs/PA3-2.md): 保护模式
  * [PA 3-3](./docs/PA3-3.md): 分页机制 & 虚拟地址转换
* PA 4: 异常、中断和 I/O
  * [PA 4-1](./docs/PA4-1.md): 异常和中断的响应
  * [PA 4-2](./docs/PA4-2.md): 外设和 I/O（本部分有错误，但是我不想再找了）
