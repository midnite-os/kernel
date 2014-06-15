[SECTION .text]
[BITS 32]

[GLOBAL load_cs]
[GLOBAL load_ds]
[GLOBAL load_es]
[GLOBAL load_fs]
[GLOBAL load_gs]
[GLOBAL load_ss]

[GLOBAL load_gdt]
[GLOBAL load_idt]
[GLOBAL load_tr]

[GLOBAL read_cr0]
[GLOBAL read_cr2]
[GLOBAL read_cr3]
[GLOBAL read_cr4]

[GLOBAL read_dr0]
[GLOBAL read_dr1]
[GLOBAL read_dr2]
[GLOBAL read_dr3]
[GLOBAL read_dr6]
[GLOBAL read_dr7]

[GLOBAL read_flags]

[GLOBAL write_cr0]
[GLOBAL write_cr2]
[GLOBAL write_cr3]
[GLOBAL write_cr4]

[GLOBAL write_dr0]
[GLOBAL write_dr1]
[GLOBAL write_dr2]
[GLOBAL write_dr3]
[GLOBAL write_dr6]
[GLOBAL write_dr7]

[GLOBAL write_flags]

[GLOBAL opcode_invlpg]

read_cr0:
		MOV	EAX, CR0
		RET
read_cr2:
		MOV	EAX, CR2
		RET
read_cr3:
		MOV	EAX, CR3
		RET
read_cr4:
		MOV	EAX, CR4
		RET
read_dr0:
		MOV	EAX, DR0
		RET
read_dr1:
		MOV	EAX, DR1
		RET
read_dr2:
		MOV	EAX, DR2
		RET
read_dr3:
		MOV	EAX, DR3
		RET
read_dr6:
		MOV	EAX, DR6
		RET
read_dr7:
		MOV	EAX, DR7
		RET
read_flags:
		PUSHF
		POP	EAX
		RET

write_cr0:
		MOV	EAX, [ESP + 4]
		MOV	CR0, EAX
		RET
write_cr2:
		MOV	EAX, [ESP + 4]
		MOV	CR2, EAX
		RET
write_cr3:
		MOV	EAX, [ESP + 4]
		MOV	CR3, EAX
		RET
write_cr4:
		MOV	EAX, [ESP + 4]
		MOV	CR4, EAX
		RET
write_dr0:
		MOV	EAX, [ESP + 4]
		MOV	DR0, EAX
		RET
write_dr1:
		MOV	EAX, [ESP + 4]
		MOV	DR1, EAX
		RET
write_dr2:
		MOV	EAX, [ESP + 4]
		MOV	DR2, EAX
		RET
write_dr3:
		MOV	EAX, [ESP + 4]
		MOV	DR3, EAX
		RET
write_dr6:
		MOV	EAX, [ESP + 4]
		MOV	DR6, EAX
		RET
write_dr7:
		MOV	EAX, [ESP + 4]
		MOV	DR7, EAX
		RET
write_flags:
		POPF
		RET

load_gdt:
		MOV	EAX, [ESP + 4]
; Load Global Descriptor Table from GDTR
		LGDT	[EAX]
		RET

load_idt:
		MOV	EAX, [ESP + 4]
; Load Global Descriptor Table from GDTR
		LIDT	[EAX]
		RET

load_tr:
		PUSH	EBP
		MOV	EBP, ESP
;		PUSH	EAX
;		PUSH	EBX
;		PUSH	ECX
;		PUSH	EDX
		MOV	EAX, [EBP + 8]
		OR	AL, 00000011b
		MOV	EBX, [EBP + 12]
		OR	BL, 00000011b
		MOV	ECX, [EBP + 16]
		OR	CL, 00000011b
		MOV	EDX, [EBP + 20]
		LTR	AX

		MOV	EAX, ESP
		MOV	DS, CX
		MOV	ES, CX
		MOV	FS, CX
		MOV	GS, CX

		PUSH	ECX			; Data Selector (For SS)
		PUSH	EAX			; ESP
		PUSHF				; Flags
		POP	EAX
		OR	EAX, 0x200		; Set IF
		PUSH	EAX
		PUSH	EBX			; Code Selector
		PUSH	EDX			; EIP

		IRETD
		

;
; This code is only possible if the code segment can be written to.
; Needs further testing because of this.
; This code will only work if the code segment is writable ?? (What about if the data segment overlaps and is writable)
; But will stop working if a code segment has been loaded that is read-only (Probably not if the data segment overlaps)
;
load_cs:
		MOV	EAX, [ESP + 4]
		MOV	[.selector], AX
		db	0xEA		; JMP dword Selector/16:Address/32
		dd	.address	; Address
.selector:	dw	0x0000		; Selector
.address:	
		RET

load_ds:
		MOV	DS, [ESP + 4]
		RET

load_es:
		MOV	ES, [ESP + 4]
		RET

load_fs:
		MOV	FS, [ESP + 4]
		RET

load_gs:
		MOV	GS, [ESP + 4]
		RET

load_ss:
		PUSH	EBP
		MOV	EBP, ESP		; EBP/ESP      -> Points to EBP
						; EBP/ESP + 4  -> Points to EIP
						; EBP/ESP + 8  -> Points to Selector pushed onto stack
						; EBP/ESP + 12 -> Points to new ESP. Not yet implemented.
		XOR	EAX, EAX
		MOV	EAX, 0x0003FFFF
		MOV	ESP, EAX		; ESP is now 0x00000000

		MOV	EAX, [EBP + 8]		
		MOV	SS, AX			; SS is now using new Selector

		MOV	EAX, [EBP + 4]
		PUSH	EAX			; EIP is now on the stack

		MOV	EAX, [EBP]
		MOV	EBP, EAX

		XOR	EAX, EAX
		RET

opcode_invlpg:
		MOV	EAX, [ESP]
		INVLPG	[EAX]
		RET
