#include "cpu/cpu.h"

// return src + dest, intercept data_size bits, set higher bits to 0
uint32_t alu_add(uint32_t src, uint32_t dest, size_t data_size) {
#ifdef NEMU_REF_ALU
    return __ref_alu_add(src, dest, data_size);
#else
    uint32_t res = 0;
    res = dest + src;

    set_CF_add(res, dest, data_size);
    set_PF(res);
    // set_AF();
    set_ZF(res, data_size);
    set_SF(res, data_size);
    set_OF_add(res, src, dest, data_size);

    return res & (0xffffffff >> (32 - data_size)); // intercept
#endif
}

// return dest + src + cf, intercept data_size bits, set higher bits to 0
uint32_t alu_adc(uint32_t src, uint32_t dest, size_t data_size) {
#ifdef NEMU_REF_ALU
    return __ref_alu_adc(src, dest, data_size);
#else
    uint32_t res = 0;
    bool cf = cpu.eflags.CF;
    res = dest + src + cf;

    set_CF_adc(res, dest, cf, data_size);
    set_PF(res);
    // set_AF();
    set_ZF(res, data_size);
    set_SF(res, data_size);
    set_OF_adc(res, src, dest, data_size);

    return res & (0xffffffff >> (32 - data_size));
#endif
}

// return dest - src, intercept data_size bits, set higher bits to 0
uint32_t alu_sub(uint32_t src, uint32_t dest, size_t data_size) {
#ifdef NEMU_REF_ALU
    return __ref_alu_sub(src, dest, data_size);
#else
    uint32_t res = 0;
    res = dest - src;

    set_CF_sub(res, dest, data_size);
    set_PF(res);
    // set_AF();
    set_ZF(res, data_size);
    set_SF(res, data_size);
    set_OF_sub(res, src, dest, data_size);

    return res & (0xffffffff >> (32 - data_size));
#endif
}

// return dest - src - cf
uint32_t alu_sbb(uint32_t src, uint32_t dest, size_t data_size) {
#ifdef NEMU_REF_ALU
    return __ref_alu_sbb(src, dest, data_size);
#else
    uint32_t res = 0;
    bool cf = cpu.eflags.CF;
    res = dest - src - cf;

    set_CF_sbb(res, dest, cf, data_size);
    set_PF(res);
    // set_AF();
    set_ZF(res, data_size);
    set_SF(res, data_size);
    set_OF_sbb(res, src, dest, data_size);

    return res & (0xffffffff >> (32 - data_size));
#endif
}

// return dest AND src
uint32_t alu_and(uint32_t src, uint32_t dest, size_t data_size) {
#ifdef NEMU_REF_ALU
    return __ref_alu_and(src, dest, data_size);
#else
    uint32_t res = 0;
    res = dest & src;

    cpu.eflags.CF = 0;
    set_PF(res);
    // set_AF();
    set_ZF(res, data_size);
    set_SF(res, data_size);
    cpu.eflags.OF = 0;

    return res & (0xffffffff >> (32 - data_size));
#endif
}

// return dest OR src
uint32_t alu_or(uint32_t src, uint32_t dest, size_t data_size) {
#ifdef NEMU_REF_ALU
    return __ref_alu_or(src, dest, data_size);
#else
    uint32_t res = 0;
    res = dest | src;

    cpu.eflags.CF = 0;
    set_PF(res);
    // set_AF();
    set_ZF(res, data_size);
    set_SF(res, data_size);
    cpu.eflags.OF = 0;

    return res & (0xffffffff >> (32 - data_size));
#endif
}

// return dest XOR src
uint32_t alu_xor(uint32_t src, uint32_t dest, size_t data_size) {
#ifdef NEMU_REF_ALU
    return __ref_alu_xor(src, dest, data_size);
#else
    uint32_t res = 0;
    res = dest ^ src;

    cpu.eflags.CF = 0;
    set_PF(res);
    // set_AF();
    set_ZF(res, data_size);
    set_SF(res, data_size);
    cpu.eflags.OF = 0;

    return res & (0xffffffff >> (32 - data_size));
#endif
}

// shifts the bits of the operand upward: higher-order=>CF; low-order=>0
uint32_t alu_shl(uint32_t src, uint32_t dest, size_t data_size) {
#ifdef NEMU_REF_ALU
    return __ref_alu_shl(src, dest, data_size);
#else
    uint32_t res = 0;
    res = dest << src;

    set_CF_shl(dest, src, data_size);
    set_PF(res);
    // set_AF();
    set_ZF(res, data_size);
    set_SF(res, data_size);
    if (src == 1) { // the test won't check OF
        // 0 if the top two bits of the original operand were the same
        dest = sign_ext(dest & (0xffffffff >> (32 - data_size)), data_size);
        bool second = 0x1 & (dest >> (data_size - 2));
        cpu.eflags.OF = second ^ cpu.eflags.CF; // cf is the first
    } // else: undefined

    return res & (0xffffffff >> (32 - data_size));
#endif
}

