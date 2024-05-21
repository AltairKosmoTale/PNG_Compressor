	AREA CONVERT, CODE, READONLY
	
	EXPORT CONVERT_BINARY2

CONVERT_BINARY2

	PUSH		{LR}		
	 
	LDR     R1, start_addr  
	LDR     R2, start_addr
	LDR     R3, count     

; we can use 2 algorithms here to make gray_convert_loop
; 1. average; G=(R+G=B)/3
; 2. min_max; G=max(R,G,B)+min(R,G,B)

gray_convert_loop
	CMP     R3, R2        
	BEQ     end_gray_convert   

	; 32bit R, G, B 
	LDR     R0, [R2], #4  
	MOV     R4, R0, LSR #24
	MOV     R5, R0, LSR #16 
	MOV     R6, R0, LSR #8   
	
	AND R4, R4, #255	;0b11111111	
	AND R5, R5, #255	;0b11111111
	AND R6, R6, #255 	;0b11111111
	
	ADD         R7, R4, R5       ; R + G
	ADD         R7, R7, R6       ; R + G + B
	
    MOV     R8, R7
    ADD     R8, R8, #1            ; R8 = R7 + 1 (rounding up)
    LSR     R8, R8, #2            ; R8 = R8 / 4
    ADD     R8, R8, R7, LSR #2    ; R8 = R8 + (R7 / 4)
    LSR     R8, R8, #1            ; R8 = R8 / 2 (approximates R7 / 3)
	STRB    R8, [R1], #1  

	B      gray_convert_loop   

end_gray_convert	    
	LDR         R0, start_addr  
	LDR         R1, gray_count
    LDR         R2, start_addr


binary_convert_loop
    CMP R0, R1           
    BEQ end_convert   

    MOV R3, #0          
    MOV R4, #0           

bit_loop
    LDRB R5, [R0], #1    
    CMP R5, #127        
    MOVGT R6, #1        
    MOVLE R6, #0         
    ORR R3, R3, R6, LSL R4 
    ADD R4, R4, #1        
    CMP R4, #8            
    BNE bit_loop           

    STRB R3, [R2], #1   
	
	B          binary_convert_loop
	
end_convert
    POP         {PC}        

start_addr  DCD     0x50000000
gray_count	DCD		0x50096000
count       DCD     0x50258000

	END