# PA 1: 数据的表示、存取和运算

[TOC]

## PA 1-1: 通用寄存器的模拟

本部分仅需要修改 `reg.h` 中 `CPU_STATE` 的结构。

```c
// nemu/src/cpu/reg.c 81行错误
reg_test: Assertioin `r.val == (sample[REG_EAX] & 0xff)` failed
```

```c
// nemu/src/cpu/reg.c
void reg_test() {
    srand(time(0));
    uint32_t sample[8]; // 8个32位unsigned int
    uint32_t eip_sample = rand();
    OPERAND r;
    /* operand.h
    typedef struct {
    	int type;
    	uint32_t addr;
    	uint8_t sreg;
    	uint32_t val;
    	size_t data_size;
    	MEM_ADDR mem_addr;
	} OPERAND;
	*/
    cpu.eip = eip_sample;
    r.type = OPR_REG;

    int i;
    for (i = REG_EAX; i <= REG_EDI; i++) {
        sample[i] = rand(); // sample作为测试随机数组
        r.data_size = 32;
        r.addr = i;
        r.val = sample[i];
        operand_write(&r);
        r.data_size = 16;
        operand_read(&r);
        fflush(stdout);
        assert(r.val == (sample[i] & 0xffff)); // 判断低16位相同
    }
    r.data_size = 8;
    r.addr = REG_AL;
    operand_read(&r); // 此处的读入操作通过该函数执行
    fflush(stdout);
    // 判断低8位相同，应该读入EAX的低十六位的低八位
    assert(r.val == (sample[REG_EAX] & 0xff));
	// ...
}
```

根据文档描述：我们希望以`cpu.eax`形式访问的和以`cpu.gpr[0]._32`形式访问的是同一个模拟寄存器，同时`cpu.gpr[0]._16`能够访问到`cpu.eax`的低16位也就是`ax寄存器`，`cpu.gpr[0]._8[0]`访问到`cpu.eax`的低8位也就是`al`寄存器等。

```c
typedef struct {
    // general purpose registers
    union {
        union {
            union {
                uint32_t _32; // 32 bits => a virtual register
                uint16_t _16; // 16L
                uint8_t _8[2]; // 8 low in 16L, 8 high in 16L
            };
            uint32_t val;
        } gpr[8]; // registers array
        struct {
            // do not change the order of the registers
            uint32_t eax, ecx, edx, ebx, esp, ebp, esi, edi;
        };
    };
	// ...
} CPU_STATE;
```

