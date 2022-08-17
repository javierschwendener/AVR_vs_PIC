;/////////////////
; PILA SIMPLE ASM
;/////////////////


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
	LDI		R16,	0B00000011
	OUT		PORTD,	R16
	RET
