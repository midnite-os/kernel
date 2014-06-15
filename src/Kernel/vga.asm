GLOBAL setmode
GLOBAL vga_init


; VGA Registers
ATTRCON_ADDR	EQU	0x03C0
MISC_ADDR	EQU	0x03C2
VGAENABLE_ADDR	EQU	0x03C3
SEQ_ADDR	EQU	0x03C4
GRACON_ADDR	EQU	0x03CE
CRTC_ADDR	EQU	0x03D4
STATUS_ADDR	EQU	0x03DA

;These next four lines must be included only if you use the Mode 03h fucntions
oldmode db 0
oldmisc db 0
oldmask db 0
oldmem db 0

%include "vga-init.asm"
%include "vga-mode03.asm"
%include "vga-font.asm"

setmode:

   ; Send MISC regs
   CALL OUTREGS
   ADD ESI,4

   MOV DX,STATUS_ADDR
   MOV AL,[ESI + 3]		;VGAREG.VALUE
   OUT DX,AL
   CALL IODELAY
   ADD ESI,4

   ; Send SEQ regs
   MOV CX,5
REG_LOOP:
   CALL OUTREGS
   ADD ESI,4
   LOOP REG_LOOP

   ; Clear Protection bits
   MOV AH,0EH
   MOV AL,11H
   AND AH,7FH
   MOV DX,CRTC_ADDR
   OUT DX,AX
   CALL IODELAY

   ; Send CRTC regs
   MOV CX,25
REG_LOOP2:
   CALL OUTREGS
   ADD ESI,4
   LOOP REG_LOOP2

   ; Send GRAPHICS regs
   MOV CX,9
REG_LOOP3:
   CALL OUTREGS
   ADD ESI,4
   LOOP REG_LOOP3

   MOV DX,STATUS_ADDR
   IN AL,DX
   CALL IODELAY

   ; Send ATTRCON regs
   MOV CX,21
REG_LOOP4:
   CALL OUTREGS
   ADD ESI,4
   LOOP REG_LOOP4

   MOV AL,20H
   OUT DX,AL
   CALL IODELAY

   RET

;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

OUTREGS:

   MOV AX,[ESI]			;VGAREG.PORT
   CMP AX,ATTRCON_ADDR
   JE CASE1
   CMP AX,MISC_ADDR
   JE CASE2
   CMP AX,VGAENABLE_ADDR
   JE CASE2
   JMP CASE3

CASE1:
   MOV DX,ATTRCON_ADDR
   IN AX,DX

   MOV AL,[ESI + 2]		;VGAREG.INDEX
   OUT DX,AL
   CALL IODELAY

   MOV AL,[ESI + 3]		;VGAREG.VALUE
   OUT DX,AL
   CALL IODELAY
   JMP CASEOUT

CASE2:
   MOV DX,[ESI]			;VGAREG.PORT
   MOV AL,[ESI + 3]		;VGAREG.VALUE
   OUT DX,AL
   CALL IODELAY
   JMP CASEOUT

CASE3:
   MOV DX,[ESI]			;VGAREG.PORT
   MOV AL,[ESI + 2]		;VGAREG.INDEX
   OUT DX,AL
   CALL IODELAY

   MOV DX,[ESI]			;VGAREG.PORT
   INC DX
   MOV AL,[ESI + 3]		;VGAREG.VALUE
   OUT DX,AL
   CALL IODELAY

CASEOUT:
   RET


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

SETFONT:                            ;
 mov dx,GRACON_ADDR                     ;get graphics port
 mov al,5                               ;get write mode reg
 out dx,al                              ;select the reg
 CALL IODELAY                                ;delay a bit
 inc dx                                 ;change DX
 in al,dx                               ;get value
 CALL IODELAY                                ;pause
 mov [oldmode],al                       ;store it
 dec dx                                 ;restore DX
 mov al,6                               ;get misc reg
 out dx,al                              ;select the reg
 CALL IODELAY                                ;delay a bit
 inc dx                                 ;change DX
 in al,dx                               ;get value
 CALL IODELAY                                ;pause
 mov [oldmisc],al                       ;store it
 dec dx                                 ;restore DX
 mov dx,SEQ_ADDR                        ;get sequencer port
 mov al,2                               ;get map mask reg
 out dx,al                              ;select the reg
 CALL IODELAY                                ;delay a bit
 inc dx                                 ;change DX
 in al,dx                               ;get value
 CALL IODELAY                                ;pause
 mov [oldmask],al                       ;store it
 dec dx                                 ;restore DX
 mov al,4                               ;get memory selector reg
 out dx,al                              ;select the reg
 CALL IODELAY                                ;delay a bit
 inc dx                                 ;change DX
 in al,dx                               ;get value
 CALL IODELAY                                ;pause
 mov [oldmem],al                        ;store it
 mov dx,GRACON_ADDR                     ;select graphics port
 mov al,5                               ;get write mode reg
 mov ah,[oldmode]                       ;get old value
 and ah,0fch                            ;mask it
 out dx,ax                              ;set new value
 CALL IODELAY                                ;pause
 mov al,6                               ;get misc reg
 mov ah,[oldmisc]                       ;get old value
 and ah,0f1h                            ;mask it
 or ah,4                                ;set a flag
 out dx,ax                              ;set it
 CALL IODELAY                                ;pause
 mov dx,SEQ_ADDR                        ;select sequencer port
 mov al,2                             ;get mask reg
 mov ah,4                               ;get new value
 out dx,ax                              ;set it
 CALL IODELAY                                ;pause
 mov al,4                              ;get memory reg
 mov ah,[oldmem]                        ;get old value
 or ah,4                                ;set flag
 out dx,ax                              ;set value
 CALL IODELAY                                ;pause
 MOV EDI, 0xa0000
 mov ESI, font                     ;get source
 xor ch,ch                              ;clear entries count
 cld                                    ;set direction flag correctly
@@loop1:                                ;
 push EDI                                ;save destination
; mov cl,16                              ;bytes per font
 MOV CL, 4
@@loop2:                                ;
 movsd                                  ;move a doubleword
 dec cl                                 ;decrease count
 jnz @@loop2                            ;loop until all done
 pop EDI                                 ;restore destination
 add EDI,32                              ;update it
 dec ch                                 ;decrease outer count
 jnz @@loop1                            ;loop until all done
 mov dx,GRACON_ADDR                     ;get graphics port
 mov al,5                               ;get 1st reg
 mov ah,[oldmode]                       ;get old value
 out dx,ax                              ;set it
 CALL IODELAY                                ;pause
 mov al,6                               ;get 2nd reg
 mov ah,[oldmisc]                       ;get old value
v out dx,ax                              ;set it
 CALL IODELAY                                ;pause
 mov dx,SEQ_ADDR                        ;get seq port
 mov al,2                               ;get 3rd reg
 mov ah,[oldmask]                       ;get old value
 out dx,ax                              ;set it
 CALL IODELAY                                ;pause
 mov al,4                               ;get 4th reg
 mov ah,[oldmem]                        ;get old value
 out dx,ax                              ;set it
 CALL IODELAY                                ;pause
 ret                                    ;exit


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
CLRSCR:
   PUSHA

   MOV EDI, 0xB8000
   XOR EAX, EAX
   MOV AH,00000111b ; Attribute
   MOV AL,' '       ; Character
   MOV CX,2880
   CLD
   REP STOSW    ; Move to memory
   ; Restore registers
   POPA
   RET 


;=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

IODELAY:
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  NOP
  RET



