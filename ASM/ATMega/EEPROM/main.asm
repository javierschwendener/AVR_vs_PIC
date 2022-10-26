;////////////////////
; MEMORIA EEPROM ASM
;////////////////////

; Inicio
.ORG	0

; Configuracion
setup:
	;/////////////////////////
	;VARIABLES
	LDI		R20,	0B00000000
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
	
	RJMP	loop

eeprom_write:
	
	RET

eeprom_read:
	
	RET