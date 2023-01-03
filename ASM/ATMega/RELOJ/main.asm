;/////////////////////////////////////
; PROYECTO RELOJ
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
	LDI		R17,	0B00000001	;Estado
	LDI		R18,	0B00000000	;Contador1
	LDI		R19,	0B00000000	;Segundos1
	LDI		R20,	0B00000000	;Segundos2
	LDI		R21,	0B00000000	;Minutos1
	LDI		R22,	0B00000000	;Minutos2
	LDI		R23,	0B00000000	;Horas1
	LDI		R24,	0B00000000	;Horas2
	LDI		R25,	0B00000000	;Alamin1
	LDI		R26,	0B00000000	;Alamin2
	LDI		R27,	0B00000000	;Alahor1
	LDI		R28,	0B00000000	;Alahor2
	LDI		R29,	0B00000000	;SREG
	LDI		R30,	0B00000000	;CasoTabla
	;/////////////////////////
	
	;0 -> Entrada
	;1 -> Salida
	;Pines D0, D1, D2, D3 y D4 como entradas para los botones
	;Pines D5, D6 y D7 como salidas
	LDI		R16,	0B11100000
	OUT		DDRD,	R16

	;Puertos B y C como salidas para LEDs, 7 segmentos y transistores
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
	LDI		R16,	0B10100011		;Se mueve 163 a R16
	OUT		TCNT0,	R16

    RJMP	loop

tmr0_set:
	LDI		R16,	0B00000000		;Operacion normal del temporizador
	OUT		TCCR0A,	R16
	;LDI		R16,	0B00000101		;Prescaler de 1024 en los bits TCCR0B[2:0]
	LDI		R16,	0B00000010		;Prescaler de 1 en los bits TCCR0B[2:0]
	OUT		TCCR0B,	R16
	LDI		R16,	0B00000001
	STS		TIMSK0,	R16				;Se habilita la interrupcion del Timer0
	RET

