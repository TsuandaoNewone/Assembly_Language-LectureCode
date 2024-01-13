; multi-segment executable file template.

data segment
    ; add your data here!
    STRINGA     DB 100
                DB 101 DUP("$")
    STRINGB     DB 100
                DB 101 DUP("$")
    ;STRINGA     DB "HeStrwoStr,StrStString$$$$$$$$$$$$$$$$"    
    ;STRINGB     DB "Str$$$$$$$$$$$$"
    CUEA        DB "Please enter StrA:$"
    CUEB        DB "Please enter StrB:$"
    STRAMSG     DB "StrA:$"
    STRBMSG     DB "StrB:$"
    SEPARATOR   DB "=========================$"                
    QUEST1      DB  "1: Search StrB in StrA.$"
    QUEST2      DB  "2: Insert StrB in StrA.$"
    QUEST3      DB  "3: Delete StrB from StrA.$"
    QUEST4      DB  "4: Quit.$"
    RESPOND1    DB  "You press button 1.$"
    RESPOND2    DB  "You press button 2.$"
    RESPOND3    DB  "You press button 3.$"
    RESPOND4    DB  "You press button 4.$"
    CUE1        DB  "StrB's location in StrA:$"
    CUE2        DB  "Please input the location to insert:$"
    CUE3        DB  "StrB is deleted from StrA.$"
    CUE4        DB  "program exit$.$"
    COMMA       DB  ", $"
    INSERTPOS   DB  5
                DB  6 DUP("$")
    NUMBERPOS   DW  0
    CNTB        DW  0
    NEWLINE     DB  13, 10, "$" ; Carriage Return ("$") and Line Feed (10)           
ends

stack segment
    dw   1000  dup(0)
ends

code segment
START:
; set segment registers:
    mov     ax, data
    mov     ds, ax
    mov     es, ax 
    CALL    WELCOME
    CALL    INITIAL
RESTART:   
    CALL    MENU
    CALL    GET_KEY
    ;CALL    DSP_STRING
    CALL    NLINE
    JMP     RESTART
EXITP:    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

;***************************************
;FUNCTION:
;PRINT A NEW LINE      
;INPUT PARAMETERS:   
;
;OUTPUT PARAMETERS:
;
;*************************************** 
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
;***************************************
;FUNCTION:
;display string       
;INPUT PARAMETERS:   
;DX
;OUTPUT PARAMETERS:
;
;*************************************** 
DSP_STRING PROC
    PUSH    AX
    PUSH    DX
    PUSH    SI
    ;MOV     SI, OFFSET STRINGA
    ;ADD     SI, 2
    ;MOV     DX, SI
    mov     ah, 09H
    int     21h
    CALL    NLINE
    POP     SI
    POP     DX
    POP     AX
    RET
DSP_STRING ENDP

;***************************************
;FUNCTION:
;delete the former 2 bytes in stringA and stringB       
;INPUT PARAMETERS:   
;
;OUTPUT PARAMETERS:
;
;*************************************** 
INITIAL PROC
    PUSH    AX
    PUSH    BX
    PUSH    SI
    PUSH    DI
    MOV     SI, OFFSET STRINGA+2
    MOV     DI, OFFSET STRINGA
IREPLA:
    MOV     BL, [SI]
    MOV     [DI], BL
    INC     SI
    INC     DI
    CMP     BL, 13 ;CRET
    JNE     IREPLA 
    DEC     DI
    MOV     [DI], 36 ;"$" SIGN

    MOV     SI, OFFSET STRINGB+2
    MOV     DI, OFFSET STRINGB
IREPLB:
    MOV     BL, [SI]
    MOV     [DI], BL
    INC     SI
    INC     DI
    CMP     BL, 13 ;CRET
    JNE     IREPLB
    DEC     DI
    MOV     [DI], 36 ;"$" SIGN
        
    POP     DI
    POP     SI
    POP     BX
    POP     AX
    RET
INITIAL ENDP  

