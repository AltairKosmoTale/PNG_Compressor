#include <stdint.h>
#include "base.h"

// address: where image start
#define START_ADDR  ((uint32_t *)0x50000000)
// address: where image end
#define COUNT       ((uint32_t *)0x50258000)

// Function to convert 32-bit RGB to 8-bit
// shift 5 bit each version
void convert_gray(void) {

    uint32_t *src = START_ADDR;
    uint32_t *end = COUNT;
    uint8_t *dst = (uint8_t *)START_ADDR;

    while (src < end) {
        uint32_t pixel = *src++;
		// Remain 8bit(by shift), bit clear-> 6bits each (by AND)
        uint8_t r = (pixel >> 24) & 0xFF; 
        uint8_t g = (pixel >> 16) & 0xFF; 
        uint8_t b = (pixel >> 8) & 0xFF; 

        uint8_t gray = (r + g + b)/3; // Sum the RGB components to get the grayscale value

        *dst++ = gray; // Store the 8-bit
    }
}

int main() {
    convert_gray();
    _sys_exit(0);
}