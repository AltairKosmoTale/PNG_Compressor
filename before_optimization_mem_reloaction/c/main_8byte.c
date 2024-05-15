#include <stdint.h>
#include "base.h"

#define START_ADDR  ((uint32_t *)0x50000000)
#define COUNT       ((uint32_t *)0x50258000)

// Function to convert 32-bit RGB to 8-bit
// shift 5: top value of RGBA (what we used here)
// shift 4: mid value of RGBA (but more better result)
// we are in test...
void convert_8bit(void) {

    uint32_t *src = START_ADDR;
    uint32_t *end = COUNT;
    uint8_t *dst = (uint8_t *)START_ADDR;

    while (src < end) {
        uint32_t pixel = *src++;
			uint8_t r = (pixel >> 27) & 0x07; // to shift 4 bit: 27 -> 28
        uint8_t g = (pixel >> 19) & 0x07; // 19 -> 20
        uint8_t b = (pixel >> 11) & 0x03; // 11 -> 12

        uint8_t result = (r << 5) | (g << 2) | b;
        *dst++ = result;
    }
}

int main() {
    convert_8bit();
		_sys_exit(0);
}