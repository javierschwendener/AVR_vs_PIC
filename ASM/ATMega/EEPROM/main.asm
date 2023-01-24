;////////////////////
; MEMORIA EEPROM ASM
;////////////////////

; Inicio
.ORG	0

; Configuracion
setup:
	;/////////////////////////
	;CONTADOR
	LDI		R20,	0B00000000
	LDI		R25,	0B00000000
	LDI		R30,	0B00000000
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
    RJMP	loop

loop:
	;SECUENCIA PARA EL CONTADOR EN EL PUERTO B
	SBIC	PIND,	0
	INC		R20
	SBIC	PIND,	0
	RJMP	PC-1

	SBIC	PIND,	1
	DEC		R20
	SBIC	PIND,	1
	RJMP	PC-1

	LDI		R16,	0B00010000		;16
	SUB		R16,	R20
	IN		R25,	SREG
	SBRC	R25,	1
	CLR		R20						;0

	LDI		R16,	0B11111111		;255
	SUB		R16,	R20
	IN		R25,	SREG
	SBRC	R25,	1
	RJMP	PC+2
	RJMP	PC+2

	LDI		R20,	0B00001111		;15

	CALL	table

	OUT		PORTB,	R30				;PORTB = R30 - DISP

	;SECUENCIA PARA GUARDAR Y CARGAR DE LA MEMORIA EEPROM

	;Si se presiona el botón en D2, guardar el valor actual en la EEPROM
	SBIC	PIND,	2
	CALL	eeprom_write
	SBIC	PIND,	2
	RJMP	PC-1

	;Si se presiona el botón en D3, cargar el valor guardado en la EEPROM
	SBIC	PIND,	3
	CALL	eeprom_read
	SBIC	PIND,	3
	RJMP	PC-1

	RJMP	loop


table:
	LDI		R16,	0B00000000		;0
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B00111111		;R30 = 0 - DISP
	RET
	;Con Z != 1
	LDI		R16,	0B00000001		;1
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B00000011		;R30 = 1 - DISP
	RET
	;Con Z != 1
	LDI		R16,	0B00000010		;2
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B01011110		;R30 = 2 - DISP
	RET
	;Con Z != 1
	LDI		R16,	0B00000011		;3
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B01001111		;R30 = 3 - DISP
	RET
	;Con Z != 1
	LDI		R16,	0B00000100		;4
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B01100011		;R30 = 4 - DISP
	RET
	;Con Z != 1
	LDI		R16,	0B00000101		;5
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B01101101		;R30 = 5 - DISP
	RET
	;Con Z != 1
	LDI		R16,	0B00000110		;6
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B01111101		;R30 = 6 - DISP
	RET
	;Con Z != 1
	LDI		R16,	0B00000111		;7
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B00000111		;R30 = 7 - DISP
	RET
	;Con Z != 1
	LDI		R16,	0B00001000		;8
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B01111111		;R30 = 8 - DISP
	RET
	;Con Z != 1
	LDI		R16,	0B00001001		;9
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B01100111		;R30 = 9 - DISP
	RET
	;Con Z != 1
	LDI		R16,	0B00001010		;A - 10
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B01110111		;R30 = A - DISP
	RET
	;Con Z != 1
	LDI		R16,	0B00001011		;B - 11
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B01111001		;R30 = B - DISP
	RET
	;Con Z != 1
	LDI		R16,	0B00001100		;C - 12
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B00111100		;R30 = C - DISP
	RET
	;Con Z != 1
	LDI		R16,	0B00001101		;D - 13
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B01011011		;R30 = D - DISP
	RET
	;Con Z != 1
	LDI		R16,	0B00001110		;E - 14
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B01111100		;R30 = E - DISP
	RET
	;Con Z != 1
	LDI		R16,	0B00001111		;F - 15
	SUB		R16,	R20				;R16 - counter
	IN		R25,	SREG			;R25 = STATUS
	SBRC	R25,	1				;Revisar Z
	RJMP	PC+2					;Z = 1
	RJMP	PC+3					;Z != 1
	;Con Z = 1
	LDI		R30,	0B01110100		;R30 = F - DISP
	RET
	;Con Z != 1
	LDI		R30,	0B00110011		;R30 = || - DISP
	RET

eeprom_write:
	SBI		PORTC,	0
	LDI		R16,	0B00000000
	OUT		EEARH,	R16
	OUT		EEARL,	R16				;Address = 0
	OUT		EEDR,	R20				;Data = R20 (counter)
	SBI		EECR,	EEMPE			;Empezar escritura
	SBI		EECR,	EEPE			;Escribir EEDR en EEAR
	SBIC	EECR,	EEPE
	RJMP	PC-1
	CBI		PORTC,	0
	RET

eeprom_read:
	SBI		PORTC,	0
	LDI		R16,	0B00000000
	OUT		EEARH,	R16
	OUT		EEARL,	R16				;Address = 0
	SBI		EECR,	EERE			;Empezar lectura
	IN		R20,	EEDR			;Leer de EEDR en EEAR y guardar en R20
	CBI		PORTC,	0
	RET