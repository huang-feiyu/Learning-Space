#include "cpu/cpu.h"
#include "memory/memory.h"

// translate from linear address to physical address
paddr_t page_translate(laddr_t laddr) {
#ifndef TLB_ENABLED
    uint32_t dir = (laddr >> 22) & 0x3ff;
    uint32_t page = (laddr >> 12) & 0x3ff;
    uint32_t offset = laddr & 0xfff;
    // hw_mem[cr3.pdbr + dir*4]
    PDE *pdir = (PDE *)(hw_mem + (cpu.cr3.pdbr << 12) + (dir << 2));
    // hw_mem[pdir->page_frame + page*4]
    PTE *ptable = (PTE *)(hw_mem + (pdir->page_frame << 12) + (page << 2));
    assert(pdir->present);
    assert(ptable->present);
    return (ptable->page_frame << 12) + offset;
#else
    return tlb_read(laddr) | (laddr & PAGE_MASK);
#endif
}
