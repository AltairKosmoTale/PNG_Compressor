	AREA CONVERT, CODE, READONLY
	
	EXPORT CONVERT_8BIT

CONVERT_8BIT

	PUSH		{LR}		
	 
	LDR     R1, start_addr  
	LDR     R2, start_addr
	LDR     R3, count     

convert_loop
	CMP     R3, R2        
	BEQ     end_convert   

	; 32bit R, G, B  
	LDR     R0, [R2], #4  
	
	; for example R0 = 0F100AFF
	MOV     R4, R0, LSR #24 ;0F 
	MOV     R5, R0, LSR #16 ;0F10  
	MOV     R6, R0, LSR #8 ;0F100A 

	; version 2 = shift 4 bit each to get mid
	; #5: R[7:5], #4:R[6:4]
	LSR R4, R4, #5 
	LSR R5, R5, #5 
	LSR R6, R6, #5 

	AND R4, R4, #7	;0b111	
	AND R5, R5, #7	;0b111	
	AND R6, R6, #3 	;0b11
	
	LSL R4, R4, #5 ; 11100000      
	LSL R5, R5, #2 ; 00011100      
	ORR R7, R4, R5 ; 00000011    
	ORR R7, R7, R6 ; 11111111

	STRB    R7, [R1], #1   

	B       convert_loop   

end_convert
	POP     {PC}          

start_addr  DCD     0x50000000
count       DCD     0x50258000 

	END