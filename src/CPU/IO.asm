GLOBAL input_byte
GLOBAL input_word
GLOBAL input_double
GLOBAL output_byte
GLOBAL output_word
GLOBAL output_double

input_byte:
	PUSH	EBP
	MOV	EBP, ESP
	PUSH	EDX

        MOV	EDX, [EBP + 8]
	IN	AL, DX

	POP	EDX
	LEAVE
	RET

input_word:
	PUSH	EBP
	MOV	EBP, ESP
	PUSH	EDX

        MOV	EDX, [EBP + 8]
	IN	AX, DX

	POP	EDX
	LEAVE
	RET

input_double:
	PUSH	EBP
	MOV	EBP, ESP
	PUSH	EDX

        MOV	EDX, [EBP + 8]
	IN	EAX, DX

	POP	EDX
	LEAVE
	RET

output_byte:
	PUSH	EBP
	MOV	EBP, ESP
	PUSH	EAX
	PUSH	EDX

        MOV	EDX, [EBP + 8]
	MOV	EAX, [EBP + 12]
	OUT	DX, AL

	POP	EDX
	POP	EAX
	LEAVE
	RET

output_word:
	PUSH	EBP
	MOV	EBP, ESP
	PUSH	EAX
	PUSH	EDX

        MOV	EDX, [EBP + 8]
	MOV	EAX, [EBP + 12]
	OUT	DX, AX

	POP	EDX
	POP	EAX
	LEAVE
	RET

output_double:
	PUSH	EBP
	MOV	EBP, ESP
	PUSH	EAX
	PUSH	EDX

        MOV	EDX, [EBP + 8]
	MOV	EAX, [EBP + 12]
	OUT	DX, EAX

	POP	EDX
	POP	EAX
	LEAVE
	RET
