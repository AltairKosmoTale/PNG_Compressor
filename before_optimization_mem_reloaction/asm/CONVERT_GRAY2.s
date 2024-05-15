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

	; there are various options for here
	; 1. shift 2 bit Right -> add 64 bit each; max = 64*3 = 192/255 (what we used here)
	; 2. shift 1 bit Right -> add 127 bit each ; max = 127*3 = 381/255 (overflow)
	; 3. shift 2 bit Right -> add 64 bit each -> shift 1 bit Left ; max = 192*2 = 384/255 (overflow)
	; etc ... we are in test
	
	AND R4, R4, #63	;0b00111111	
	AND R5, R5, #63	;0b00111111
	AND R6, R6, #63 ;0b00111111  
	
	ADD         R7, R4, R5       ; R + G
	ADD         R7, R7, R6       ; R + G + B
	

	STRB    R7, [R1], #1   

	B       convert_loop   

end_convert
	POP     {PC}          

start_addr  DCD     0x50000000
count       DCD     0x50258000 

	END