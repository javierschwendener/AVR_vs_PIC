;//////////////////
; PILA ANIDADA ASM
;//////////////////


; Inicio
.ORG	0

; Configuracion
setup:		
	LDI		R16,	0B11111111
	OUT		DDRD,	R16
	LDI		R16,	0B00000000
	OUT		PORTD,	R16
    RJMP	loop

loop:
	LDI		R16,	0B00000001
	OUT		PORTD,	R16
	CALL	func1
	LDI		R16,	0B00000000
	OUT		PORTD,	R16
	RJMP	loop

func1:
	NOP
	CALL	func2
	RET

func2:
	NOP
	CALL	func3
	RET

func3:
	NOP
	CALL	func4
	RET

func4:
	NOP
	CALL	func5
	RET

func5:
	NOP
	CALL	func6
	RET

func6:
	NOP
	CALL	func7
	RET

func7:
	NOP
	CALL	func8
	RET

func8:
	NOP
	LDI		R16,	0B00000011
	OUT		PORTD,	R16
	RET
