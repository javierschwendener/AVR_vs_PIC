;/////////////////////////////////////
; TEMPORIZADOR CON INTERRUPCIONES ASM
;/////////////////////////////////////

; Inicio
.ORG	0x00
	JMP	setup

; Vector interrupcion del Timer0
.ORG	0x20
	JMP	tmr0_isr


; Configuracion
setup:
	;/////////////////////////
	;VARIABLES
	LDI		R20,	0B00000000		;Contador
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
	;Se realiza la configuracion del Timer0
	CALL	tmr0_set
	;Se activan las interrupciones del microcontrolador
	SEI
	;Se carga 128 al Timer0
	LDI		R16,	0B10000000
	OUT		TCNT0,	R16
    RJMP	loop

loop:
	RJMP	loop

tmr0_set:
	LDI		R16,	0B00000000		;Operacion normal del temporizador
	OUT		TCCR0A,	R16
	LDI		R16,	0B00000101		;Prescaler de 1024 en los bits TCCR0B[2:0]
	OUT		TCCR0B,	R16
	LDI		R16,	0B00000001
	STS		TIMSK0,	R16				;Se habilita la interrupcion del Timer0
	RET

tmr0_isr:
	LDI		R16,	0B00001110		;Se carga 14 a R16 (contador) por la logica del programa
	SUB		R16,	R20				;Se realiza la resta R16-R20, se guarda en R16
	IN		R17,	SREG			;Se guarda STATUS en R17
	SBRC	R17,	1				;Se verifica el STATUS Z en R17
	RJMP	PC+5
	INC		R20						;Se incrementa el contador
	LDI		R16,	0B10000000
	OUT		TCNT0,	R16
	RETI
	LDI		R16,	0B10000000
	OUT		TCNT0,	R16
	SBI		PINB,	0				;Para intercambiar el estado del bit 0 del puerto B
	LDI		R20,	0B00000000		;Se reinicia el contador
	RETI