原先使用三个 [struct](https://zh.cppreference.com/w/c/language/struct) 是无法满足条件的，因为: 

* struct 是一种由一序列的成员组成的类型，成员的存储以顺序分配于内存中
* union 是由一个序列的成员组成的类型，成员存储在内存中**重叠**

关键就在于**重叠**二字：我们需要通过`cpu.gpr[0]._8[0]`访问到`cpu.eax`的低8位，那么答案就显而易见了。

## PA 1-2: 整数的表示、存储和运算

> 进位和溢出是属性不同的两个标志，分别相对于无符号数和有符号数。
>
> 无符号加溢出条件：CF=1
> 带符号加溢出条件：OF=1

### 整数的加减操作

下面是 QA :

1. `OF`(溢出) 与 `CF`(进/借位) 的差别

   `CF==1` 时得到的 `res` 仍然是正确的，而 `OF==1 ` 时得到的 `res` 是错误的。

2.  `set_OF_adc` 函数为什么与 `set_OF_add` 函数相同；`set_OF_sbb` 为什么与 `set_OF_sub` 相同

   “最高位的进位输入”不等于“最高位的进位输出”，说明产生了溢出。（我猜测）我们可以假定在进行有符号位加法过程中是不会调用 `alu_adc` 的，因为有符号加法是没有进位产生的。

3. `CF` 计算方法

   $CF=C_{\text{out}} \oplus \text{sub}$ (sub等于1作减法，sub等于0作加法; Cout为是否进位)
   
4. 负数的加减运算

   $[A-B]_补=[A]_补+[-B]_补 \mod 2^n,\quad[-B]_补 = \bar B + 1$ 

   加法器不知道所运算的是带符号数还是无符号数，仅仅进行加法运算，然后返回低n位并设置标志位。

5. <s>`alu_sbb` 中的 `set_OF_sbb` 函数为什么与 `set_OF_sub` 函数不同</s>

   <s>`res=dest-src-cf` 中 `src` 取补码过程中，`+1` 被 `cf` 干掉了。但是为什么 `cf==0` 也能干掉 $1$ 呢？搞不清楚。</s>
   
   本 QA 产生于 [When your program is a complete mess](https://devhumor.com/media/when-your-program-is-a-complete-mess):
   
   <img src="https://devhumor.com/content/uploads/images/February2020/program.jpg" alt="program" style="zoom:33%;" />

---

本部分各个函数的主体部分很容易编写，困难主要体现在对于**溢出**和**进位**的理解与认知。上面是我在写程序途中写下的 QA，可能会有错误。

> 每条加/减指令执行时，总是把运算电路中结果的低 n 位送到目标寄存器，同时根据运算结构产生相应的标志位。——Page 67

对于 `CF`，课本给出公式: $CF=C_{\text{out}} \oplus \text{sub}$：

1. 无符号数加法 `res=dest+src(+cf)` 中：当 `dest+src` 溢出，即进位时，`res=dest+src-2^n`。由于 `src<2^n`，那么 `res<dest`。
2. 无符号数减法 `res=dest-src(-cf)` 中：当 `dest-src` 借位时，`res=dest+src+2^n`。由于 `src>-2^n`，那么 `res>dest`。

对于 `OF`：

1. 有符号数加法 `res=dest+src(+cf)` 中：根据 Mooc 给出的示例代码，我们并不需要分别判断是 `pos_over` 还是 `neg_over`，仅仅根据“当且仅当两操作数符号相同，且结果的符号不同于操作数符号”判断溢出。

   `#define sign(x) ((uint32_t)(x) >> 31)` 获取无符号数转换为有符号数之后的符号。

2. 有符号数减法采用 `src` 补码计算，补码运算之后似乎无法将参数传递到 `set_OF_add` 中进行运算。此处简要说明减法 `OF` 置位: <font color=red>TODO</font>

```c
/* 我知道正确为什么正确，不知道错误为什么是错误 */
// set OF: 错误，但是能通过 test_pa-1
void set_OF_sub(uint32_t result, uint32_t src, uint32_t dest, size_t data_size) {
    result = sign_ext(result & (0xffffffff >> (32 - data_size)), data_size);
    src = sign_ext(src & (0xffffffff >> (32 - data_size)), data_size);
    dest = sign_ext(dest & (0xffffffff >> (32 - data_size)), data_size);
    src = ~src;
    src += 1;
    // make unsigned to signed
    if (sign(src) == sign(dest)) {
        cpu.eflags.OF = sign(src) != sign(result);
    } else {
        cpu.eflags.OF = 0;
    }
}

// set OF: 正确
void set_OF_sub(uint32_t result, uint32_t src, uint32_t dest, size_t data_size) {
    result = sign_ext(result & (0xffffffff >> (32 - data_size)), data_size);
    src = sign_ext(src & (0xffffffff >> (32 - data_size)), data_size);
    dest = sign_ext(dest & (0xffffffff >> (32 - data_size)), data_size);
    if (sign(src) != sign(dest)) {
        cpu.eflags.OF = (sign(src) == sign(result));
    } else {
        cpu.eflags.OF = 0; // 符号不同，必为0
    }
}

```

### 整数的逻辑运算

根据 *[C Reference](https://zh.cppreference.com/w/c/language)* 查阅运算符的作用，可以很轻松地写出来。

### 整数的移位操作
> 今天停电加上冬天电脑掉电，我的 git 仓库被干掉了。最后根据[解决方案](https://stackoverflow.com/questions/23725925/git-repository-corrupt-incorrect-header-check-loose-object-is-corrupt)解决了，但是不知道原理。我已经用了快 2 年 git，到现在还是不太会用。

根据 [*i386 Manual*](http://css.csail.mit.edu/6.858/2014/readings/i386.pdf) 查阅384页代码可以很轻松地写出来。唯一让人有些难办的就是 `alu_sar` 中设置高位为符号位，通过将 `dest` 转换为有符号数，再进行右移就能够实现。

```c
int32_t res = sign_ext(dest & (0xffffffff >> (32 - data_size)), data_size);
res >>= src;
```

---

在写这部分代码的时候，我发现前面的 `sign_ext` 函数好像用错了。

```c
// 这是返回有符号数还是无符号数呢？=> 根据群友回答是无符号数，那么应该没有错误
inline uint32_t sign_ext(uint32_t x, size_t data_size) {
    assert(data_size == 16 || data_size == 8 || data_size == 32);
    switch (data_size) {
    case 8:
        return (int32_t)((int8_t)(x & 0xff));
    case 16:
        return (int32_t)((int16_t)(x & 0xffff));
    default:
        return (int32_t)x;
    }
}
```

### 整数的乘除运算

此处手册似乎存在与实验不相符的描述：

> A doubleword operand is multiplied by EAX and the result is left in EDX:EAX. **EDX contains the high-order 32 bits of the product. The carry and overflow flags are set to 0 if EDX is 0**; otherwise, they are set to 1.

```c
// data_size 为操作数长度（比特数），在设置标志位时有用
uint64_t alu_mul(uint32_t src, uint32_t dest, size_t data_size);
// 本处应更改为：the CF and OF are set to 0 if higher-order bit is 0
// higher-order bit: the bits higher than data_size
```

---

本部分被实验简化了很多，毕竟用的是 C 语言。整数的乘除运算很容易就能够完成，但是其中原理并不是很清楚。此处应该到了数字逻辑方面的知识，这里也就不深究了。

## PA 1-3: 浮点数的表示和运算

### 框架代码简析

1. 浮点数的表示

```c
typedef union { // 存储单元重叠
    struct { // 顺序存储
        uint32_t fraction : 23;
        uint32_t exponent : 8;
        uint32_t sign : 1;
    };
    float fval;
    uint32_t val;
} FLOAT;
/*
32bits FLOAT: 以下三者共享 32位 内存单元，机器数表示一致
	* val: 单精度浮点数的二进制表示
	* fval: 单精度浮点数的 C 表示
	* struct: IEEE 754 机器码表示，仅仅将 val 划分为三个部分
	  * frac,exp,sign
**/
```

2. 阶码对齐：偏移的计算

```c
// 前面已经使得 fb 的阶码大于 fa 的阶码
// 当阶码==0时，减去偏移常量127 => 得到-127，与非规格数阶码-126不符
// 所以需要在浮点数阶码为 0 时，加上 1，使得 -127 转为 -126
shift = fb.exponent + (fb.exponent == 0) - (fa.exponent + (fa.exponent == 0));
```

3. 加法中：粘位的运算

粘位的定义：只要舍入位的右边有任何非 0 数字，粘位就被置 1；否则，置 0。

```c
bool sticky = 0; // sticky: 粘位，S
while (shift > 0) {
	sticky = sticky | (sig_a & 0x1); // 如果存在1，那么置1, 此后也为1
	sig_a = sig_a >> 1; // 右移一位
	sig_a |= sticky; // 最后一位与粘位相与
	shift--; // 重复上三行 shift 次
}
```

### 浮点数的规格化

1. 非规格数的处理

```c
if (exp == 0) {
    // 由于处理之后阶码为0，此后会减去偏置常量127 => -127
    // 这显然并不是非规格数的正确阶码，所以应该将-127时的尾数数值右移一位，得到-126时的尾数
    bool sticky = sig_grs & 0x1;
    sig_grs >>= 1;
    sig_grs |= sticky;
}
```

2. 删去附加位

使用 *就近舍入到偶数* 作为此处操作依据，见课本 74页。

```c
// 取得 guard, round, sticky
uint16_t grs = sig_grs & 0x7;
// 0x8 = 0b1000
// 附加位小于 2^3 的一半，或者 等于一半且恰好在附加位前一位的数值为偶数时，我们不需要加 1
bool if_plus = ((grs < 0x4) || ((grs == 0x4) && ((sig_grs & 0x8) == 0)));
if (if_plus) {
    sig_grs >>= 3; // remove grs
} else {
    sig_grs = (sig_grs >> 3) + 1;
    // 第二十四位为1，判断23位是否能够包含：
    if (sig_grs == 0x1000000) {
        if (exp < 0xff) {
            // 能够包含，右移一位进位规格化
            sig_grs >>= 1; // normalize
            exp++;
        } else {
            // 不能包含，即溢出(超出表示范围)
            sig_grs = 0;
            exp = 0xff;
        }
    }
}
```

3. 关于 `overflow` 的设置

实际上，此处的 `overflow` 根本没有必要。我们只需要在检测到溢出时，直接返回就行。

本处设计存在冗余，我在实现中没有作修改，所以嵌套了许多层，很不美观。

### 浮点数的加减运算

根据课本 72页 和 [指导书](https://github.com/ics-nju-wl/icspa-public-guide/blob/master/ch/ch_pa-1-3_fpu.md)，在理解 IEEE 754 浮点数规范之后，能够一步步地完成实现。这里不作为探讨的话题。

### 浮点数的乘除运算

没想到这一部分作业只需要删去三行代码，再加上一行。

对于乘法：我们选择两个 $n$ 位数进行乘法操作，会得到 $2n$ 位数。为了减少精度损失，选择使用 `uint_64_t` 进行传递。

```c
// 阶码操作：可以参见 指导书 或者 在线MOOC
exp_res = fa.exponent + fb.exponent - 127 - 20;
// 由于最后我们需要将结果规格化，所以传入 internal_normalize 中：
// 此前实现的规格化函数将尾数看作是26位:23+grs，我们现在得到的两尾数乘积为46位，
// 所以将其减去20位，减去的20位作为阶码。
```

---

对于除法：

```c
// efforts to maintain the precision of the result
int shift = 0;
while (sig_a >> 63 == 0) {
    sig_a <<= 1; // 被除数 尽可能 左移，提高精度
    shift++; // 偏移量++，阶码应减小
}
while ((sig_b & 0x1) == 0) {
    sig_b >>= 1; // 除数 尽可能 右移，提高精度
    shift++; // 偏移量++，阶码应减小
}
/* some other code */

// shift-23-3=shift-26 => 传递给规格化函数的尾数为26位，故阶码加26:23+3
uint32_t exp_res = fa.exponent - fb.exponent + 127 - (shift - 23 - 3);
```

