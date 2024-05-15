	; Gray scale with min_max; G = max(R+G+B) + min(R,G,B)
	
	AREA CONVERT, CODE, READONLY
	
	EXPORT CONVERT_GRAY

CONVERT_GRAY

    PUSH        {LR}        

    LDR         R1, start_addr  
    LDR         R2, start_addr
    LDR         R3, count     

convert_loop
    CMP         R3, R2        
    BEQ         end_convert   

    ; Load RGB pixel
    LDR         R4, [R2], #4  

    ; Extract R, G, B components
    MOV         R5, R4, LSR #24  ; R
    MOV         R6, R4, LSR #16  ; G
    MOV         R7, R4, LSR #8   ; B

    ; Find max(R, G, B)
    CMP         R5, R6
    MOVLT       R5, R6
    CMP         R5, R7
    MOVLT       R5, R7

    ; Find min(R, G, B)
    CMP         R6, R7
    MOVGT       R6, R7
    CMP         R5, R6
    MOVGT       R6, R5

    ; Calculate grayscale value
    ADD         R6, R6, R5, LSR #1  ; (max(R, G, B) + min(R, G, B)) / 2

    ; Store grayscale value
    STRB        R6, [R1], #1   

    B           convert_loop   

end_convert
    POP         {PC}        

start_addr  DCD     0x50000000
count       DCD     0x50258000 

	END