;***************************************
;FUNCTION:
;cue and input stringA and stringB       
;INPUT PARAMETERS:   
;
;OUTPUT PARAMETERS:
;stringA and stringB
;*************************************** 
WELCOME PROC
    PUSH    DX
    PUSH    AX
    
    MOV     DL, OFFSET CUEA
    MOV     AH, 09H
    INT     21H
   ; CALL    NLINE
    MOV     DX, OFFSET  STRINGA
    MOV     AH, 0AH
    INT     21H
    CALL    NLINE
    
    MOV     DL, OFFSET CUEB
    MOV     AH, 09H
    INT     21H
   ; CALL    NLINE
    MOV     DX, OFFSET  STRINGB
    MOV     AH, 0AH
    INT     21H
    CALL    NLINE
    POP     AX
    POP     DX     
    RET
WELCOME ENDP    

;***************************************
;FUNCTION:
;print menu and excute user choice      
;INPUT PARAMETERS:   
;
;OUTPUT PARAMETERS:
;
;*************************************** 
MENU PROC
    PUSH    AX
    PUSH    DX
    MOV     DL, OFFSET STRAMSG
    MOV     AH, 09H
    INT     21H
    MOV     DL, OFFSET STRINGA
    MOV     AH, 09H
    INT     21H
    CALL    NLINE
    MOV     DL, OFFSET STRBMSG
    MOV     AH, 09H
    INT     21H
    MOV     DL, OFFSET STRINGB
    MOV     AH, 09H
    INT     21H
    CALL    NLINE
    MOV     DL, OFFSET SEPARATOR
    MOV     AH, 09H
    INT     21H
    CALL    NLINE 
    MOV     DX, OFFSET QUEST1
    MOV     AH, 09H
    INT     21H
    CALL    NLINE
    MOV     DX, OFFSET QUEST2
    MOV     AH, 09H
    INT     21H
    CALL    NLINE
    MOV     DX, OFFSET QUEST3
    MOV     AH, 09H
    INT     21H
    CALL    NLINE
    MOV     DX, OFFSET QUEST4
    MOV     AH, 09H
    INT     21H
    CALL    NLINE
    MOV     DX, OFFSET SEPARATOR
    MOV     AH, 09H
    INT     21H
    CALL    NLINE
    POP     DX
    POP     AX
    RET
MENU ENDP    

;***************************************
;FUNCTION:
;waiting for user choice       
;INPUT PARAMETERS:   
;
;OUTPUT PARAMETERS:
;
;*************************************** 
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
        CMP     AH, 5H
        JE      OP4
        JMP     FINISH
    OP1:
        CALL    SERACH
        JMP     FINISH
    OP2:
        CALL    INSERT
        JMP     FINISH    
    OP3:
        CALL    DELETE    
        JMP     FINISH 
    OP4:
        CALL    QUITP
        JMP     FINISH        
    FINISH:
        POP     AX
        RET
GET_KEY ENDP    

;***************************************
;FUNCTION:
;search stringB in stringA      
;INPUT PARAMETERS:   
;stringA stringB
;OUTPUT PARAMETERS:
;
;*************************************** 
SERACH PROC
    PUSH    AX
    PUSH    BX
    PUSH    DX
    PUSH    SI
    PUSH    DI
    MOV     DX, OFFSET RESPOND1
    CALL    DSP_STRING
    ;CALL    NLINE
    MOV     DX, OFFSET CUE1
    MOV     AH, 09H
    INT     21H
    
    MOV     SI, OFFSET STRINGA
    MOV     DI, OFFSET STRINGB
NEXTCHAR:    
    MOV     AH, [SI]
    MOV     AL, [DI]
    CMP     AH, "$"
    JE      FINISHMATCH
    CMP     AH, AL
    JNE     NEXT1
    MOV     BX, SI  ;FIRST CHAR MATCHED
    ;SUB     BX, 2
    PUSH    SI
MATCHNEXTCHAR:       
    INC     SI
    INC     DI 
    MOV     AH, [SI]
    MOV     AL, [DI]
    CMP     AL, "$" ;STRB END
    JE      MATCH
    CMP     AH, AL  ;STRB NOT END
    JNE     NEXT2 
    JMP     MATCHNEXTCHAR    
NEXT1:
    INC     SI
    MOV     DI, OFFSET STRINGB
    JMP     NEXTCHAR 
