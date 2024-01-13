; multi-segment executable file template.

data segment
    ; add your data here!
    STRING      DB 100
                DB 101 DUP("$")
    MESSAGE1    DB  "Enter your text here:$"
    MESSAGE2    DB  "Press 1 to transfer your string to upperclass.$"
    MESSAGE3    DB  "Press 2 to transfer your string to lowerclass.$"
    MESSAGE4    DB  "Press 3 to exit.$"
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
RESTART:   
    CALL    WELCOME
    CALL    GET_KEY
    ;CALL    DSP_STRING
    CALL    NLINE
    JMP     RESTART
EXITP:    
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

DSP_STRING PROC
    PUSH    AX
    PUSH    DX
    PUSH    SI
    MOV     SI, OFFSET STRING
    ADD     SI, 2
    MOV     DX, SI
    mov     ah, 09H
    int     21h
    CALL    NLINE
    POP     SI
    POP     DX
    POP     AX
    RET
DSP_STRING ENDP

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
    MOV     DL, OFFSET MESSAGE2
    MOV     AH, 09H
    INT     21H
    CALL    NLINE            
    MOV     DL, OFFSET MESSAGE3
    MOV     AH, 09H
    INT     21H
    CALL    NLINE
    MOV     DL, OFFSET MESSAGE4
    MOV     AH, 09H
    INT     21H
    CALL    NLINE
    POP     AX
    POP     DX     
    RET
WELCOME ENDP    

GET_KEY PROC 
        PUSH    AX
    GET_FKEY:
        MOV     AH, 00H
        INT     16H
        CMP     AH, 2H
        JE      OP1
        CMP     AH, 3H
        JE      OP2
        CMP     AH, 4H
        JE      OP3
        JMP     FINISH
    OP1:
        CALL    TOUPPERCLASS
        JMP     FINISH
    OP2:
        CALL    TOLOWERCLASS
        JMP     FINISH    
    OP3:
        JMP     EXITP       
    ;ERROR:
       ; MOV     DX, OFFSET ERR
    FINISH:
        ;MOV     AH, 09H
        ;INT     21H
        POP     AX
        RET
GET_KEY ENDP    

TOLOWERCLASS PROC
    PUSH    SI
    PUSH    AX
    MOV     SI, OFFSET STRING
BEGIN1:              
    CMP     BYTE PTR[SI], 13
    JE      DONE1
    CMP     BYTE PTR[SI], 'A'   ;recognize UPPERclass char
    JB      NEXT1
    CMP     BYTE PTR[SI], 'Z'
    JA      NEXT1
    MOV     AL,     BYTE PTR[SI]
    ADD     AL,     32
    MOV     [SI],   AL
NEXT1:
    INC     SI
    JMP     BEGIN1
DONE1:
    CALL    DSP_STRING
    POP     AX
    POP     SI
    RET
TOLOWERCLASS ENDP


TOUPPERCLASS PROC
    PUSH    SI
    PUSH    AX
    MOV     SI, OFFSET STRING
BEGIN:              
    CMP     BYTE PTR[SI], 13
    JE      DONE
    CMP     BYTE PTR[SI], 'a'   ;recognize lowerclass char
    JB      NEXT
    CMP     BYTE PTR[SI], 'z'
    JA      NEXT
    MOV     AL,     BYTE PTR[SI]
    SUB     AL,     32
    MOV     [SI],   AL
NEXT:
    INC     SI
    JMP     BEGIN
DONE: 
    CALL    DSP_STRING
    POP     AX
    POP     SI
    RET
TOUPPERCLASS ENDP
end start ; set entry point and stop the assembler.
