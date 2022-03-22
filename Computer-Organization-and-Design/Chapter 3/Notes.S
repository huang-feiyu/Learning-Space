# Stored computer: Everything has a memory address

# instruction: 32bits，分为不同区域，各区域提供该指令的一定信息
# R-format: 寄存器与寄存器，算术运算指令
# I-format: 寄存器与立即数，算术运算指令、读指令
# S-format: 写指令
# B-format: 分支指令
# U-format: 高二十位立即数指令
# J-format: 跳转指令


# 3.1 R型指令
# 31-25 23-20 19-15 14-12 11-7 6-0
# func7  rs2   rs1  func3  rd  opcode

# opcode: 部分标识该指令，对于R型指令为0110011
# func7+func3: 与opcode共同标识，一个操作

add x18, x19, x10
0000000_01010_10011_000_10010_0110011
# add,sub,sll,slt,sltu,xor,srl,sra,or,and


# 3.2 I型指令和S型指令
# I型指令:[-2048,2047]
#   31-20    19-15 14-12 11-7 6-0
# Imm[11:0]   rs1  func3  rd  opcode

# opcode: 0010011

addi x15, x1, -50; # x15 = x1 + -50
111111001110_00001_000_0111_0010011
# addi,slti,sltiu,xori,ori,andi

# slli,srli,srai 只用立即数低5位作为偏移量
# 高7位分别为：slli,srli,0000000;srai,0100000

# load也是I型指令,opcode=0000011
#      31-20    19-15 14-12 11-7  6-0
# offset[11:0]  base  width dest LOAD
# width标识是lb,lh,lw,lbu,lhu
lw x14, 8(x2)
000000001000_00010_010_01110_0000011

# S型指令,opcode=0100011
#     31-25    23-20 19-15 14-12      11-7      6-0
# offset[11:5]  src  base  width  offset[4:0]  STORE
sw x14, 8(x2)
0000000_01110_00010_010_01000_0100011
# sb,sh,sw


# 3.3 B型指令和U型指令
# B型指令,opcode=1100011
#     31-25       23-20 19-15 14-12      11-7         6-0
# offset[12|10:5]  rs2   rs1  func3  offset[4:1|11]  BRANCH
# offset有符号，最低bit位始终为零 [-4096,4096]
# beq,bne,blt,bge,bltu,bgeu

Loop: beq x19, x10, End
add x18, x18, x10
addi x19, x19, -1
j Loop
End: # target
# 0_000000_01010_10011_000_1000_0_1100011

# U型指令
#    31-12    11-7   6-0
# imm[31:12]  dest   LUI/AUIPC
# 高二十位立即数     Load Upper Immediate/Add Upper Immediate to PC

lui x10, 0x87654
addi x10, x10, 0x321 # 有符号操作，当数值低12位为1时，将lui装入的高20位立即数预先加1，addi写入低12位不变
# => x10=0x87654321

Lable: auipc x10, 0 # Puts address of label in x10


# 3.4 J型指令
#   31       30-21     20       19-12    11-7    6-0
# imm[20]  imm[10:1] imm[11]  imm[19:12]  rd   JAL
# offset[20:1]

j target = jal x0, Label # Discard return address
jal ra, FuncName  # call function within 2^18 and save position(PC+4) to ra
# 都是相对PC

#     31-20    19-15  14-12 11-7 6-0
# offset[11:0]  base  func3 dest JALR
# ret and jr psuedo-instructions
ret = jr ra = jalr x0, ra, 0
# call function at any 32-bit absolute address
lui x1, <hi20bits>
jalr ra, x1, <lo12bits>
# jump pc-relative with 32-bit offset
auipc x1,<hi20bits>
jalr x0,x1,<lo12bits>