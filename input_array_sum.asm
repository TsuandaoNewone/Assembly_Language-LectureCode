; multi-segment executable file template.

data segment
    ; add your data here!
    Msg       DB "Enter a number(no exceed 100): $"
    RESULTMSG DB "The sum is:$"
    CUE       DB "ENTER NUMBER:$"
    ERRORMSG     DB "N out of bound"
    InputMsg  DB 6 DUP('$') ; ���ڴ洢����������ַ���
    Number    DW ?           ; ���ڴ洢ת���������
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
    ; ��ȡ�û�����������ַ���
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
        MOV     SI, OFFSET InputMsg+2 ; �������뻺�����ĳ����ֽ�
        XOR     AX, AX           ; �����ۻ�����
        MOV     CL, 10           ; ��������ʾʮ����
        MOV     DH, 0
    ConvertLoop:
        MOV     DL, [SI]         ; ���ַ�����ȡһ���ַ�
        CMP     DL, 13          ; �ж��Ƿ��ַ�����β CRET
        JE      ConvertDone
    
        SUB     DL, '0'           ; ��ASCII�ַ�ת��Ϊ����
        MUL     CL               ; AX = AX * 10
        ADD     AX, DX           ; AX = AX + DL
        INC     SI               ; ָ����һ���ַ�
        JMP     ConvertLoop
    ConvertDone:
        MOV     Number, AX       ; ������洢�� Number ����
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
    MOV     CL, 10          ; CX���ڳ���10   
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
