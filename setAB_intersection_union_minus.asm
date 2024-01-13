; multi-segment executable file template.
data segment
    STRINGA     DB 20                              ;string A and string B are sets, contains no same char
                DB 21 DUP("$")
    STRINGB     DB 20
                DB 21 DUP("$")
    ;STRINGA     DB "aSZKHFhGs$$$$$$$$$$$$$$$$"     ;for test ues    
    ;STRINGB     DB "aSsOikJK$$$$$$$$$$$$"
    RESULT      DB  30 DUP("$")
    CUEA        DB "Please enter StrA:$"
    CUEB        DB "Please enter StrB:$"
    STRAMSG     DB "StrA:$"
    STRBMSG     DB "StrB:$"
    SEPARATOR   DB "=========================$"                
    QUEST1      DB  "1: Intersection of set A and set B.$"
    QUEST2      DB  "2: Union of set A and set B.$"
    QUEST3      DB  "3: set A minus set B$"
    QUEST4      DB  "4: Quit.$"
    RESPOND1    DB  "You press button 1.$"
    RESPOND2    DB  "You press button 2.$"
    RESPOND3    DB  "You press button 3.$"
    RESPOND4    DB  "You press button 4.$"
    CUE1        DB  "Intersection of Set A and Set B is:$"
    CUE2        DB  "Union of Set A and Set B is:$"
    CUE3        DB  "Set A minus Set B is:$"
    CUE4        DB  "program exit$.$"
    COMMA       DB  ", $"
    NEWLINE     DB  13, 10, "$"           
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
;print a new line      
;INPUT PARAMETERS:   
;DX
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
;delete the former 2 chars in stringA and stringB      
;INPUT PARAMETERS:   
;DX
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
;get user input      
;INPUT PARAMETERS:   
;DX
;OUTPUT PARAMETERS:
;
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
;pop a menu     
;INPUT PARAMETERS:   
;DX
;OUTPUT PARAMETERS:
;
;*************************************** 
MENU PROC
    PUSH    AX
    PUSH    DX
    MOV     DX, OFFSET STRAMSG
    MOV     AH, 09H
    INT     21H
    MOV     DL, OFFSET STRINGA
    MOV     AH, 09H
    INT     21H
    CALL    NLINE
    MOV     DX, OFFSET STRBMSG
    MOV     AH, 09H
    INT     21H
    MOV     DL, OFFSET STRINGB
    MOV     AH, 09H
    INT     21H
    CALL    NLINE
    MOV     DX, OFFSET SEPARATOR
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
;get user key input instruction      
;INPUT PARAMETERS:   
;DX
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
        CALL    INTERSECTION
        JMP     FINISH
    OP2:
        CALL    UNION
        JMP     FINISH    
    OP3:
        CALL    MINUS    
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
;get the intersection of set A and set B     
;INPUT PARAMETERS:   
;DX
;OUTPUT PARAMETERS:
;
;*************************************** 
INTERSECTION PROC
        PUSH    AX
        PUSH    BX
        PUSH    DX
        PUSH    SI
        PUSH    DI 
        MOV     DX, OFFSET RESPOND1
        CALL    DSP_STRING
        MOV     DX, OFFSET CUE1
        CALL    DSP_STRING
        
        MOV     SI, OFFSET STRINGA
        ;MOV     DI, OFFSET STRINGB
    INTERSECTIONA:    
        MOV     AH, [SI]            ;AH STORES STRINGA
        MOV     DI, OFFSET STRINGB
        CMP     AH, "$"
        JE      FINISHINTERSECTION
    LOOPB:    
        MOV     AL, [DI]            ;AL STORES STRINGB
        CMP     AL, "$"
        JE      LOOPBDONE
        CMP     AH, AL
        JNE     NEXTB               ;EQUAL
        ;PRINT  AH   
        MOV     DL, AH
        MOV     AH, 02
        INT     21H
        MOV     AH, DL              ;RESTORE AH, WHICH IS CHAR IN STRINGA
    NEXTB:
        INC     DI
        JMP     LOOPB    
    LOOPBDONE:
                  
        INC     SI
        JMP     INTERSECTIONA 
        
    FINISHINTERSECTION:
        CALL    NLINE
        CALL    NLINE
        POP     DI
        POP     SI
        POP     DX
        POP     BX
        POP     AX
        RET
