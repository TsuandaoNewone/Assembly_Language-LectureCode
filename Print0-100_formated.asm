; multi-segment executable file template.

data segment
    SeparatorMsg    DB '  $'       ; TAB和空格
    newline         db 13, 10, "$"
    SPACE           DB " $"
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here
    MOV     CL, 0         ; 循环次数，输出0到100共101个数
    MOV     CH, 10  
PRINTLOOP:    
    MOV     AL, CL
    INC     CL
    MOV     AH, 0
    CALL    DisplayNumber
    
    MOV     AX, 0
    MOV     AL, CL
    DIV     CH
    CMP     AH, 0
    JNE     NEXT1
    CALL    NLINE
NEXT1:   
    CMP     CL, 101
    JB     PRINTLOOP
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends
;NUMBER IN AL
DisplayNumber PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH AX
    MOV     CL, 10          ; CX用于除以10   
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
    MOV     AH, 09H
    MOV     DX, OFFSET SeparatorMsg
    INT     21H 
    
    POP     AX
    CMP     AL, 10
    JAE      JMPSPACE
    MOV     DX, OFFSET SPACE    ;match column
    MOV     AH, 09H
    INT     21H
JMPSPACE:            
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DisplayNumber ENDP

SEPARATOR PROC
    PUSH    AX
    PUSH    DX
    MOV     AH, 09H
    LEA     DX, SeparatorMsg
    INT     21H 
    POP     DX
    POP     AX
    RET
SEPARATOR ENDP

NLINE PROC
    PUSH    AX
    PUSH    DX
    MOV     DL, OFFSET NEWLINE
    MOV     AH, 09H
    INT     21H
    POP     DX
    POP     AX
    RET    
NLINE ENDP  
end start ; set entry point and stop the assembler.