table:
	LDI		R16,	0B00000000		;0
	SUB		R16,	R30				;R16 = R16 - R30 (numero de contador)
	IN		R29,	SREG			;R29 = SREG
	SBRC	R29,	1				;Se verifica SREG Z
	;Si Z = 1, entonces el numero es 0 y se configura en los pines correspondientes para el 7 segmentos
	RJMP	PC+2
	;De lo contrario, comprueba el siguiente numero
	RJMP	PC+5
	LDI		R16,	0B00111101		;0
	OUT		PORTC,	R16
	SBI		PORTD,	7
	RET

	LDI		R16,	0B00000001		;1
	SUB		R16,	R30				;R16 = R16 - R30 (numero de contador)
	IN		R29,	SREG			;R29 = SREG
	SBRC	R29,	1				;Se verifica SREG Z
	;Si Z = 1, entonces el numero es 1 y se configura en los pines correspondientes para el 7 segmentos
	RJMP	PC+2
	;De lo contrario, comprueba el siguiente numero
	RJMP	PC+5
	LDI		R16,	0B00010100		;1
	OUT		PORTC,	R16
	CBI		PORTD,	7
	RET
	
	LDI		R16,	0B00000010		;2
	SUB		R16,	R30				;R16 = R16 - R30 (numero de contador)
	IN		R29,	SREG			;R29 = SREG
	SBRC	R29,	1				;Se verifica SREG Z
	;Si Z = 1, entonces el numero es 2 y se configura en los pines correspondientes para el 7 segmentos
	RJMP	PC+2
	;De lo contrario, comprueba el siguiente numero
	RJMP	PC+5
	LDI		R16,	0B00101110		;2
	OUT		PORTC,	R16
	SBI		PORTD,	7
	RET

	LDI		R16,	0B00000011		;3
	SUB		R16,	R30				;R16 = R16 - R30 (numero de contador)
	IN		R29,	SREG			;R29 = SREG
	SBRC	R29,	1				;Se verifica SREG Z
	;Si Z = 1, entonces el numero es 3 y se configura en los pines correspondientes para el 7 segmentos
	RJMP	PC+2
	;De lo contrario, comprueba el siguiente numero
	RJMP	PC+5
	LDI		R16,	0B00111110		;3
	OUT		PORTC,	R16
	CBI		PORTD,	7
	RET

	LDI		R16,	0B00000100		;4
	SUB		R16,	R30				;R16 = R16 - R30 (numero de contador)
	IN		R29,	SREG			;R29 = SREG
	SBRC	R29,	1				;Se verifica SREG Z
	;Si Z = 1, entonces el numero es 4 y se configura en los pines correspondientes para el 7 segmentos
	RJMP	PC+2
	;De lo contrario, comprueba el siguiente numero
	RJMP	PC+5
	LDI		R16,	0B00010111		;4
	OUT		PORTC,	R16
	CBI		PORTD,	7
	RET

	LDI		R16,	0B00000101		;5
	SUB		R16,	R30				;R16 = R16 - R30 (numero de contador)
	IN		R29,	SREG			;R29 = SREG
	SBRC	R29,	1				;Se verifica SREG Z
	;Si Z = 1, entonces el numero es 5 y se configura en los pines correspondientes para el 7 segmentos
	RJMP	PC+2
	;De lo contrario, comprueba el siguiente numero
	RJMP	PC+5
	LDI		R16,	0B00111011		;5
	OUT		PORTC,	R16
	CBI		PORTD,	7
	RET

	LDI		R16,	0B00000110		;6
	SUB		R16,	R30				;R16 = R16 - R30 (numero de contador)
	IN		R29,	SREG			;R29 = SREG
	SBRC	R29,	1				;Se verifica SREG Z
	;Si Z = 1, entonces el numero es 6 y se configura en los pines correspondientes para el 7 segmentos
	RJMP	PC+2
	;De lo contrario, comprueba el siguiente numero
	RJMP	PC+5
	LDI		R16,	0B00111011		;6
	OUT		PORTC,	R16
	SBI		PORTD,	7
	RET

	LDI		R16,	0B00000111		;7
	SUB		R16,	R30				;R16 = R16 - R30 (numero de contador)
	IN		R29,	SREG			;R29 = SREG
	SBRC	R29,	1				;Se verifica SREG Z
	;Si Z = 1, entonces el numero es 7 y se configura en los pines correspondientes para el 7 segmentos
	RJMP	PC+2
	;De lo contrario, comprueba el siguiente numero
	RJMP	PC+5
	LDI		R16,	0B00011100		;7
	OUT		PORTC,	R16
	CBI		PORTD,	7
	RET

	LDI		R16,	0B00001000		;8
	SUB		R16,	R30				;R16 = R16 - R30 (numero de contador)
	IN		R29,	SREG			;R29 = SREG
	SBRC	R29,	1				;Se verifica SREG Z
	;Si Z = 1, entonces el numero es 8 y se configura en los pines correspondientes para el 7 segmentos
	RJMP	PC+2
	;De lo contrario, el numero es 9
	RJMP	PC+5
	LDI		R16,	0B00111111		;8
	OUT		PORTC,	R16
	SBI		PORTD,	7
	RET

	LDI		R16,	0B00011111		;9
	OUT		PORTC,	R16
	CBI		PORTD,	7
	RET

loop:
	;Boton RD0
	SBIC	PIND,	0
	CALL	cambio_estado

	;Estado 1 - Mostrar hora
	SBRC	R17,	0
	CALL	hora

	;Estado 2 - Configurar la hora
	SBRC	R17,	1
	CALL	hora_conf

	;Estado 3 - Mostrar y configurar la alarma
	SBRC	R17,	2
	CALL	alarma

	RJMP	loop

cambio_estado:
	ROL		R17
	SBRS	R17,	3
	RJMP	PC+2
	LDI		R17,	0B00000001

	SBIC	PIND,	0
	RJMP	PC-1

	RET

