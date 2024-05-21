	; Gray scale with average; G=(R+G+B)/3
	
	AREA CONVERT, CODE, READONLY
	
	EXPORT CONVERT_GRAY2

CONVERT_GRAY2

	PUSH		{LR}		
	 
	LDR     R1, start_addr  
	LDR     R2, start_addr
	LDR     R3, count     

convert_loop
	CMP     R3, R2        
	BEQ     end_convert   

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
	
	; Divide by 3 approximation: (R7 * 0x55) >> 8
	;MOV         R8, R7, LSR #1   ; R7 / 2
	;ADD         R8, R8, R7       ; R7 + (R7 / 2) = (3 * R7) / 2
	;MOV         R7, R8, LSR #1   ; (3 * R7) / 4, approximate division by 3

	;STRB    R7, [R1], #1   
	
    MOV     R8, R7
    ADD     R8, R8, #1            ; R8 = R7 + 1 (rounding up)
    LSR     R8, R8, #2            ; R8 = R8 / 4
    ADD     R8, R8, R7, LSR #2    ; R8 = R8 + (R7 / 4)
    LSR     R8, R8, #1            ; R8 = R8 / 2 (approximates R7 / 3)
	STRB    R8, [R1], #1  

	B       convert_loop   

end_convert
	POP     {PC}          

start_addr  DCD     0x50000000
count       DCD     0x50258000 

	END