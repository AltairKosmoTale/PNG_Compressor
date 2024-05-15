from intelhex import IntelHex
from PIL import Image

def hex_to_png(hex_filepath, png_filepath, width, height):
    # open Intel HEX
    ih = IntelHex(hex_filepath)
    
    # Get RGBA Data
    rgba_data = bytearray()
    for address in range(ih.minaddr(), ih.maxaddr() + 1):
        byte_value = ih[address]
        # same value for RGB to make Gray, max(255) for A
        rgba_data.extend([byte_value, byte_value, byte_value, 255])        
    
    img = Image.frombytes('RGBA', (width, height), bytes(rgba_data))
    
    img.save(png_filepath)
    print(f"PNG file '{png_filepath}' has been created.")

def hex_to_png2(hex_filepath, png_filepath, width, height):
    ih = IntelHex(hex_filepath)
    
    grayscale_data = bytearray()
    for address in range(ih.minaddr(), ih.maxaddr() + 1):
        byte_value = ih[address]
        grayscale_data.append(byte_value)
    
    # Use Library(gray scale mode)
    img = Image.frombytes('L', (width, height), bytes(grayscale_data))
    
    img.save(png_filepath)
    print(f"PNG file '{png_filepath}' has been created.")

# hex_to_png: fill all RGB as same value
# hex_to_png2: use library gray_scale mode
# version1: output = input*(1/2)
# version2: output = input*(1/4)

hex_to_png('8gray.hex', '8gray_output.png1', width=960, height=640) 
hex_to_png2('8gray.hex', '8gray_output.png2', width=960, height=640)