NEXT2:
    POP     SI
    INC     SI
    MOV     DI, OFFSET STRINGB
    JMP     NEXTCHAR     
MATCH:
    POP     DI      ;MUST POP SI, ELSE RET WONT GET THE RIGHT IP ADDRESS
    MOV     AL, BL
    INC     AL
    CALL    CONVERTTODEC
    MOV     DI, OFFSET STRINGB
    JMP     NEXTCHAR
FINISHMATCH:
    CALL    NLINE
    CALL    NLINE
    POP     DI
    POP     SI
    POP     DX
    POP     BX
    POP     AX
    RET
SERACH ENDP

;***************************************
;FUNCTION:
;get insert position and insert stringB to stringA    
;INPUT PARAMETERS:   
;
;OUTPUT PARAMETERS:
;numberpos, 
;*************************************** 
INSERT PROC
    PUSH    AX
    PUSH    DX
    MOV     DX, OFFSET RESPOND2
    CALL    DSP_STRING
    MOV     DX, OFFSET CUE2
    MOV     AH, 09H
    INT     21H
    CALL    GETNUMBER
    CALL    NLINE
    MOV     AX, NUMBERPOS
    MOV     SI, OFFSET  STRINGA
COUNTA:    
    MOV     BL, [SI]
    CMP     BL, "$"
    JE      COUNTDONEA
    INC     SI  
    JMP     COUNTA
COUNTDONEA:
    MOV     BX, SI
    MOV     CX, BX  ;CX:LENGTH OF STRINGA
     
    MOV     SI, OFFSET  STRINGB
    PUSH    SI
COUNTB:    
    MOV     BL, [SI]
    CMP     BL, "$"
    JE      COUNTDONEB
    INC     SI
    JMP     COUNTB
COUNTDONEB:
    MOV     BX, SI
    POP     SI
    SUB     BX, SI
    MOV     DX, BX  ;DX:LENGTH OF STRINGB
    
    DEC     AX  
    MOV     SI, CX
    MOV     DI, SI
    ADD     DI, DX    
SHIFT:
    MOV     BL, [SI]
    MOV     [DI], BL
    CMP     SI, AX
    JE      COPYSTART
    DEC     SI
    DEC     DI
    JMP     SHIFT
COPYSTART:
    ADD     AX, OFFSET STRINGA    
    MOV     DI, AX
    MOV     SI, OFFSET STRINGB
COPY:     
    MOV     BL, [SI]          
    CMP     BL, "$"
    JE      INSERTDONE
    MOV     [DI], BL
    INC     SI
    INC     DI
    JMP     COPY
INSERTDONE:         
    POP     DX
    POP     AX
    RET
INSERT ENDP

;***************************************
;FUNCTION:
;delete stringB from stringA      
;INPUT PARAMETERS:   
;
;OUTPUT PARAMETERS:
;
;*************************************** 
DELETE PROC
    PUSH    AX
    PUSH    BX
    PUSH    DX
    PUSH    SI
    PUSH    DI
    MOV     DX, OFFSET RESPOND3
    CALL    DSP_STRING
    MOV     DX, OFFSET CUE3
    CALL    DSP_STRING
    
    MOV     SI, OFFSET STRINGA
    MOV     DI, OFFSET STRINGB
DNEXTCHAR:    
    MOV     AH, [SI]
    MOV     AL, [DI]
    CMP     AH, "$"
    JE      DFINISHMATCH
    CMP     AH, AL
    JNE     DNEXT1
    MOV     BX, SI  ;FIRST CHAR MATCHED
    PUSH    SI
DMATCHNEXTCHAR:       
    INC     SI
    INC     DI 
    MOV     AH, [SI]
    MOV     AL, [DI]
    CMP     AL, "$" ;STRB END
    JE      DMATCH
    CMP     AH, AL  ;STRB NOT END
    JNE     DNEXT2 
    JMP     DMATCHNEXTCHAR    
DNEXT1:
    INC     SI
    MOV     DI, OFFSET STRINGB
    JMP     DNEXTCHAR 
DNEXT2:
    POP     SI
    INC     SI
    MOV     DI, OFFSET STRINGB
    JMP     DNEXTCHAR     
