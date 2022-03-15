# Chapter 2: Risc-V Assembly Language

# 32 register: x0 -> x31

# 2.1 算术指令
add x1, x2, x3 # x1=x2+x3
sub x1, x2, x3 # x1=x2-x3
addi t0, t1, imm # t0 = t1 + imm，没有subi指令
# x0 硬连线为0

# 2.2 访存指令
# 以字节为单位寻址，每个字地址可以拆分到 4个 字节地址，在小段系统中某个字的地址与它的最低位字节地址相同
# 32个寄存器只有128字节的容量，DRAM数GB

lw t1, 0(s1) # load word, 0 is offset
sw t1, 0(s1) # store word
# lb, sb => load/store byte
# lbu => 无符号扩展

# 2.3 条件判断分支转移指令
beq t0, t1, target # if t0 == t1 then target
bne t0, t1, target # if t0 != t1 then target
blt t0, t1, target # if t0 < t1 then target
bge t0, t1, target # if t0 >= t1 then target
# bltu

# 2.4 逻辑运算指令
# &:and, |:or, ^:xor, <<:sll, >>:srl
and a, b, c # a = b & c
andi a, b, imm # a = b & imm
xor a, b, 0x11111111 # a = not b
# sra, sla => 算术右/左移

# 2.5 函数调用指令
# 每条指令都按32位机器码保存在机器中
# a0-a7 -> x10-x17，传递参数; a0,a1 传递返回值;
# ra->x1 保存返回时的返回地址值; s0-s11 ->x8-x9,x18-x27 保存寄存器
# 函数调用基本过程：保存参数 => 控制权转移 => 申请内存空间 => 执行函数 =>
#                保存结果、还原寄存器、释放内存空间 => 控制权返回

j target  # jump to target
jr ra   # jump to ra，保证多次调用的灵活性
jal target  # jump to target and save position to ra

# 2.6 栈的使用
# 栈区位置：0xbfff_fff0 开始，向低地址扩展，以16-byte为界
# sp++ => 压栈，sp-- => 弹栈
# 保留寄存器：sp, gp, tp, s0-s11

# push
addi sp, sp, -8 # space on stack
sw ra, 4(sp) # save ret addr
sw al, 0(sp) # save y
# pop
lw al, 0(sp) # restore y
lw ra, 4(sp # get ret addr
addi sp, sp, 8 # restore stack

# 静态区：保存在程序中只声明一次的全局变量，在程序执行完后释放
# 堆区：malloc申请的动态存储空间，保存一些程序中的动态变量
# 栈区：发生函数调用时用来保存寄存器值的存储空间