// shift the bits of the operand downward:
// high-order bit is set to 0; low-order bit is shifted into the carry flag
uint32_t alu_shr(uint32_t src, uint32_t dest, size_t data_size) {
#ifdef NEMU_REF_ALU
    return __ref_alu_shr(src, dest, data_size);
#else
    uint32_t res = 0;
    dest = dest & (0xffffffff >> (32 - data_size));
    res = dest >> src;

    set_CF_shr(dest, src, data_size);
    set_PF(res);
    // set_AF();
    set_ZF(res, data_size);
    set_SF(res, data_size);
    if (src == 1) {
        // OF is set to the high-order bit of the original operand
        dest >>= data_size - 1;
        cpu.eflags.OF = 0x1 & dest;
    } // else: undefined

    return res & (0xffffffff >> (32 - data_size));
#endif
}

// shifts the bits of the operand upward: higher-order=>CF; low-order=>0
uint32_t alu_sal(uint32_t src, uint32_t dest, size_t data_size) {
#ifdef NEMU_REF_ALU
    return __ref_alu_sal(src, dest, data_size);
#else
    return alu_shl(src, dest, data_size);
#endif
}

// shift the bits of the operand downward:
// high-order bit is set to sign; low-order bit is shifted into the carry flag
uint32_t alu_sar(uint32_t src, uint32_t dest, size_t data_size) {
#ifdef NEMU_REF_ALU
    return __ref_alu_sar(src, dest, data_size);
#else
    int32_t res = sign_ext(dest & (0xffffffff >> (32 - data_size)), data_size);
    res >>= src;

    set_CF_sar(dest, src, data_size);
    set_PF(res);
    // set_AF();
    set_ZF(res, data_size);
    set_SF(res, data_size);
    if (src == 1) cpu.eflags.OF = 0; // OF is set to 0 for all single shifts

    return res & (0xffffffff >> (32 - data_size));
#endif
}

// return src * dest, result is left in EDX:EAX
uint64_t alu_mul(uint32_t src, uint32_t dest, size_t data_size) {
#ifdef NEMU_REF_ALU
    return __ref_alu_mul(src, dest, data_size);
#else
    uint64_t res = 0;
    res = (uint64_t)src * (uint64_t)dest;

    set_eflags_mul(res, data_size);

    return res;
#endif
}

int64_t alu_imul(int32_t src, int32_t dest, size_t data_size) {
#ifdef NEMU_REF_ALU
    return __ref_alu_imul(src, dest, data_size);
#else
    int64_t res = 0;
    res = (int64_t)src * (int64_t)dest;

    // set_eflags_imul(): undefined

    return res;
#endif
}

// return dest / src
uint32_t alu_div(uint64_t src, uint64_t dest, size_t data_size) {
#ifdef NEMU_REF_ALU
    return __ref_alu_div(src, dest, data_size);
#else
    assert(src != 0);
    uint32_t res = 0;
    res = dest / src;

    // set_eflags_div(): undefined

    return res & (0xffffffff >> (32 - data_size));
#endif
}

// return dest / src
int32_t alu_idiv(int64_t src, int64_t dest, size_t data_size) {
#ifdef NEMU_REF_ALU
    return __ref_alu_idiv(src, dest, data_size);
#else
    assert(src != 0);
    int32_t res = 0;
    res = dest / src;

    // set_eflags_idiv(): undefined

    return res & (0xffffffff >> (32 - data_size));
#endif
}

// return dest % src
uint32_t alu_mod(uint64_t src, uint64_t dest) {
#ifdef NEMU_REF_ALU
    return __ref_alu_mod(src, dest);
#else
    assert(src != 0);
    uint32_t res = 0;
    res = dest % src;

    // set_eflags_mod(): undefined

    return res;
#endif
}

// return dest % src
int32_t alu_imod(int64_t src, int64_t dest) {
#ifdef NEMU_REF_ALU
    return __ref_alu_imod(src, dest);
#else
    assert(src != 0);
    int32_t res = 0;
    res = dest % src;

    // set_eflags_mod(): undefined

    return res;
#endif
}

// set PF: set if 8L of res contain an even number of 1 bits
void set_PF(uint32_t result) {
    result = sign_ext(result & 0xff, 8); // get 8L
    uint8_t count = 0;
    for (int i = 0; i < 8; i++, result >>= 1)
        count += result & 1; // move right bit by bit

    cpu.eflags.PF = (count % 2 == 0); // is count an even
}

// set ZF: set if result is zero
void set_ZF(uint32_t result, size_t data_size) {
    result = sign_ext(result & (0xffffffff >> (32 - data_size)), data_size);
    cpu.eflags.ZF = (result == 0);
}

// set SF: set equal to high-order bit of result
void set_SF(uint32_t result, size_t data_size) {
    result = sign_ext(result & (0xffffffff >> (32 - data_size)), data_size);
    result >>= data_size - 1;
    cpu.eflags.SF = result;
}