DMATCH:
    POP     DI      ;MUST POP SI, ELSE RET WONT GET THE RIGHT IP ADDRESS
    MOV     AL, BL
    MOV     AH, 0
    CALL    ERASE
    MOV     DI, OFFSET STRINGB
    SUB     SI, CNTB
    JMP     DNEXTCHAR
DFINISHMATCH:
    CALL    NLINE
    POP     DI
    POP     SI
    POP     DX
    POP     BX
    POP     AX
    RET
DELETE ENDP

;***************************************
;FUNCTION:
;quit program       
;INPUT PARAMETERS:   
;
;OUTPUT PARAMETERS:
;
;*************************************** 
QUITP PROC
    PUSH    AX
    PUSH    DX
    MOV     DX, OFFSET RESPOND4
    CALL    DSP_STRING
    MOV     DX, OFFSET CUE4
    MOV     AH, 09H
    INT     21H
    CALL    NLINE
    POP     DX
    POP     AX   
    JMP     EXITP
    RET
QUITP ENDP

;***************************************
;FUNCTION:
;erase stringB in stringA, called by delete function       
;INPUT PARAMETERS:   
;
;OUTPUT PARAMETERS:
;
;*************************************** 
ERASE PROC
    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX
    PUSH    SI
    PUSH    DI
    MOV     SI, OFFSET  STRINGB
    PUSH    SI
ECOUNTB:    
    MOV     BL, [SI]
    CMP     BL, "$"
    JE      ECOUNTDONEB
    INC     SI
    JMP     ECOUNTB
ECOUNTDONEB:
    MOV     BX, SI
    POP     SI
    SUB     BX, SI
    MOV     DX, BX  ;DX:LENGTH OF STRINGB
    MOV     CNTB, DX
    ;DEC     AX
    MOV     DI, OFFSET STRINGA
    ADD     DI, AX   
    MOV     SI, DI
    ADD     SI, DX  
ESHIFT:
    MOV     BL, [SI]
    MOV     [DI], BL
    CMP     BL, "$"
    JE      ERASEDONE
    INC     SI
    INC     DI
    JMP     ESHIFT
ERASEDONE:    
    POP     DI
    POP     SI       
    POP     DX
    POP     CX 
    POP     BX
    POP     AX
    RET
ERASE ENDP   

;***************************************
;FUNCTION:
;DISPLAY THE NUMBER IN AL IN DECIMAL      
;INPUT PARAMETERS:   
;
;OUTPUT PARAMETERS:
;
;*************************************** 
CONVERTTODEC PROC  
    PUSH    AX
    PUSH    BX
    PUSH    CX
    PUSH    DX
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
    JE      FINISH1 
    DEC     CH
    POP     DX
    ADD     DL, '0'
    MOV     AH, 02H
    INT     21H
    JMP     PRINTLOOP1
FINISH1:
    MOV     DX, OFFSET COMMA
    MOV     AH, 09H
    INT     21H        
    POP     DX
    POP     CX
    POP     BX
    POP     AX
    RET
CONVERTTODEC ENDP
;***************************************
;FUNCTION:
;get digital input string    
;INPUT PARAMETERS:   
;
;OUTPUT PARAMETERS:
;number
;*************************************** 
GETNUMBER PROC
    PUSH    AX
    PUSH    DX
    MOV     AH, 0AH
    LEA     DX, INSERTPOS
    INT     21H
    CALL    ConvertToNumber
    POP     DX
    POP     AX
    RET
GETNUMBER ENDP
;***************************************
;FUNCTION:
;convert the string to number   
;INPUT PARAMETERS:   
;
;OUTPUT PARAMETERS:
;number
;*************************************** 
ConvertToNumber PROC
        PUSH    AX
        PUSH    CX
        PUSH    DX
        PUSH    SI
        MOV     SI, OFFSET INSERTPOS + 2 ; 跳过输入缓冲区的长度字节
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
        MOV     NUMBERPOS, AX       ; 将结果存储到 Number 变量
        POP     SI
        POP     DX
        POP     CX
        POP     AX
        RET
ConvertToNumber ENDP

end start ; set entry point and stop the assembler.
