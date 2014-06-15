GLOBAL registers
GLOBAL get_page_fault_code;

PUSH_ALL_SIZE	EQU	32
PUSH_SEG_SIZE	EQU	32

STACK_FRAME	EQU	0xFFFF

get_page_fault_code:
		PUSH    EBP
		MOV     EBP, ESP
		MOV     EAX, [EBP + 0x24]
		LEAVE
		RET

registers:
; Stack:
;
;	SS	<- ESP + 24	(These 5 will only be present if DumpRegisters called from Interrupt Handler
;	ESP	<- ESP + 20	(as the CPU will have pushed them onto the stack when the Interrupt
;	EFlags	<- ESP + 16	(was generated.
;	CS	<- ESP + 12	(
;	EIP	<- ESP + 8	(
;
;	EIP	<- ESP + 4	(From the original point that DumpRegisters was called)
;	EIP	<- ESP		(From where DumpRegisters called this function)
;

;		PUSH	EBX
;		PUSH	ECX
;		PUSH	EDX

		SUB	ESP, STACK_FRAME	; Move the stack 64k bytes away (this stops later CALLs from trashing our registers)

		PUSHAD

;		MOV	EAX, [ESP + STACK_FRAME + PUSH_ALL_SIZE + 20]
;		MOV	EBX, [ESP + STACK_FRAME + PUSH_ALL_SIZE + 24]
;		MOV	ECX, [ESP + STACK_FRAME + PUSH_ALL_SIZE + 28]
;		MOV	EDX, [ESP + STACK_FRAME + PUSH_ALL_SIZE + 64]

; Some Exceptions push an error code which means that the stack arrangement is different
		MOV	EAX, [EBP + 24]
		MOV	EBX, [EBP + 28]
		MOV	ECX, [EBP + 32]
		MOV	EDX, [EBP + 36]
; The Debugger Exception (Int 1) does not
		MOV	EAX, [EBP + 20]
		MOV	EBX, [EBP + 24]
		MOV	ECX, [EBP + 28]
		MOV	EDX, [EBP + 40]

;		MOV	EAX, [ESP + STACK_FRAME + PUSH_ALL_SIZE + 28]
;		MOV	EBX, [ESP + STACK_FRAME + PUSH_ALL_SIZE + 32]
;		MOV	ECX, [ESP + STACK_FRAME + PUSH_ALL_SIZE + 36]
;		MOV	EDX, [ESP + STACK_FRAME + PUSH_ALL_SIZE + 40]

		PUSH	ECX	; EFlags
		PUSH	EAX	; EIP
		PUSH	EDX	; SS
		PUSH	EBX	; CS

		MOV	EAX, [EBP + 32]
		MOV	EAX, [EBP + 36]
;		MOV	EAX, [ESP + STACK_FRAME + PUSH_ALL_SIZE + 24]
;		MOV	EAX, 0xdeadbeef
		MOV	[ESP + 28], EAX
;		MOV	[ESP + 28], dword 0xdeadc0de

		PUSH	DS
		PUSH	ES
		PUSH	FS
		PUSH	GS
;		PUSH	0x12345678
;		PUSH	0x87654321
		MOV	EAX, ESP
		ADD	ESP, PUSH_SEG_SIZE + PUSH_ALL_SIZE
		ADD	ESP, STACK_FRAME

;		POP	EDX
;		POP	ECX
;		POP	EBX
		RET
; Stack:
;
;	ESP	<- ESP + 56	(These 5 will only be present if DumpRegisters called from Interrupt Handler
;	SS	<- ESP + 52	(as the CPU will have pushed them onto the stack when the Interrupt
;	EFlags	<- ESP + 48	(was generated.
;	CS	<- ESP + 44	(
;	EIP	<- ESP + 40	(
;
;	EIP	<- ESP + 36	(From the original point that DumpRegisters was called)
;	EIP	<- ESP + 32	(From where DumpRegisters called this function)
;	EAX	<- ESP + 28
;	ECX	<- ESP + 24
;	EDX	<- ESP + 20
;	EBX	<- ESP + 16
;	ESP	<- ESP + 12
;	EBP	<- ESP + 8
;	ESI	<- ESP + 4
;	EDI	<- ESP
		MOV	EAX, [ESP + 36]		;
		PUSH	EAX
; Stack:
;
;	ESP	<- ESP + 60	(These 5 will only be present if DumpRegisters called from Interrupt Handler
;	SS	<- ESP + 56	(as the CPU will have pushed them onto the stack when the Interrupt
;	EFlags	<- ESP + 52	(was generated.
;	CS	<- ESP + 48	(
;	EIP	<- ESP + 44	(
;
;	EIP	<- ESP + 40	(From the original point that DumpRegisters was called)
;	EIP	<- ESP + 36	(From where DumpRegisters called this function)
;	EAX	<- ESP + 32
;	ECX	<- ESP + 28
;	EDX	<- ESP + 24
;	EBX	<- ESP + 20
;	ESP	<- ESP + 16
;	EBP	<- ESP + 12
;	ESI	<- ESP + 8
;	EDI	<- ESP + 4
;	EIP	<- ESP		(From the original point that DumpRegisters was called)
		MOV	EAX, [ESP + 36]		; Should be
		PUSH	EAX
; Stack:
;
;	ESP	<- ESP + 64	(These 5 will only be present if DumpRegisters called from Interrupt Handler
;	SS	<- ESP + 60	(as the CPU will have pushed them onto the stack when the Interrupt
;	EFlags	<- ESP + 56	(was generated.
;	CS	<- ESP + 52	(
;	EIP	<- ESP + 48	(
;
;	EIP	<- ESP + 44	(From the original point that DumpRegisters was called)
;	EIP	<- ESP + 40	(From where DumpRegisters called this function)
;	EAX	<- ESP + 36
;	ECX	<- ESP + 32
;	EDX	<- ESP + 28
;	EBX	<- ESP + 24
;	ESP	<- ESP + 20
;	EBP	<- ESP + 16
;	ESI	<- ESP + 12
;	EDI	<- ESP + 8
;	EIP	<- ESP		(From the original point that DumpRegisters was called)
;	EIP	<- ESP		(From where DumpRegisters called this function)
		MOV	EAX, ESP
		ADD	EAX, 8
		RET
