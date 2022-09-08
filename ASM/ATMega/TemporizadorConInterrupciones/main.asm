;/////////////////////////////////////
; TEMPORIZADOR CON INTERRUPCIONES ASM
;/////////////////////////////////////

; Inicio
.ORG	0

; Configuracion
setup:
	;/////////////////////////
	;VARIABLES
	LDI		R20,	0B00000000
	LDI		R21,	0B00000000
	;/////////////////////////

	
	;Puerto D como entradas para los botones
	LDI		R16,	0B00000000
	OUT		DDRD,	R16
	;Puertos B y C como salidas para las leds
	LDI		R16,	0B11111111
	OUT		DDRB,	R16
	OUT		DDRC,	R16
	;Se limpian los puertos
	LDI		R16,	0B00000000
	OUT		PORTD,	R16
	OUT		PORTB,	R16
	OUT		PORTC,	R16
	CALL	tmr0_set
	LDI		R16,	0B00000000
	OUT		TCNT0,	R16
    RJMP	loop

loop:
	IN		R20,	TCNT0			;Se guarda el valor del timer en R20
	SBRC	R20,	7				;Se verifica 0b10000000
	CALL	cont_int
	LDI		R16,	0B00001111		;Se carga 15 a R16 (ajustar timer)
	SUB		R16,	R21				;Resta R16 - R21, se guarda en R16
	IN		R17,	SREG			;Se guarda el registro STATUS en R17
	SBRC	R17,	1				;Se revisa el STATUS Z en R17
	CALL	blink					;Cambio de estado de LED en caso R16 = R21
	RJMP	loop

tmr0_set:
	LDI		R16,	0B00000000		;Operacion normal del temporizador
	OUT		TCCR0A,	R16
	LDI		R16,	0B00000101		;Prescaler de 1024 en los bits TCCR0B[2:0]
	OUT		TCCR0B,	R16
	RET

cont_int:
	INC		R21
	LDI		R16,	0B00000000
	OUT		TCNT0,	R16
	LDI		R20,	0B00000000
	RET

blink:
	LDI		R17,	0B00000000
	LDI		R20,	0B00000000		;Reinicio de variables utilizadas
	LDI		R21,	0B00000000

	SBIC	PINB,	0				;Se revisa si la LED esta encendida
	RJMP	PC+4
	LDI		R16,	0B00000001
	OUT		PORTB,	R16
	RET
	LDI		R16,	0B00000000
	OUT		PORTB,R16
	RET