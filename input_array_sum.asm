; multi-segment executable file template.

data segment
    ; add your data here!
    Msg       DB "Enter a number(no exceed 100): $"
    RESULTMSG DB "The sum is:$"
    CUE       DB "ENTER NUMBER:$"
    ERRORMSG     DB "N out of bound"
    InputMsg  DB 6 DUP('$') ; 用于存储输入的数字字符串
    Number    DW ?           ; 用于存储转换后的数字
    NEWLINE   DB  13, 10, "$" ;
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
    CALL    GETNUMBER
    CALL    NLINE
    MOV     CX, NUMBER
    CMP     CX, 100
    JA      ERROR
    MOV     AX, 0  
INPUT:    
    CALL    INPUTCUE
    CALL    GETNUMBER
    MOV     BX, NUMBER
    ADD     AX, BX
    CALL    NLINE
    LOOP    INPUT
    CALL    RESULT
    JMP     END       
ERROR:
    MOV     DX, OFFSET ERRORMSG
    MOV     AH, 09H
    INT     21H
END:
    CALL    NLINE
    JMP     RESTART
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends
RESULT PROC
    PUSH    AX
    PUSH    DX
    MOV     DX, OFFSET RESULTMSG
    PUSH    AX
    MOV     AH, 09H
    INT     21H
    POP     AX
    CALL    DISPLAYNUMBER
    POP     DX
    POP     AX
    RET
RESULT ENDP    
INPUTCUE PROC
    PUSH    AX
    PUSH    DX
    MOV     DX, OFFSET CUE
    MOV     AH, 09H
    INT     21H
    POP     DX
    POP     AX
    RET
INPUTCUE ENDP

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
    ; 读取用户输入的数字字符串
    CALL    NLINE
    POP     DX
    POP     AX
    RET 
WELCOME ENDP

GETNUMBER PROC
    PUSH    AX
    PUSH    DX
    MOV     AH, 0AH
    LEA     DX, InputMsg
    INT     21H
    CALL    ConvertToNumber
    POP     DX
    POP     AX
    RET
GETNUMBER ENDP

ConvertToNumber PROC
        PUSH    AX
        PUSH    CX
        PUSH    DX
        PUSH    SI
        MOV     SI, OFFSET InputMsg+2 ; 跳过输入缓冲区的长度字节
        XOR     AX, AX           ; 用于累积数字
        MOV     CL, 10           ; 除数，表示十进制
        MOV     DH, 0
    ConvertLoop:
        MOV     DL, [SI]         ; 从字符串中取一个字符
        CMP     DL, 13          ; 判断是否到字符串结尾 CRET
        JE      ConvertDone
    
        SUB     DL, '0'           ; 将ASCII字符转换为数字
        MUL     CL               ; AX = AX * 10
        ADD     AX, DX           ; AX = AX + DL
        INC     SI               ; 指向下一个字符
        JMP     ConvertLoop
    ConvertDone:
        MOV     Number, AX       ; 将结果存储到 Number 变量
        POP     SI
        POP     DX
        POP     CX
        POP     AX
        RET
ConvertToNumber ENDP

DisplayNumber PROC
    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX
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
    POP     DX
    POP     CX
    POP     BX
    POP     AX
    RET
DisplayNumber ENDP

end start ; set entry point and stop the assembler.
