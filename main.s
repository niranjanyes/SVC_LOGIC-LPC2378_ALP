		AREA  RESET, CODE, READONLY
        EXPORT  __Vectors
__Vectors 
		DCD  0x20001000,Reset_Handler+1,0,0,0,0,0,0,0,0, 0,SVC_handler+1,0,0,0,0,0,0,0,0,0,0,0    

        AREA mycode, CODE, READONLY    
        ENTRY
        EXPORT  Reset_Handler
Reset_Handler
        LDR R1, =0x20000200
        MSR PSP, R1 
    
        MOV R0, #3
        MSR CONTROL, R0
        
        LDR R7, =SRC
        LDR R1, [R7], #4
        LDR R2, [R7]
        LDR R8, =DST
        SVC 42

STOP    B STOP

SVC_handler 
    PUSH {R0-R3, LR}

    TST LR, #4         ;1 = PSP, 0 = MSP
    MRSNE R0, PSP      
    MRSEQ R0, MSP      
    LDR R1, [R0, #24]  
    LDRB R1, [R1, #-2]

    CMP R1, #42        ; SVC Comparison
    BNE SVC_Subtraction 
    ;Addition
    LDR R2, =DST       
    LDR R4, =SRC        
    LDR R5, [R4]          ; First SRC value 
    LDR R6, [R4, #4]     ; Second SRC value

    ADD R3, R5, R6      
    STR R3, [R2]      
    B SVC_Exit       

SVC_Subtraction
    LDR R2, =DST     
    LDR R4, =SRC       
    LDR R5, [R4]        ;first SRC value
    LDR R6, [R4, #4]    ; second SRC value

    SUB R3, R5, R6     
    STR R3, [R2]     

SVC_Exit
    POP {R0-R3, PC}  

SRC     DCD 01542, 01542 
        AREA RES, DATA, READWRITE
DST     DCD 0, 0         
        END