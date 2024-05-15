#include <stdint.h>
#include "base.h"

#define START_ADDR  ((uint32_t *)0x50000000)
#define COUNT       ((uint32_t *)0x50258000)
#define GRAY_COUNT  ((uint8_t *)0x50096000)

// Function to convert 32-bit RGB to 8-bit
// shift 5 bit each version
void convert_gray(void) {

    uint32_t *src = START_ADDR;
    uint32_t *end = COUNT;
    uint8_t *dst = (uint8_t *)START_ADDR;

    while (src < end) {
        uint32_t pixel = *src++;
		// Remain 8bit(by shift), bit clear-> 6bits each (by AND)
        uint8_t r = (pixel >> 24) & 0x3F; 
        uint8_t g = (pixel >> 16) & 0x3F; 
        uint8_t b = (pixel >> 8) & 0x3F; 

        uint8_t gray = r + g + b;

        *dst++ = gray; // Store the 8-bit
    }
}

// Function to convert grayscale to binary
void convert_binary(void) {
    uint8_t *src = (uint8_t *)START_ADDR;
    uint8_t *dst = (uint8_t *)START_ADDR;
    uint8_t *end = GRAY_COUNT;
	
	// (Read 1 byte -> write shifted 1bit)*8 = Read 8 bytes -> Write 1 bytes
    while (src < end) {
        uint8_t binary_value = 0;
        for (int i = 0; i < 8; i++) {
            // if (src >= end) break;
            uint8_t gray_value = *src++;
            uint8_t bit = (gray_value > 127) ? 1 : 0;
            binary_value |= (bit << i);
        }
        *dst++ = binary_value;
    }
}

int main() {
    convert_gray(); // Convert RGB to grayscale then,
    convert_binary(); // Convert grayscale to binary
		_sys_exit(0);
}