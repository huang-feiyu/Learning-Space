# Assemble Language
> To fully understand how a program works. I just need to read them, not to
> write them.

## [RuanYiFeng](ruanyifeng.com/blog/2018/01/assembly-language-primer.html)

#### What is assembly language?
* It is binary-instruction's text form.
* opcode => assembly language

#### Register
* CPU: main memory, cache, register. (m > r > c)
* CPU: 优先读寄存器，再由寄存器和内存交换数据
* 寄存器不依靠地址区分数据，而是依靠名称。每一个寄存器都有自己的名称

##### Type
* EAX
* EBX
* ECX
* EDX
* EDI
* ESI
* EBP
* ESP
**前七个是通用的，ESP保存当前栈的地址**

#### Heap
内存存储数据：
程序运行时，操作系统分配给它一段内存，用来存储程序和运行时产生的数据.
从地址较小的起始地址到地址较大的结束地址。

用户主动请求而划分出来的内存区域叫作help,不会自动消失而是必须要手动释放。

#### Stack
栈是由于函数运行而临时占用的内存区域。

#### CPU Instruction
* push   将运算子写入栈中
* call   调用函数
* mov    将一个值写入某个寄存器中
* add    将两个运算子相加，将结果写入第一个运算子中
* pop    弹出栈顶元素到运算子指定位置
* leave  停止函数
* ret    终止当前函数执行，将执行权交还给上一层函数。当前函数的栈被回收
* lea    加载地址到寄存器
* cmp    前比后
* jmp    跳到标签处

#### Syntax
[pointer]
* operation arg1(,arg2,arg3)
* mov:  operation arg1,arg2
* add:  operation arg1,arg2

