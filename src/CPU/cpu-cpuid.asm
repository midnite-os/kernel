[GLOBAL proc_cpuid]

proc_cpuid:
		PUSH	EBP
		MOV	EBP, ESP

		PUSH	ECX
		PUSH	EDX
		PUSH	EBX

		MOV	EAX, [EBP + 8]

		CPUID

		MOV	[.return + 0x00], EBX
		MOV	[.return + 0x04], EDX
		MOV	[.return + 0x08], ECX
		MOV	[.return + 0x0C], EAX

		POP	EBX
		POP	EDX
		POP	ECX

		MOV	EAX, .return
		LEAVE
		RET

.return:
		dd	0
		dd	0
		dd	0
		dd	0
