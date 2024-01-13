; multi-segment executable file template.

data segment
    ; add your data here!
    Msg         DB "Enter binary number:(up to 8digit, dollar sign to quit) $"
    DECMSG      DB "The decimal is:$"
    HEXMSG      DB "    The heximal is:$"
    BINMSG      DB "    The binary is:$"
    COLON       DB ": $"
    EXIT        DB "EXIT"
    InputMsg    DB 16
                DB 17 DUP('$') ; 用于存储输入的数字字符串
    NEWLINE     DB 13, 10, "$" ;
ends

stack segment
    dw   128  dup(0)
ends
code segment
start:
; set segment registers:
    mov     ax, data
    mov     ds, ax
    mov     es, ax
RESTART:
    CALL    WELCOME
    CALL    GETCHAR
    CALL    NLINE
    MOV     SI, OFFSET INPUTMSG + 2  
    MOV     AL, [SI]
    CMP     AL, 13;CRET
    JE      DONE
    CMP     AL, '$'
    JE      QUIT
    CALL    GETNUMBER
    CALL    CONVERTTODEC
    CALL    CONVERTTOHEX
    ;CALL    CONVERTTOBIN
DONE:
    CALL    NLINE
    JMP     RESTART
QUIT:
    MOV     DL, OFFSET EXIT
    MOV     AH, 09H
    INT     21H    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends 

GETNUMBER PROC
        PUSH    SI
        ;PUSH    AX
        PUSH    BX
        MOV     AL, 0
        MOV     SI, OFFSET INPUTMSG + 2
    NEXTBIT:
        MOV     BL, [SI]
        CMP     BL, 13
        JE      DONEGET
        SUB     BL, '0'
        SHL     AL, 1
        ADD     AL, BL
        INC     SI
        JMP     NEXTBIT
    DONEGET:
        POP     BX
        ;POP     AX
        POP     SI        
        RET
GETNUMBER ENDP    

DSP_CHAR PROC
    PUSH    DX
    PUSH    AX
    MOV     DL, AL   
    MOV     AH, 02H
    INT     21H
    
    MOV     DX, OFFSET COLON
    MOV     AH, 09H
    INT     21H 
    POP     AX
    POP     DX
    RET
DSP_CHAR ENDP

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

WELCOME PROC
    PUSH    AX
    PUSH    DX
    MOV     AH, 09H
    LEA     DX, Msg
    INT     21H
    CALL    NLINE
    POP     DX
    POP     AX
    RET 
WELCOME ENDP

GETCHAR PROC
    PUSH    AX
    PUSH    DX
    MOV     AH, 0AH
    LEA     DX, InputMsg
    INT     21H
    CALL    NLINE
    POP     DX
    POP     AX
    RET
GETCHAR ENDP

CONVERTTOBIN PROC
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        
        PUSH    AX
        MOV     DX, OFFSET BINMSG
        MOV     AH, 09H
        INT     21H
        POP     AX
          
        MOV     BL, AL
        MOV     CX, 8 
    ROTATE1:
        ROL     BL, 1
        MOV     AL, BL
        AND     AL, 01H
        CMP     AL, 0
        JE      PRINT0
    PRINT1:        
        MOV     DL, 49
        MOV     AH, 02H
        INT     21H
        JMP     L
    PRINT0:        
        MOV     DL, 48
        MOV     AH, 02H
        INT     21H
    L:
        LOOP    ROTATE1
        CALL    NLINE
        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
CONVERTTOBIN ENDP    

;CONVERT NUM IN AL TO HEX
CONVERTTOHEX PROC
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    AX
        MOV     DX, OFFSET HEXMSG
        MOV     AH, 09H
        INT     21H
        POP     AX 
        
        MOV     BL, AL
        MOV     CH, 2
    ROTATE:    
        ROL     BL, 4
        MOV     AL, BL
        AND     AL, 0FH
        ADD     AL, '0'
        CMP     AL, 39H
        JBE     PRINT
        ADD     AL, 07H
    PRINT:
        MOV     DL, AL
        MOV     AH, 02H
        INT     21H
        DEC     CH
        JNE     ROTATE
        POP     DX
        POP     CX
        POP     BX
        POP     AX 
        RET
CONVERTTOHEX ENDP

;DISPLAY THE NUMBER IN AL IN DECIMAL
CONVERTTODEC PROC  
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
        PUSH    AX
        MOV     DX, OFFSET DECMSG
        MOV     AH, 09H
        INT     21H
        POP     AX
        MOV     CL, 10          ; CX用于除以10   
        MOV     CH, 0
        MOV     AH, 0   
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
        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
CONVERTTODEC ENDP

end start ; set entry point and stop the assembler.
