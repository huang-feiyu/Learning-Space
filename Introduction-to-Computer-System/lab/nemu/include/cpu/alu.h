#ifndef __ALU_H__
#define __ALU_H__

#include <cpu-ref/alu_ref.h>

// dest + src
uint32_t alu_add(uint32_t src, uint32_t dest, size_t data_size);
// dest + src + CF
uint32_t alu_adc(uint32_t src, uint32_t dest, size_t data_size);
// dest - src
uint32_t alu_sub(uint32_t src, uint32_t dest, size_t data_size);
// dest - src - CF
uint32_t alu_sbb(uint32_t src, uint32_t dest, size_t data_size);

// dest & src
uint32_t alu_and(uint32_t src, uint32_t dest, size_t data_size);
// dest ^ src
uint32_t alu_xor(uint32_t src, uint32_t dest, size_t data_size);
// dest | src
uint32_t alu_or(uint32_t src, uint32_t dest, size_t data_size);
// dest << src
uint32_t alu_shl(uint32_t src, uint32_t dest, size_t data_size);
// dest >> src
uint32_t alu_shr(uint32_t src, uint32_t dest, size_t data_size);
uint32_t alu_sar(uint32_t src, uint32_t dest, size_t data_size);
uint32_t alu_sal(uint32_t src, uint32_t dest, size_t data_size);

// dest * src
uint64_t alu_mul(uint32_t src, uint32_t dest, size_t data_size);
int64_t alu_imul(int32_t src, int32_t dest, size_t data_size);
// dest / src
uint32_t alu_div(uint64_t src, uint64_t dest, size_t data_size);
int32_t alu_idiv(int64_t src, int64_t dest, size_t data_size);
// dest % src
uint32_t alu_mod(uint64_t src, uint64_t dest);
int32_t alu_imod(int64_t src, int64_t dest);

// eflags
void set_PF(uint32_t result);
void set_ZF(uint32_t result, size_t data_size);
void set_SF(uint32_t result, size_t data_size);
// add
void set_CF_add(uint32_t result, uint32_t dest, size_t data_size);
void set_OF_add(uint32_t result, uint32_t src, uint32_t dest, size_t data_size);
// adc
void set_CF_adc(uint32_t result, uint32_t dest, bool cf, size_t data_size);
void set_OF_adc(uint32_t result, uint32_t src, uint32_t dest, size_t data_size);
// sub
void set_CF_sub(uint32_t result, uint32_t dest, size_t data_size);
void set_OF_sub(uint32_t result, uint32_t src, uint32_t dest, size_t data_size);
// sbb
void set_CF_sbb(uint32_t result, uint32_t dest, bool cf, size_t data_size);
void set_OF_sbb(uint32_t result, uint32_t src, uint32_t dest, size_t data_size);
// shl
void set_CF_shl(uint32_t dest, uint32_t src, size_t data_size);
// shr
void set_CF_shr(uint32_t dest, uint32_t src, size_t data_size);
// sar
void set_CF_sar(uint32_t dest, uint32_t src, size_t data_size);
// mul
void set_eflags_mul(uint64_t res, size_t data_size);

// sign extend
#define sign(x) ((uint32_t)(x) >> 31)
//#define sign_ext(x) ((int32_t)((int8_t)(x)))

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

inline uint64_t sign_ext_64(uint32_t x, size_t data_size) {
    assert(data_size == 16 || data_size == 8 || data_size == 32);
    switch (data_size) {
    case 8:
        return (int64_t)((int8_t)(x & 0xff));
    case 16:
        return (int64_t)((int16_t)(x & 0xffff));
    default:
        return (int64_t)((int32_t)x);
    }
}

#endif
