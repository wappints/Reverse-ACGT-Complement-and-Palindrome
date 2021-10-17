; YEOHAN NORONA, S12
; EVERYTHING WORKS VERSION
%include "io-custom.inc"
global _main
extern _printf, _gets, _system
section .data
inputDNA db "DNA STRING: ", 0
inputCHOICE db "Do you want to try again? ", 0

prompt1 db "Reverse complement: %s ", 13,10,0
prompt2 db "Reverse palindrome? Yes", `\n`, 0
prompt3 db "Reverse palindrome? No " ,`\n`, 0
newlinee db `\n`, 0 
NullError db "Error: Null input ", `\n`, 0
NoTermError db "Error: Invalid or no terminator ", `\n`, 0
InvalidError db "Error: Invalid input ", `\n`, 0
MaxError db "Error: Beyond maximum length ", `\n`, 0
Again db "Please try again. ", `\n`, 0
CLSS db "cls", 0
string times 21 db 0
reverse times 21 db 0
newDNA times 21 db 0
choice times 10 db 0
section .text

;------------------------------ START AND END 
_main:

            push CLSS
            call _system
            add esp, 4 
RESTART:

            ; printf("DNA string: "); from right to left 
            push inputDNA
            call _printf
            add esp, 4 
    
            ; gets(string)`
            push string
            call _gets
            add esp, 4
            
            push newlinee
            call _printf
            add esp, 4
            ; check for input errors
            ;JMP CHECKING
    
            MOV CL, 0
            LEA ESI, [string]
            LEA EDI, [newDNA]
    
            L1:
            MOV AL, [ESI]
            cmp AL, 0
            JE NULL_INPUT
            BACK:
            cmp CL, 20
            JG MAX_LENGTH  
            cmp AL, "."
            JE CHECKER
            cmp AL, 0
            JE NO_TERM 
            cmp AL, 65
            JE ConvAT
            cmp AL, 84
            JE ConvTA
            cmp AL, 67
            JE ConvCG
            cmp AL, 71
            JE ConvGC
            JMP INVALID_INPUT
            
            Resume:
            INC ESI
            INC CL
            JMP L1
            
            ConvAT:
            mov AL, 84
            mov [EDI], AL
            INC EDI
            JMP Resume
            
            ConvTA:
            mov AL, 65
            mov [EDI], AL
            INC EDI
            JMP Resume
            
            ConvCG:
            mov AL, 71
            mov [EDI], AL
            INC EDI
            JMP Resume
            
            ConvGC:
            mov AL, 67
            mov [EDI], AL
            INC EDI
            JMP Resume
            
            CHECKER:
            CMP CL, 0
            JE INVALID_INPUT
            
            FINISH:
            
            JMP REVERSAL
            
            FINAL:

            xor ecx, ecx
            xor eax, eax
            ret
            
;-----------------------------------------

            NULL_INPUT:
            cmp CL, 1
            JGE BACK
            push NullError
            call _printf
            add esp, 4
            push newlinee
            call _printf
            add esp, 4
            JMP AGAIN_PROMPT
            
            INVALID_INPUT:
            push InvalidError
            call _printf
            add esp, 4
            push newlinee
            call _printf
            add esp, 4
            JMP AGAIN_PROMPT

            NO_TERM:
            push NoTermError
            call _printf
            add esp, 4
            push newlinee
            call _printf
            add esp, 4
            JMP AGAIN_PROMPT
            
            MAX_LENGTH:
            push MaxError
            call _printf
            add esp, 4
            push newlinee
            call _printf
            add esp, 4
            JMP AGAIN_PROMPT
            
            AGAIN_PROMPT: 
            push Again
            call _printf
            add esp, 4
            push newlinee
            call _printf
            add esp, 4
            JMP DUMP
            
            INVALID_INPUT2:
            push InvalidError
            call _printf
            add esp, 4
            push newlinee
            call _printf
            add esp, 4
            JMP CHOICE
;----------------------------------------
REVERSAL:
            MOV EBX, 0
            LEA EDI, [newDNA]
            
LOOP1:      LEA ESI, [EDI+EBX]
            cmp byte [ESI], 0
            JNE INCREMENT
            MOV EAX, 0
            MOV ECX, EBX
            sub ECX, 1
            JMP CHECKING
INCREMENT:  
            INC EBX
            JMP LOOP1
CHECKING:   
            cmp EAX, EBX
            JL REVERSED
            
            push reverse
            push prompt1
            call _printf
            add esp, 8
            push newlinee
            call _printf
            add esp, 4
            MOV EAX, 0
            MOV AL, [string]
            MOV AH, [reverse]
            cmp AL, AH
            JNE DAMN

            
            push prompt2
            call _printf
            add esp, 4
            push newlinee
            call _printf
            add esp, 4
            JMP CHOICE    
               
DAMN:       push prompt3
            call _printf
            add esp, 4
            push newlinee
            call _printf
            add esp, 4
            JMP CHOICE 
                           
REVERSED:   MOV DL, [EDI+ECX]
            MOV [reverse+EAX], DL
            INC EAX
            DEC ECX
            JMP CHECKING 
;-----------------------------------------

CHOICE: 
   push inputCHOICE
   call _printf
   add esp, 4
   push choice
   call _gets
   add esp, 4
   push newlinee
   call _printf
   add esp, 4
   MOV AL, [choice]           
   CMP AL, "Y"
   JE DUMP
   CMP AL, "N"
   JE FINAL
   CMP AL, "y"
   JE DUMP
   CMP AL, "n"
   JE FINAL
   JMP INVALID_INPUT2
   
   
DUMP: 
            MOV ECX, 21 
            LEA ESI,[reverse]
            LEA EDI,[newDNA]
            
DUMP2:      
            MOV byte [ESI],0
            INC ESI   
            MOV byte [EDI],0
            INC EDI

            DEC ECX
            CMP ECX, 0
            JE RESTART
            JMP DUMP2