//--------------add----------------

// set CF: set on high-order bit carry
void set_CF_add(uint32_t result, uint32_t dest, size_t data_size) {
    result = sign_ext(result & (0xffffffff >> (32 - data_size)), data_size);
    dest = sign_ext(dest & (0xffffffff >> (32 - data_size)), data_size);
    // if there is a carry, result=src+dest-2^n
    cpu.eflags.CF = (result < dest);
}

// set OF: set if result is too large a positive number
void set_OF_add(uint32_t result, uint32_t src, uint32_t dest, size_t data_size) {
    result = sign_ext(result & (0xffffffff >> (32 - data_size)), data_size);
    src = sign_ext(src & (0xffffffff >> (32 - data_size)), data_size);
    dest = sign_ext(dest & (0xffffffff >> (32 - data_size)), data_size);
    // make unsigned to signed
    if (sign(src) == sign(dest)) {
        cpu.eflags.OF = sign(src) != sign(result);
    } else {
        // src != dest: we cannot get overflow_error, 2^31 + 2^31 => -1
        cpu.eflags.OF = 0;
    }
}

//--------------adc----------------

// set CF: set on high-order bit carry
void set_CF_adc(uint32_t result, uint32_t dest, bool cf, size_t data_size) {
    result = sign_ext(result & (0xffffffff >> (32 - data_size)), data_size);
    dest = sign_ext(dest & (0xffffffff >> (32 - data_size)), data_size);
    // cannot use: result < dest + cf (there might be an overflow_error)
    cpu.eflags.CF = cf ? (result <= dest) : (result < dest);
}

// set OF: signed numbers, so we don't care if there is a cf
void set_OF_adc(uint32_t result, uint32_t src, uint32_t dest, size_t data_size) {
    set_OF_add(result, src, dest, data_size);
}

//--------------sub----------------

// set CF: set on high-order bit borrow
void set_CF_sub(uint32_t result, uint32_t dest, size_t data_size) {
    result = sign_ext(result & (0xffffffff >> (32 - data_size)), data_size);
    dest = sign_ext(dest & (0xffffffff >> (32 - data_size)), data_size);
    cpu.eflags.CF = (result > dest);
}

// set OF: set if too small a negative number (excluding sign-bit)
void set_OF_sub(uint32_t result, uint32_t src, uint32_t dest, size_t data_size) {
    result = sign_ext(result & (0xffffffff >> (32 - data_size)), data_size);
    src = sign_ext(src & (0xffffffff >> (32 - data_size)), data_size);
    dest = sign_ext(dest & (0xffffffff >> (32 - data_size)), data_size);
    if (sign(src) != sign(dest)) {
        cpu.eflags.OF = sign(src) == sign(result);
    } else {
        cpu.eflags.OF = 0;
    }
}

//--------------sbb----------------

// set CF: set on high-order bit borrow
void set_CF_sbb(uint32_t result, uint32_t dest, bool cf, size_t data_size) {
    result = sign_ext(result & (0xffffffff >> (32 - data_size)), data_size);
    dest = sign_ext(dest & (0xffffffff >> (32 - data_size)), data_size);
    cpu.eflags.CF = cf ? (result >= dest) : (result > dest); // sub^Cout
}

// set OF
void set_OF_sbb(uint32_t result, uint32_t src, uint32_t dest, size_t data_size) {
    set_OF_sub(result, src, dest, data_size);
}

//--------------shl----------------
// set CF: higher-order bit => CF
void set_CF_shl(uint32_t dest, uint32_t src, size_t data_size) {
    if (src == 0) cpu.eflags.CF = 0;

    dest <<= src - 1;
    dest = sign_ext(dest & (0xffffffff >> (32 - data_size)), data_size);
    dest >>= data_size - 1;
    cpu.eflags.CF = 0x1 & dest; // 1 bit
}

//--------------shr----------------
// set CF: lower-order bit => CF
void set_CF_shr(uint32_t dest, uint32_t src, size_t data_size) {
    if (src == 0) cpu.eflags.CF = 0;

    dest >>= src - 1;
    dest = sign_ext(dest & (0xffffffff >> (32 - data_size)), data_size);
    cpu.eflags.CF = 0x1 & dest; // 1 bit
}

//--------------sar----------------
// set CF: lower-order bit => CF
void set_CF_sar(uint32_t dest, uint32_t src, size_t data_size) {
    set_CF_shr(dest, src, data_size);
}

//--------------mul----------------
// The carry and overflow flags are set to 0 if EDX is 0;
// otherwise, they are set to 1. SF, ZF, AF, PF, and CF are undefined
void set_eflags_mul(uint64_t res, size_t data_size) {
    res >>= data_size;
    if (res == 0) {
        cpu.eflags.CF = 0;
        cpu.eflags.OF = 0;
    } else {
        cpu.eflags.CF = 1;
        cpu.eflags.OF = 1;
    }
}

