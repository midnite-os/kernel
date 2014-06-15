[GLOBAL contextswitch]

contextswitch:

   mov    ax, 0x2B     		; Load the index of our TSS structure - The index is
                     		; 0x28, as it is the 5th selector and each is 8 bytes
                     		; long, but we set the bottom two bits (making 0x2B)
                     		; so that it has an RPL of 3, not zero.
   ltr    ax           		; Load 0x2B into the task state register.
   mov    ax, 0x23
   mov    ds, ax
   mov    es, ax 
   mov    fs, ax 
   mov    gs, ax 			;we don't need to worry about SS. it's handled by iret
 

   mov    eax, esp
   push dword  0x23 				;user data segment with bottom 2 bits set for ring 3
   push   eax 				;push our current stack just for the heck of it
   pushf
   push dword  0x1B 				;user code segment with bottom 2 bits set for ring 3
MOV EAX, userland_program
PUSH EAX
   iretd





;		MOV	EAX, [ESP + 4]
;		MOV	EBX, [ESP + 8]
;		MOV	ECX, [ESP + 12]


		POP	ECX
		POP	EAX
		POP	EBX
		POP	ECX

;INT3

;
; REALLY BAD HACK!!!
		PUSH	dword 0x0003FFFF
		POP	ESP
; END REALLY BAD HACK
		MOV	EDX, ESP
		MOV	DS, BX
		MOV	ES, BX
		MOV	FS, BX
		MOV	GS, BX

		PUSH	EBX			; Data Selector (For SS)
		PUSH	EDX			; ESP (The value it will be after everything is PUSHed
		PUSHF				; Flags

		POP	EDX
		OR	EDX, 0x200		; Set IF (Reenable Interrupts)
		OR	EDX, 0x100		; Set TF
		PUSH	EDX

		PUSH	EAX			; Code Selector
;		PUSH	ECX			; EIP
		MOV     ECX, userland_program
		PUSH    ECX
		IRETD



userland_program:
INT 0x30
_loop1:
JMP _loop1