hora:
	LDI		R16,	0B00000000
	OUT		PORTC,	R16
	CBI		PORTD,	7

	CBI		PORTB,	0
	CBI		PORTB,	1
	CBI		PORTB,	2
	CBI		PORTB,	3

	SBI		PORTB,	4
	CBI		PORTB,	5
	CBI		PORTB,	6

	SBIC	PIND,	1
	CALL	ee_write

	SBIC	PIND,	2
	CALL	ee_read

	;Mostrar minutos1
	MOV		R30,	R21
	CALL	table
	SBI		PORTB,	1
	CBI		PORTB,	1
	LDI		R16,	0B00000000
	OUT		PORTC,	R16
	CBI		PORTD,	7

	;Mostrar minutos2
	MOV		R30,	R22
	CALL	table
	SBI		PORTB,	0
	CBI		PORTB,	0
	LDI		R16,	0B00000000
	OUT		PORTC,	R16
	CBI		PORTD,	7

	;Mostrar horas1
	MOV		R30,	R23
	CALL	table
	SBI		PORTB,	2
	CBI		PORTB,	2
	LDI		R16,	0B00000000
	OUT		PORTC,	R16
	CBI		PORTD,	7

	;Mostrar horas2
	MOV		R30,	R24
	CALL	table
	SBI		PORTB,	3
	CBI		PORTB,	3
	LDI		R16,	0B00000000
	OUT		PORTC,	R16
	CBI		PORTD,	7

	RET

ee_write:
	;Se escribe a la memoria EEPROM de la siguiente forma
	;Localidad 0000   -   alamin1 -> R25
	;Localidad 0001   -   alamin2 -> R26
	;Localidad 0002   -   alahor1 -> R27
	;Localidad 0003   -   alahor2 -> R28
	
	;Se deshabilitan las interrupciones del microcontrolador
	CLI

	;Se guardan los valores actuales de la alarma
	LDI		R16,	0B00000000
	OUT		EEARL,	R16
	OUT		EEARH,	R16
	OUT		EEDR,	R25
	SBI		EECR,	EEMPE
	SBI		EECR,	EEPE

	;Se espera a completar la escritura
	SBIC	EECR,	EEPE
	RJMP	PC-1

	LDI		R16,	0B00000001
	OUT		EEARL,	R16
	OUT		EEDR,	R26
	SBI		EECR,	EEMPE
	SBI		EECR,	EEPE

	;Se espera a completar la escritura
	SBIC	EECR,	EEPE
	RJMP	PC-1

	LDI		R16,	0B00000010
	OUT		EEARL,	R16
	OUT		EEDR,	R27
	SBI		EECR,	EEMPE
	SBI		EECR,	EEPE

	;Se espera a completar la escritura
	SBIC	EECR,	EEPE
	RJMP	PC-1

	LDI		R16,	0B00000011
	OUT		EEARL,	R16
	OUT		EEDR,	R28
	SBI		EECR,	EEMPE
	SBI		EECR,	EEPE

	;Se espera a completar la escritura
	SBIC	EECR,	EEPE
	RJMP	PC-1

	;Se rehabilitan las interrupciones
	SEI

	RET

ee_read:
	;Se deshabilitan las interrupciones del microcontrolador
	CLI

	LDI		R16,	0B00000000
	OUT		EEARL,	R16
	OUT		EEARH,	R16
	SBI		EECR,	EERE
	IN		R25,	EEDR

	LDI		R16,	0B00000001
	OUT		EEARL,	R16
	SBI		EECR,	EERE
	IN		R26,	EEDR

	LDI		R16,	0B00000010
	OUT		EEARL,	R16
	SBI		EECR,	EERE
	IN		R27,	EEDR

	LDI		R16,	0B00000011
	OUT		EEARL,	R16
	SBI		EECR,	EERE
	IN		R28,	EEDR

	;Se rehabilitan las interrupciones
	SEI
	
	RET

