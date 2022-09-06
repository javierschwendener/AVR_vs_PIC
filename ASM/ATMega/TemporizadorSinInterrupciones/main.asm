;/////////////////////////////////////
; TEMPORIZADOR SIN INTERRUPCIONES ASM
;/////////////////////////////////////

; Inicio
.ORG	0

; Configuracion
setup:
	;/////////////////////////
	;VARIABLES
	LDI		R20,	0B00000000	;Nibble inferior
	LDI		R21,	0B00000000	;Nibble superior
	LDI		R25,	0B00000000	;Variable para extraer el STATUS REGISTER
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
    RJMP	loop

loop:
	SBIC	PIND,	0
	CALL	suma1

	SBIC	PIND,	1
	CALL	resta1

	SBIC	PIND,	2
	CALL	suma2

	SBIC	PIND,	3
	CALL	resta2

	;Se mueven los resultados al puerto B
	LDI		R16,	0B00001111
	AND		R16,	R20
	OR		R16,	R21
	OUT		PORTB,	R16

	SBIC	PIND,	4
	CALL	resultado
	
	RJMP	loop

suma1:
	;Antirebote
	SBIC	PIND,	0
	RJMP	PC-1
	CALL	nops
	LDI		R16,	0B00001111	;Carga 15 a R16
	SUB		R16,	R20			;Se resta R16 - R20, se guarda en R16
	IN		R25,	SREG		;Se carga el valor del STATUS al registro R25
	SBRC	R25,	1			;Revisa el STATUS Z en el registro R25
	RJMP	PC+3
	;En caso Z = 0
	INC		R20					;Aumentar el contador 1
	RET
	;En caso Z = 1 (operacion SUB = 0)
	LDI		R20,	0B00000000	;Se reinicia R20
	RET

suma2:
	SBIC	PIND,	2
	RJMP	PC-1
	CALL	nops
	SWAP	R21					;Se hace swap de los nibbles de R21
	LDI		R16,	0B00001111	;Se carga 15 al registro R16
	SUB		R16,	R21			;Resta R16 - R21
	IN		R25,	SREG		;Se copia el registro STATUS en R25
	SBRC	R25,	1			;Se revisa el STATUS Z
	RJMP	PC+4
	;En caso Z = 0
	INC		R21					;Suma 1 al contador
	SWAP	R21					;Swap de los nibbles
	RET
	;En caso Z = 1 (operacion SUB = 0)
	LDI		R21,	0B00000000	;Reinicio del contador
	SWAP	R21					;Swap de los nibbles
	RET

resta1:
	SBIC	PIND,	1
	RJMP	PC-1
	CALL	nops
	LDI		R16,	0B00001111	;Carga 15 al registro R16
	AND		R16,	R20			;AND R16 & R20, se guarda en R16
	IN		R25,	SREG		;Se carga el valor del STATUS al registro R25
	SBRC	R25,	1			;Revisa el STATUS Z en el registro R25
	RJMP	PC+3
	;En caso Z = 0
	DEC		R20
	RET
	;En caso Z = 1 (operacion AND = 0)
	LDI		R20,	0B00001111
	RET

resta2:
	SBIC	PIND,	3
	RJMP	PC-1
	CALL	nops
	SWAP	R21
	LDI		R16,	0B00001111
	AND		R16,	R21
	IN		R25,	SREG
	SBRC	R25,	1
	RJMP	PC+4
	;En caso Z = 0
	DEC		R21
	SWAP	R21
	RET
	;En caso Z = 1 (operacion AND = 0)
	LDI		R21,	0B00001111
	SWAP	R21
	RET

resultado:
	SBIC	PIND,	4
	RJMP	PC-1
	CALL	nops
	SWAP	R21
	LDI		R16,	0B00000000
	OR		R16,	R20
	ADD		R16,	R21
	OUT		PORTC,	R16
	SWAP	R21
	RET

nops:
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	RET
