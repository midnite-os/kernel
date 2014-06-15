[GLOBAL opcode_cli]
[GLOBAL opcode_sti]
[GLOBAL	opcode_iret]
[GLOBAL opcode_int]

opcode_cli:
	CLI
	RET

opcode_sti:
	STI
	RET

opcode_iret:

;		PUSHF
;		POP	EAX
;		AND	EAX, 0xFFFFFEFF
;		PUSH	EAX
;		POPF
;		MOV	AL, 'D'
;		MOV	DX, 0x3F8
;		OUT	DX, AL

;		MOV	EAX, ESP
;		SUB	EAX, 4
;		MOV	ESP, EAX
;		POP	EAX
		IRET

;
; More self-modifying code, this needs to be changed to one function for each Interrupt which is ridiculously ugly.
;
opcode_int:
		MOV	EAX, [ESP + 4]
		MOV	[.no], AL
	db	0xCD				; INT
.no:	db	0x00				; Interrupt No.
		RET