hora_conf:
	CBI		PORTB,	4
	SBI		PORTB,	5
	CBI		PORTB,	6

	;Incrementar unidades de minutos
	SBIC	PIND,	1
	CALL	min_inc

	;Decrementar unidades de minutos
	SBIC	PIND,	2
	CALL	min_dec

	;Incrementar unidades de horas
	SBIC	PIND,	3
	CALL	hor_inc

	;Decrementar unidades de horas
	SBIC	PIND,	4
	CALL	hor_dec

	LDI		R16,	0B00000000
	OUT		PORTC,	R16
	CBI		PORTD,	7

	CBI		PORTB,	0
	CBI		PORTB,	1
	CBI		PORTB,	2
	CBI		PORTB,	3

	;Mostrar minutos1
	MOV		R30,	R21
	CALL	table
	SBI		PORTB,	1
	CBI		PORTB,	1
	LDI		R16,	0B00000000
	OUT		PORTC,	R16
	CBI		PORTD,	7

	;Mostrar minutos2
	MOV		R30,	R22
	CALL	table
	SBI		PORTB,	0
	CBI		PORTB,	0
	LDI		R16,	0B00000000
	OUT		PORTC,	R16
	CBI		PORTD,	7

	;Mostrar horas1
	MOV		R30,	R23
	CALL	table
	SBI		PORTB,	2
	CBI		PORTB,	2
	LDI		R16,	0B00000000
	OUT		PORTC,	R16
	CBI		PORTD,	7

	;Mostrar horas2
	MOV		R30,	R24
	CALL	table
	SBI		PORTB,	3
	CBI		PORTB,	3
	LDI		R16,	0B00000000
	OUT		PORTC,	R16
	CBI		PORTD,	7

	RET

min_inc:
	SBIC	PIND,	1
	RJMP	PC-1
	INC		R21

	LDI		R16,	0B00001010	;10
	SUB		R16,	R21			;R16 = R16 - R21
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, han pasado 10 minutos
	RJMP	PC+2
	RJMP	PC+3
	LDI		R21,	0B00000000
	INC		R22
	;De lo contrario, revisa las decenas
	LDI		R16,	0B00000110	;6
	SUB		R16,	R22			;R16 = R16 - R22
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, han pasado 60 minutos
	LDI		R22,	0B00000000
	;De lo contrario, retorna
	RET

min_dec:
	SBIC	PIND,	2
	RJMP	PC-1
	DEC		R21

	LDI		R16,	0B11111111	;255
	SUB		R16,	R21			;R16 = R16 - R21
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, minutos1 hizo underflow
	RJMP	PC+2
	;De lo contrario, retorna
	RET
	LDI		R21,	0B00001001	;9

	DEC		R22
	LDI		R16,	0B11111111	;255
	SUB		R16,	R22			;R16 = R16 - R22
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, minutos2 hizo underflow
	RJMP	PC+2
	;De lo contrario, retorna
	RET
	LDI		R21,	0B00001001	;9
	LDI		R22,	0B00000101	;5
	RET

hor_inc:
	SBIC	PIND,	3
	RJMP	PC-1
	INC		R23

	LDI		R16,	0B00001010	;10
	SUB		R16,	R23			;R16 = R16 - R23
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, han pasado 10 horas
	RJMP	PC+2
	RJMP	PC+3
	LDI		R23,	0B00000000
	INC		R24
	;De lo contrario, revisa las decenas
	LDI		R16,	0B00000010	;2
	SUB		R16,	R24			;R16 = R16 - R24
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, han pasado 20 horas
	RJMP	PC+2
	;De lo contrario, retorna
	RET
	LDI		R16,	0B00000100	;4
	SUB		R16,	R23			;R16 = R16 - R23
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion es 0, han pasado las 24 horas
	RJMP	PC+2
	;De lo contrario, retorna
	RET
	LDI		R23,	0B00000000
	LDI		R24,	0B00000000
	RET

hor_dec:
	SBIC	PIND,	4
	RJMP	PC-1
	DEC		R23

	LDI		R16,	0B11111111
	SUB		R16,	R23			;R16 = R16 - R23
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, horas1 hizo underflow
	RJMP	PC+2
	;De lo contrario, retorna
	RET
	LDI		R23,	0B00001001	;9

	DEC		R24
	LDI		R16,	0B11111111
	SUB		R16,	R24			;R16 = R16 - R24
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, horas2 hizo underflow
	RJMP	PC+2
	;De lo contrario, retorna
	RET
	LDI		R23,	0B00000011	;3
	LDI		R24,	0B00000010	;2
	RET

