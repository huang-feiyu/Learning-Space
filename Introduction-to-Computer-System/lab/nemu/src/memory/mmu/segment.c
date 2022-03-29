#include "cpu/cpu.h"
#include "memory/memory.h"

// return the linear address from the virtual address and segment selector
uint32_t segment_translate(uint32_t offset, uint8_t sreg) {
    // perform segment translation from virtual address to linear address
    // by reading the invisible part of the segment register 'sreg'
    assert(sreg >= 0 && sreg <= 5);

    uint32_t linear_addr = cpu.segReg[sreg].base + offset;

    return linear_addr;
}

// load the invisible part of a segment register
void load_sreg(uint8_t sreg) {
    // load the invisibile part of the segment register 'sreg' by reading the GDT
    // The visible part of 'sreg' should be assigned by mov or ljmp already.
    assert(sreg >= 0 && sreg <= 5);

    uint32_t addr = (uint32_t)hw_mem + cpu.gdtr.base + 8 * cpu.segReg[sreg].index;
    SegDesc* segdesc = (void*)addr;

    cpu.segReg[sreg].base = (segdesc->base_31_24 << 24) +
        (segdesc->base_23_16 << 16) + segdesc->base_15_0;
    cpu.segReg[sreg].limit = (segdesc->limit_19_16 << 16) + segdesc->limit_15_0;
    cpu.segReg[sreg].privilege_level = segdesc->privilege_level;

    assert(cpu.segReg[sreg].base == 0);
    assert(cpu.segReg[sreg].limit == 0xfffff);
    assert(segdesc->granularity == 1);
    assert(segdesc->present == 1);
}
