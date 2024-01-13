; multi-segment executable file template.

data segment
    ; add your data here!
    upperNum    DB  0
    lowerNum    DB  0
    digiNum     DB  0
    spaNum      DB  0
    othNum      DB  0
    STRING      DB 100
                DB 101 DUP("$")
    MESSAGE1    DB  "Enter your text here:$"
    MESSAGE2    DB  "Number of upperclass char:$"
    MESSAGE3    DB  "Number of lowerclass char:$"
    MESSAGE4    DB  "Number of digital char:$"
    MESSAGE5    DB  "Number of space char:$"
    MESSAGE6    DB  "Number of other char:$"
    
    NEWLINE     DB  13, 10, "$" ; Carriage Return (13) and Line Feed (10)           
ends

stack segment
    dw   128  dup(0)
ends

code segment
START:
; set segment registers:
    mov     ax, data
    mov     ds, ax
    mov     es, ax
RESTRAT:      
    CALL    WELCOME
    CALL    STRINGLOOP
    CALL    NLINE
    CALL    RESULT
    CALL    NLINE
    JMP     RESTRAT:
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends
;Transfer the variable STRING to upperclass
NLINE PROC
    PUSH    AX
    PUSH    DX
    MOV     DX, OFFSET NEWLINE
    MOV     AH, 09H
    INT     21H
    POP     DX
    POP     AX
    RET    
NLINE ENDP  

RESULT PROC
    PUSH    AX
    PUSH    DX  
    MOV     DX, OFFSET MESSAGE2
    MOV     AH, 09H
    INT     21H
    MOV     AH, 0
    MOV     AL, UPPERNUM
    CALL    DISPLAYNUMBER
    CALL    NLINE
    MOV     DX, OFFSET MESSAGE3
    MOV     AH, 09H
    INT     21H
    MOV     AH, 0
    MOV     AL, LOWERNUM
    CALL    DISPLAYNUMBER
    CALL    NLINE
    MOV     DX, OFFSET MESSAGE4
    MOV     AH, 09H
    INT     21H
    MOV     AH, 0
    MOV     AL, DIGINUM
    CALL    DISPLAYNUMBER
    CALL    NLINE
    MOV     DX, OFFSET MESSAGE5
    MOV     AH, 09H
    INT     21H
    MOV     AH, 0
    MOV     AL, SPANUM
    CALL    DISPLAYNUMBER
    CALL    NLINE
    MOV     DX, OFFSET MESSAGE6
    MOV     AH, 09H
    INT     21H
    MOV     AH, 0
    MOV     AL, OTHNUM
    CALL    DISPLAYNUMBER
    CALL    NLINE
    POP     DX
    POP     AX
    RET
RESULT ENDP   

WELCOME PROC
    PUSH    DX
    PUSH    AX
    MOV     DL, OFFSET MESSAGE1
    MOV     AH, 09H
    INT     21H
    CALL    NLINE
    MOV     DX, OFFSET  STRING
    MOV     AH, 0AH
    INT     21H
    CALL    NLINE
    POP     AX
    POP     DX     
    RET
WELCOME ENDP    

 

STRINGLOOP PROC
        PUSH    SI
        PUSH    AX
        PUSH    BX
        PUSH    CX
        MOV     AX, 0
        MOV     BX, 0
        MOV     CX, 0
        MOV     SI, OFFSET STRING +2
    BEGIN1:         
        CMP     BYTE PTR[SI], 13 ;CRET
        JE      DONE1
        CMP     BYTE PTR[SI], ' '
        JE      SPACE
        CMP     BYTE PTR[SI], '0'   ;recognize DIGIT char
        JB      OTHER
        CMP     BYTE PTR[SI], '9'
        JBE     DIGIT
        CMP     BYTE PTR[SI], 'A'
        JB      OTHER
        CMP     BYTE PTR[SI], 'Z'
        JBE     UPPER
        CMP     BYTE PTR[SI], 'a'
        JB      OTHER           
        CMP     BYTE PTR[SI], 'z'
        JBE     LOWER
        JMP     OTHER
    UPPER:
        INC     AH 
        INC     SI
        JMP     BEGIN1
    LOWER:
        INC     AL
        INC     SI
        JMP     BEGIN1
    DIGIT:
        INC     BH
        INC     SI
        JMP     BEGIN1
    SPACE:
        INC     BL
        INC     SI
        JMP     BEGIN1
    OTHER:
        INC     CH
        INC     SI
        JMP     BEGIN1       
    DONE1:
        MOV     UPPERNUM, AH
        MOV     LOWERNUM, AL
        MOV     DIGINUM, BH
        MOV     SPANUM, BL
        CMP     CH, 0
        JE      JMP NEXT2
        SUB     CH, 1
    NEXT2:    
        MOV     OTHNUM, CH     
        POP     CX
        POP     BX
        POP     AX
        POP     SI
        RET
STRINGLOOP ENDP

DisplayNumber PROC
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        MOV     CL, 10          ; CX????10   
        MOV     CH, 0    
    DivideLoop:
        DIV     CL
        MOV     DL, AH
        XOR     DH, DH
        PUSH    DX
        INC     CH
        CMP     AL, 0
        JE      PRINTLOOP1
        MOV     AH, 0
        JMP     DIVIDELOOP
    PRINTLOOP1:
        CMP     CH, 0
        JE      FINISH 
        DEC     CH
        POP     DX
        ADD     DL, '0'
        MOV     AH, 02H
        INT     21H
        JMP     PRINTLOOP1
    FINISH:      
        POP DX
        POP CX
        POP BX
        POP AX
        RET
DisplayNumber ENDP

end start ; set entry point and stop the assembler.