alarma:
	CBI		PORTB,	4
	CBI		PORTB,	5
	SBI		PORTB,	6

	;Incrementar unidades de minutos en alarma
	SBIC	PIND,	1
	CALL	alamin_inc

	;Decrementar unidades de minutos en alarma
	SBIC	PIND,	2
	CALL	alamin_dec

	;Incrementar unidades de horas en alarma
	SBIC	PIND,	3
	CALL	alahor_inc

	;Decrementar unidades de horas en alarma
	SBIC	PIND,	4
	CALL	alahor_dec

	LDI		R16,	0B00000000
	OUT		PORTC,	R16
	CBI		PORTD,	7

	CBI		PORTB,	0
	CBI		PORTB,	1
	CBI		PORTB,	2
	CBI		PORTB,	3

	;Mostrar alamin1
	MOV		R30,	R25
	CALL	table
	SBI		PORTB,	1
	CBI		PORTB,	1
	LDI		R16,	0B00000000
	OUT		PORTC,	R16
	CBI		PORTD,	7

	;Mostrar alamin2
	MOV		R30,	R26
	CALL	table
	SBI		PORTB,	0
	CBI		PORTB,	0
	LDI		R16,	0B00000000
	OUT		PORTC,	R16
	CBI		PORTD,	7

	;Mostrar alahor1
	MOV		R30,	R27
	CALL	table
	SBI		PORTB,	2
	CBI		PORTB,	2
	LDI		R16,	0B00000000
	OUT		PORTC,	R16
	CBI		PORTD,	7

	;Mostrar alahor2
	MOV		R30,	R28
	CALL	table
	SBI		PORTB,	3
	CBI		PORTB,	3
	LDI		R16,	0B00000000
	OUT		PORTC,	R16
	CBI		PORTD,	7

	RET

alamin_inc:
	SBIC	PIND,	1
	RJMP	PC-1
	INC		R25

	LDI		R16,	0B00001010	;10
	SUB		R16,	R25			;R16 = R16 - R25
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, han pasado 10 minutos
	RJMP	PC+2
	RJMP	PC+3
	LDI		R25,	0B00000000
	INC		R26
	;De lo contrario, revisa las decenas
	LDI		R16,	0B00000110	;6
	SUB		R16,	R26			;R16 = R16 - R26
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, han pasado 60 minutos
	LDI		R26,	0B00000000
	;De lo contrario, retorna
	RET

alamin_dec:
	SBIC	PIND,	2
	RJMP	PC-1
	DEC		R25

	LDI		R16,	0B11111111	;255
	SUB		R16,	R25			;R16 = R16 - R25
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, alamin1 hizo underflow
	RJMP	PC+2
	;De lo contrario, retorna
	RET
	LDI		R25,	0B00001001	;9

	DEC		R26
	LDI		R16,	0B11111111	;255
	SUB		R16,	R26			;R16 = R16 - R26
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, alamin2 hizo underflow
	RJMP	PC+2
	;De lo contrario, retorna
	RET
	LDI		R25,	0B00001001	;9
	LDI		R26,	0B00000101	;5
	RET

alahor_inc:
	SBIC	PIND,	3
	RJMP	PC-1
	INC		R27

	LDI		R16,	0B00001010	;10
	SUB		R16,	R27			;R16 = R16 - R27
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, han pasado 10 horas
	RJMP	PC+2
	RJMP	PC+3
	LDI		R27,	0B00000000
	INC		R28
	;De lo contrario, revisa las decenas
	LDI		R16,	0B00000010	;2
	SUB		R16,	R28			;R16 = R16 - R28
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, han pasado 20 horas
	RJMP	PC+2
	;De lo contrario, retorna
	RET
	LDI		R16,	0B00000100	;4
	SUB		R16,	R27			;R16 = R16 - R27
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion es 0, han pasado las 24 horas
	RJMP	PC+2
	;De lo contrario, retorna
	RET
	LDI		R27,	0B00000000
	LDI		R28,	0B00000000
	RET

alahor_dec:
	SBIC	PIND,	4
	RJMP	PC-1
	DEC		R27

	LDI		R16,	0B11111111
	SUB		R16,	R27			;R16 = R16 - R27
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, alahor1 hizo underflow
	RJMP	PC+2
	;De lo contrario, retorna
	RET
	LDI		R27,	0B00001001	;9

	DEC		R28
	LDI		R16,	0B11111111
	SUB		R16,	R28			;R16 = R16 - R28
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, alahor2 hizo underflow
	RJMP	PC+2
	;De lo contrario, retorna
	RET
	LDI		R27,	0B00000011	;3
	LDI		R28,	0B00000010	;2
	RET

