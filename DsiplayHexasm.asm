; multi-segment executable file template.
data segment
    NUM DW 5050  
ends

stack segment
ends

code segment
ASSUME  DS:DATA,SS: CODE,CS: CODE
start:
    MOV AX, DATA
    MOV DS, AX
     
    MOV BX, NUM
    MOV CH, 4
ROTATE:    
    ROL BX, 4
    MOV AL, BL
    AND AL, 0FH
    ADD AL, '0'
    CMP AL, 39H
    JBE PRINT
    ADD AL, 07H
PRINT:
    MOV DL, AL
    MOV AH, 02H
    INT 21H
    DEC CH
    JNE ROTATE ;FINISH PRINT

    MOV AX,4C00H
    INT 21H  
ends

end start ; set entry point and stop the assembler.
