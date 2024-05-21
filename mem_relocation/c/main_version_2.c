#include "base.h"
#include <stdint.h>

// Memory addresses as specified
#define START_ADDR     ((uint8_t *)0x50000000)
#define COUNT_ADDR     ((uint8_t *)0x50258000)
#define START_ADDR_R   ((uint8_t *)0x60000000)
#define START_ADDR_G   ((uint8_t *)0x60096000)
#define START_ADDR_B   ((uint8_t *)0x6012c000)

void VERSION_2(void) {
    uint8_t *read_ptr = START_ADDR;
    uint8_t *write_ptr_r = START_ADDR_R;
    uint8_t *write_ptr_g = START_ADDR_G;
    uint8_t *write_ptr_b = START_ADDR_B;
    uint8_t *count_ptr = COUNT_ADDR;

    while (read_ptr < count_ptr) {
        // Read R, G, B and skip A
        *write_ptr_r++ = *read_ptr++; // R
        *write_ptr_g++ = *read_ptr++; // G
        *write_ptr_b++ = *read_ptr++; // B
        read_ptr++;  // Skip A
    }
}

int main(void) {
    VERSION_2();
    _sys_exit(0); // Assuming _sys_exit is defined elsewhere
}