INTERSECTION ENDP
;***************************************
;FUNCTION:
;get set A minus set B     
;INPUT PARAMETERS:   
;DX
;OUTPUT PARAMETERS:
;
;*************************************** 
MINUS PROC
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
        ;MOV     DI, OFFSET STRINGB
    MINUSA:    
        MOV     AH, [SI]            ;AH STORES STRINGA
        MOV     DI, OFFSET STRINGB 
        MOV     CX, 0
        CMP     AH, "$"
        JE      FINISHMINUS
    MLOOPB:    
        MOV     AL, [DI]            ;AL STORES STRINGB
        CMP     AL, "$"
        JE      MLOOPBDONE
        CMP     AH, AL
        JNE     MNEXTB              
        MOV     CX, 12H              ;EQUAL NOT PRINT  
    MNEXTB:
        INC     DI
        JMP     MLOOPB    
    MLOOPBDONE:
        CMP     CX, 0
        JNE     MJMPPRINT
        MOV     DL, AH
        MOV     AH, 02
        INT     21H
        MOV     AH, DL              ;RESTORE AH, WHICH IS CHAR IN STRINGA
    MJMPPRINT:              
        INC     SI
        JMP     MINUSA 
    FINISHMINUS:
        CALL    NLINE
        CALL    NLINE
        POP     DI
        POP     SI
        POP     DX
        POP     BX
        POP     AX
        RET
MINUS ENDP
;***************************************
;FUNCTION:
;get the union of set A and set B     
;INPUT PARAMETERS:   
;DX
;OUTPUT PARAMETERS:
;
;*************************************** 
UNION PROC
        PUSH    AX
        PUSH    BX
        PUSH    DX
        PUSH    SI
        PUSH    DI
        MOV     DX, OFFSET RESPOND2
        CALL    DSP_STRING
        MOV     DX, OFFSET CUE2
        CALL    DSP_STRING
        
        MOV     DX, OFFSET STRINGB
        MOV     AH, 09H
        INT     21H
        
        MOV     SI, OFFSET STRINGA
        ;MOV     DI, OFFSET STRINGB
    UNIONA:    
        MOV     AH, [SI]            ;AH STORES STRINGA
        MOV     DI, OFFSET STRINGB 
        MOV     CX, 0
        CMP     AH, "$"
        JE      FINISHUNION
    ULOOPB:    
        MOV     AL, [DI]            ;AL STORES STRINGB
        CMP     AL, "$"
        JE      ULOOPBDONE
        CMP     AH, AL
        JNE     UNEXTB              
        MOV     CX, 12H              ;EQUAL NOT PRINT  
    UNEXTB:
        INC     DI
        JMP     ULOOPB    
    ULOOPBDONE:
        CMP     CX, 0
        JNE     UJMPPRINT
        MOV     DL, AH
        MOV     AH, 02
        INT     21H
        MOV     AH, DL              ;RESTORE AH, WHICH IS CHAR IN STRINGA
    UJMPPRINT:              
        INC     SI
        JMP     UNIONA 
    FINISHUNION:
        CALL    NLINE
        CALL    NLINE
        POP     DI
        POP     SI
        POP     DX
        POP     BX
        POP     AX
        RET
UNION ENDP
;***************************************
;FUNCTION:
;quit program     
;INPUT PARAMETERS:   
;DX
;OUTPUT PARAMETERS:
;
;*************************************** 
QUITP PROC
    PUSH    AX
    PUSH    DX
    MOV     DX, OFFSET RESPOND4
    CALL    DSP_STRING
    MOV     DX, OFFSET CUE4
    CALL    DSP_STRING
    CALL    NLINE
    POP     DX
    POP     AX   
    JMP     EXITP
    RET
QUITP ENDP

end start ; set entry point and stop the assembler.
