#include <stdlib.h>
#include <time.h>
#include "memory/mmu/cache.h"
#include "memory/memory.h"

// global variables
Cacheline cache[1024];

// init the cache
void init_cache() {
    for (int i = 0; i < 1024; i++)
        cache[i].valid_bit = 0;
}

// write data to cache
void cache_write(paddr_t paddr, size_t len, uint32_t data) {
    memcpy(hw_mem + paddr, &data, len); // write to main memory
    uint32_t tag = (paddr >> 13) & 0x7ffff;
    uint8_t index = (paddr >> 6) & 0x7f;
    uint8_t offset = paddr & 0x3f;

    for (int i = 0; i < 8; i++) {
        uint32_t current = index * 8 + i;
        if (cache[current].tag == tag && cache[current].valid_bit == 1) {
            // HIT: write to cache
            if (offset + len <= 64) {
                memcpy(cache[current].data + offset, &data, len);
            } else {
                cache_write(paddr, 64 - offset, data); // write after
                // new_offset = 64 - offset = 0, write in head
                cache_write(paddr + 64 - offset, offset, data >> 8 * (64 - offset));
            }
            break;
        }
    }
    // MISS: Do nothing
}

// read data from cache
uint32_t cache_read(paddr_t paddr, size_t len) {
    uint32_t ret = 0;
    uint32_t tag = (paddr >> 13) & 0x7ffff;
    uint8_t index = (paddr >> 6) & 0x7f;
    uint8_t offset = paddr & 0x3f;

    for (int i = 0; i < 8; i++) {
        uint32_t current = index * 8 + i;
        // HIT: read to cache
        if (cache[current].tag == tag && cache[current].valid_bit == 1) {
            if (offset + len <= 64) {
                memcpy(&ret, cache[current].data + offset, len);
            } else {
                uint32_t temp1 = 0, temp2 = 0;
                memcpy(&temp1, cache[current].data + offset, 64 - offset);
                // new_len = offset + len - 64 => new_len+offset <= 64
                temp2 = cache_read(paddr + 64 - offset, offset + len - 64)
                    << 8 * (64 - offset); // to kill the head, offset bits left
                ret = temp1 | temp2;
            }
            return ret;
        }
    }

    // MISS: send block to cache
    memcpy(&ret, hw_mem + paddr, len);
    int i, current;
    for (i = 0; i < 8; i++) {
        current = index * 8 + i;
        if (cache[current].valid_bit == 0) {
            // empty line
            cache[current].tag = tag;
            cache[current].valid_bit = 1;
            memcpy(cache[current].data, hw_mem + paddr - offset, 64);
            break;
        }
    }
    // no empty line
    if (i == 8) {
        srand((unsigned)time(0));
        i = rand() % 8;
        current = index * 8 + i;
        cache[current].tag = tag;
        cache[current].valid_bit = 1;
        memcpy(cache[current].data, hw_mem + paddr - offset, 64);
    }

    return ret;
}
