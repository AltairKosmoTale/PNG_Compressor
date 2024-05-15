from PIL import Image
from intelhex import IntelHex

def hex_to_png(hex_filepath, png_filepath, width, height):
    ih = IntelHex(hex_filepath)
    
    binary_data = bytearray()
    for address in range(ih.minaddr(), ih.maxaddr() + 1):
        byte_value = ih[address]
        # if each bit == 0 -> white // else -> black
        for i in range(8):
            if byte_value & (1 << i):  
                binary_data.extend([255, 255, 255, 255]) # black
            else:
                binary_data.extend([0, 0, 0, 255]) #white
                
    img = Image.frombytes('RGBA', (width, height), bytes(binary_data))
    
    img.save(png_filepath)
    print(f"PNG file '{png_filepath}' has been created.")
    
def hex_to_png2(hex_filepath, png_filepath, width, height):
    ih = IntelHex(hex_filepath)
    
    binary_data = bytearray()
    for address in range(ih.minaddr(), ih.maxaddr() + 1):
        byte_value = ih[address]
        # if each bit == 0 -> white // else -> black
        for i in range(8):
            if byte_value & (1 << i):  
                binary_data.append(255)  # black
            else:
                binary_data.append(0)  # white
    
    img = Image.frombytes('L', (width, height), bytes(binary_data))
    
    img.save(png_filepath)
    print(f"PNG file '{png_filepath}' has been created.")

# hex_to_png: fill all RGB as same value
# hex_to_png2: use library gray_scale mode
# version2 output is slightly smaller than version1 output 
hex_to_png('binary.hex', 'binary_output.png', width=960, height=640)  
hex_to_png2('binary.hex', 'binary_output2.png', width=960, height=640) 