tmr0_isr:
	MOV		R16,	R25			;R16 = R25
	SUB		R16,	R21			;R16 = R16 - R21
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, se verifica otro contador
	RJMP	PC+2
	;De lo contrario, no se comprueban mas contadores
	RJMP	PC+21

	MOV		R16,	R26			;R16 = R26
	SUB		R16,	R22			;R16 = R16 - R22
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, se verifica otro contador
	RJMP	PC+2
	;De lo contrario, no se comprueban mas contadores
	RJMP	PC+15

	MOV		R16,	R27			;R16 = R27
	SUB		R16,	R23			;R16 = R16 - R23
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, se verifica otro contador
	RJMP	PC+2
	;De lo contrario, no se comprueban mas contadores
	RJMP	PC+9

	MOV		R16,	R28			;R16 = R28
	SUB		R16,	R24			;R16 = R16 - R24
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, se enciende la alarma
	RJMP	PC+2
	;De lo contrario, se sigue con la interrupcion de forma normal
	RJMP	PC+3
	SBI		PORTB,	7
	RJMP	PC+2
	CBI		PORTB,	7



	INC		R18					;Incrementar R18
	LDI		R16,	0B01010100	;84
	;LDI		R16,	0B00000110	;6
	SUB		R16,	R18			;R16 = R16 - R18
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, ha pasado un segundo
	RJMP	PC+2
	;De lo contrario, termina la interrupcion
	RJMP	PC+57

	CLR		R18
	INC		R19
	LDI		R16,	0B00001010	;10
	SUB		R16,	R19			;R16 = R16 - R19
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, han pasado 10 segundos
	RJMP	PC+2
	;De lo contrario, termina la interrupcion
	RJMP	PC+49

	CLR		R19
	INC		R20
	LDI		R16,	0B00000110	;6
	SUB		R16,	R20			;R16 = R16 - R20
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, han pasado 6 veces 10 segundos (60 segundos)
	RJMP	PC+2
	;De lo contrario, termina la interrupcion
	RJMP	PC+41

	CLR		R20
	INC		R21
	LDI		R16,	0B00001010	;10
	SUB		R16,	R21			;R16 = R16 - R21
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, han pasado 10 minutos
	RJMP	PC+2
	;De lo contrario, termina la interrupcion
	RJMP	PC+33

	CLR		R21
	INC		R22
	LDI		R16,	0B00000110	;6
	SUB		R16,	R22			;R16 = R16 - R22
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, han pasado 6 veces 10 minutos (60 minutos)
	RJMP	PC+2
	;De lo contrario, termina la interrupcion
	RJMP	PC+25

	CLR		R22
	INC		R23
	LDI		R16,	0B00001010	;10
	SUB		R16,	R23			;R16 = R16 - R23
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, han pasado 10 horas
	RJMP	PC+2
	;De lo contrario, verifica las horas del dia
	RJMP	PC+3

	CLR		R23
	;Aumentar las decenas de horas
	INC		R24

	;En este caso se comprobara que horas2 sea 2 y que horas1 sea 4 para formar las 24 horas de un dia

	LDI		R16,	0B00000010	;2
	SUB		R16,	R24			;R16 = R16 - R24
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, han pasado al menos 20 horas
	RJMP	PC+2
	;De lo contrario se omite la siguiente comprobacion
	RJMP	PC+9

	LDI		R16,	0B00000100	;4
	SUB		R16,	R23			;R16  = R16 - R23
	IN		R29,	SREG		;R29 = SREG
	SBRC	R29,	1			;Se verifica SREG Z
	;Si la operacion anterior es 0, han pasado 4 horas después de las 20 horas anteriores (24 horas en total)
	RJMP	PC+2
	;De lo contrario, termina la interrupcion
	RJMP	PC+3

	LDI		R24,	0B00000000
	LDI		R23,	0B00000000

	LDI		R16,	0B10100011		;Se mueve 163 a R16
	OUT		TCNT0,	R16
					
	RETI