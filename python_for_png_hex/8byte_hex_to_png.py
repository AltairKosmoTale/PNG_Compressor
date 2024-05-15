from PIL import Image
from intelhex import IntelHex
    
def intel_hex_to_png(hex_filepath, png_filepath, width, height):
    # open Intel Hex
    ih = IntelHex(hex_filepath)
    
    # get RGBA Data
    rgba_data = bytearray()
    for address in range(ih.minaddr(), ih.maxaddr() + 1):
        byte_value = ih[address]
        r = ((byte_value >> 5) & 0b111) << 5  # Shift left by 5 to expand to 8 bits
        g = ((byte_value >> 2) & 0b111) << 5  # Shift left by 5 to expand to 8 bits
        b = (byte_value & 0b11) << 6  # Shift left by 6 to expand to 8 bits
        # Extend the RGBA data array with expanded RGB values and maximum alpha value
        rgba_data.extend([r, g, b, 255])
    
    img = Image.frombytes('RGBA', (width, height), bytes(rgba_data))
    
    # store as PNG 
    img.save(png_filepath)
    print(f"PNG file '{png_filepath}' has been created.")

intel_hex_to_png('8byte.hex', '8byte_output.png', width=960, height=640)


