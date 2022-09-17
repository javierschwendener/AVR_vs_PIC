;/////////////////////////////////////
; TEMPORIZADOR CON INTERRUPCIONES ASM
;/////////////////////////////////////

; Inicio
.ORG	0x00
	JMP	setup

; Vector interrupcion de cambio de Pin 0
.ORG	0x0A
	JMP	pcint2_isr


; Configuracion
setup:
	;/////////////////////////
	;VARIABLES
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
	;Se realiza la configuracion del la interrupcion del pin
	CALL	pini_set
	;Se activan las interrupciones del microcontrolador
	SEI
    RJMP	loop

loop:
	RJMP	loop

pini_set:
	;RD0 equivale a PCINT16 para las interrupciones
	LDI		R16,	0B00000100
	STS		PCICR,	R16
	LDI		R16,	0B00000001
	STS		PCMSK2,	R16
	RET

pcint2_isr:
	;Comportamiento segun el boton en RD0
	;SBIC		PIND,	0
	;SBI			PORTB,	0
	;SBIS		PIND,	0
	;CBI			PORTB,	0

	;Comportamiento tipo toggle
	SBIC		PINB,	0
	RJMP		PC+3
	SBI			PORTB,	0
	RJMP		PC+2
	CBI			PORTB,	0

	RETI