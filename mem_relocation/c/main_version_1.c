#include "base.h"
#include <stdint.h>

#define START_ADDR  ((uint8_t *)0x50000000)
#define COUNT       ((uint8_t *)0x50258000)

void VERSION_1(void) {
    uint8_t *write_ptr = START_ADDR;
    uint8_t *read_ptr = START_ADDR;
    uint8_t *count = COUNT;

    while (read_ptr < count) {
        // RGB sequential 3 byte
        *write_ptr++ = *read_ptr++;
        *write_ptr++ = *read_ptr++;
        *write_ptr++ = *read_ptr++;
        read_ptr++;  // skip A
    }
}

int main (void)
{
	VERSION_1();
	_sys_exit(0);
}