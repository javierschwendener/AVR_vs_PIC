;////////////////
; PROYECTO RELOJ
;////////////////

PROCESSOR 16F887
    
// config statements should precede project file includes.
#include <xc.inc>
    
; PIC16F887 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FOSC	= INTRC_CLKOUT	    ; Oscillator Selection bits (INTOSC oscillator: CLKOUT function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
  CONFIG  WDTE	= OFF		    ; Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
  CONFIG  PWRTE	= OFF		    ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE	= OFF		    ; RE3/MCLR pin function select bit (RE3/MCLR pin function is digital input, MCLR internally tied to VDD)
  CONFIG  CP	= OFF		    ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  CPD	= OFF		    ; Data Code Protection bit (Data memory code protection is disabled)
  CONFIG  BOREN	= OFF		    ; Brown Out Reset Selection bits (BOR disabled)
  CONFIG  IESO	= OFF		    ; Internal External Switchover bit (Internal/External Switchover mode is disabled)
  CONFIG  FCMEN	= OFF		    ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
  CONFIG  LVP	= OFF		    ; Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

; CONFIG2
  CONFIG  BOR4V	= BOR40V	    ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
  CONFIG  WRT	= OFF		    ; Flash Program Memory Self Write Enable bits (Write protection off)
  
; Declaracion de variables
  PSECT	udata
    
  s_temp:
    DS 1
    
  w_temp:
    DS 1
    
  estado:
    DS 1
    
  contador1:
    DS 1
    
  segundos1:
    DS 1
    
  segundos2:
    DS 1
    
  minutos1:
    DS 1
    
  minutos2:
    DS 1
    
  horas1:
    DS 1
    
  horas2:
    DS 1
    
  alamin1:
    DS 1
    
  alamin2:
    DS 1
    
  alahor1:
    DS 1
  
  alahor2:
    DS 1
  
; Vector RESET
  PSECT code, delta = 2, abs
  ORG 0x0000
    resetVector:
	GOTO setup
	
; Vector INTERRUPCION
  PSECT code, class = CODE, delta = 2
  ORG 0x0004
    SAVE:
	MOVWF   w_temp
        SWAPF   STATUS, W
	MOVWF   s_temp
    INTERRUPT:
	MOVF	alamin1,    0	;Mover alamin1 a W
	SUBWF	minutos1,   0	;Se guarda alamin1 - minutos1 en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, se verifica otro contador
	GOTO	$+2
	;De lo contrario, no se comprueban mas contadores
	GOTO	$+18
	MOVF	alamin2,    0	;Mover alamin2 a W
	SUBWF	minutos2,   0	;Se guarda alamin2 - minutos2 en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, se verifica otro contador
	GOTO	$+2
	;De lo contrario, no se comprueban mas contadores
	GOTO	$+13
	MOVF	alahor1,    0	;Mover alahor1 a W
	SUBWF	horas1,	    0	;Se guarda alahor1 - horas1 en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, se verifica otro contador
	GOTO	$+2
	;De lo contrario, no se comprueban mas contadores
	GOTO	$+8
	MOVF	alahor2,    0	;Moveralahor2 a W
	SUBWF	horas2,	    0	;Se guarda alahor2 - horas2 en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, se enciende la alarma
	GOTO	$+2
	;De lo contrario, se sigue con la interrupcion de forma normal
	GOTO	$+3
	BSF	PORTB,	    3
	GOTO	$+2
	
	BCF	PORTB,	    3
	;Aumentar primer contador para crear los segundos
	INCF	contador1
	MOVLW	0B01010100	;84
	;MOVLW	0B00000010
	SUBWF	contador1,  0	;Se guarda contador1 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, ha pasado un segundo
	GOTO	$+2
	;De lo contrario, termina la interrupcion
	GOTO	$+50
	
	CLRF	contador1
	;Aumentar las unidades de segundos
	INCF	segundos1
	MOVLW	0B00001010	;10
	SUBWF	segundos1,  0	;Se guarda segundos1 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, han pasado 10 segundos
	GOTO	$+2
	;De lo contrario termina la interrupcion
	GOTO	$+43
	
	CLRF	segundos1
	;Aumentar las decenas de segundos
	INCF	segundos2
	MOVLW	0B00000110	;6
	SUBWF	segundos2,  0	;Se guarda segundos2 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, han pasado 6 veces 10 segundos (60 segundos)
	GOTO	$+2
	;De lo contrario termina la interrupcion
	GOTO	$+36
	
	CLRF	segundos2
	;Aumentar las unidades de minutos
	INCF	minutos1
	MOVLW	0B00001010	;10
	SUBWF	minutos1,   0	;Se guarda minutos1 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, han pasado 10 minutos
	GOTO	$+2
	;De lo contrario termina la interrupcion
	GOTO	$+29
	
	CLRF	minutos1
	;Aumentar las decenas de minutos
	INCF	minutos2
	MOVLW	0B00000110	;6
	SUBWF	minutos2,   0	;Se guarda minutos2 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, han pasado 6 veces 10 minutos (60 minutos)
	GOTO	$+2
	;De lo contrario termina la interrupcion
	GOTO	$+22
	
	CLRF	minutos2
	;Aumentar las unidades de horas
	INCF	horas1
	MOVLW	0B00001010	;10
	SUBWF	horas1,	    0	;Se guarda horas1 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, han pasado 10 horas
	GOTO	$+2
	;De lo contrario verifica las horas del dia
	GOTO	$+3
	
	CLRF	horas1
	;Aumentar las decenas de horas
	INCF	horas2
	
	;En este caso se comprobara que horas2 sea 2 y que horas1 sea 4 para
	;formar las 24 horas de un dia
	
	MOVLW	0B00000010	;2
	SUBWF	horas2,	    0	;Se guarda horas2 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion anterior es 0, han pasado al menos 20 horas
	GOTO	$+2
	;De lo contrario se omite la siguiente comprobacion
	GOTO	$+8
	MOVLW	0B00000100	;4
	SUBWF	horas1,	    0	;Se guarda horas1 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion anterior es 0, han pasado 4 horas despues de
	;las 20 horas anteriores (24 horas en total)
	GOTO	$+2
	;De lo contrario termina la interrupcion
	GOTO	$+3
	
	CLRF	horas2
	CLRF	horas1
	
	BCF	INTCON, 2	;Se limpia la bandera de interrupcion del Timer0
	MOVLW	0B10100011	;Se mueve 163 a W
	MOVWF	TMR0		;Se mueve 163 al temporizador 0
	
    LOAD:
	SWAPF   s_temp, W
	MOVWF   STATUS
	SWAPF   w_temp, F
	SWAPF   w_temp, W
	RETFIE
    
; Setup
  PSECT code, class = CODE, delta = 2
  ORG 0x0090
    
    setup:
	;Configuracion inicial
	BANKSEL	ANSEL
	CLRF	ANSEL
	CLRF	ANSELH
	BANKSEL	OSCCON
	BSF	OSCCON,	4
	BSF	OSCCON,	5	;Se establece la frecuencia del PIC como 8MHz
	BSF	OSCCON,	6
	
	;Configuracion de temporizador
	MOVLW	0B10100000	    ;Se habilitan las interrupciones del PIC
	MOVWF	INTCON		    ;y la interrupcion del Timer0
	MOVLW	0B11000000	    ;Mascara
	ANDWF	OPTION_REG, 0	    ;Se guardan dos bits de OPTION_REG
	;IORLW	0B00000111	    ;Se establece la configuracion en W
	IORLW	0B00000100
	MOVWF	OPTION_REG	    ;Se mueve a OPTION_REG
	BCF	INTCON,	2
	
	;Configuracion de puertos
	BANKSEL TRISA
	MOVLW	0B00011111	;Botones en A0, A1, A2, A3 y A4
	MOVWF	TRISA
	CLRF	TRISB
	CLRF	TRISC
	CLRF	TRISD
	BANKSEL	PORTA
	CLRF	PORTA
	CLRF	PORTB
	CLRF	PORTC
	CLRF	PORTD
	
	;Inicio del temporizador con el numero deseado
	MOVLW	0B10100011	;Se mueve 163 a W
	MOVWF	TMR0		;Se mueve 163 al temporizador 0
	
	;Limpiar variables
	BANKSEL	w_temp
	CLRF	w_temp
	CLRF	s_temp
	CLRF	contador1
	CLRF	segundos1
	CLRF	segundos2
	CLRF	minutos1
	CLRF	minutos2
	CLRF	horas1
	CLRF	horas2
	CLRF	alamin1
	CLRF	alamin2
	CLRF	alahor1
	CLRF	alahor2
	
	MOVLW	0B00000001
	MOVWF	estado
	
	BANKSEL	PORTA
	
	GOTO	loop
	
    table:
	ADDWF	PCL,	1	;Suma W al PCL
	RETLW	0B11011110	;0
	RETLW	0B01000010	;1
	RETLW	0B11101100	;2
	RETLW	0B11101010	;3
	RETLW	0B01110010	;4
	RETLW	0B10111010	;5
	RETLW	0B10111110	;6
	RETLW	0B11000010	;7
	RETLW	0B11111110	;8
	RETLW	0B11110010	;9

; Main code
    loop:
	;Boton RA0
	BTFSC	PORTA,	0
	CALL	cambio_estado
	
	;Estado 1 - mostrar la hora
	BTFSC	estado,	0
	CALL	hora
	
	;Estado 2 - configurar la hora
	BTFSC	estado,	1
	CALL	hora_conf
	
	;Estado 3 - mostrar y configurar la alarma
	BTFSC	estado,	2
	CALL	alarma
	
	GOTO	loop
	
    cambio_estado:
	RLF	estado
	BTFSS	estado,	3
	GOTO	$+3
	MOVLW	0B00000001
	MOVWF	estado
	
	BTFSC	PORTA,	0
	GOTO	$-1
	
	RETURN
	
    hora:
	BSF	PORTB,	    0
	BCF	PORTB,	    1
	BCF	PORTB,	    2
	
	BTFSC	PORTA,	    1
	CALL	ee_write
	
	BTFSC	PORTA,	    2
	CALL	ee_read
    
	BSF	PORTD,	    0	;Encender RD0
	MOVF	minutos1,   0	;Mover segundos1 a W
	CALL	table
	MOVWF	PORTC
	CLRF	PORTD
	CLRF	PORTC
	
	BSF	PORTD,	    1	;Encender RD1
	MOVF	minutos2,   0	;Mover segundos2 a W
	CALL	table
	MOVWF	PORTC
	CLRF	PORTD
	CLRF	PORTC
	
	BSF	PORTD,	    2	;Encender RD2
	MOVF	horas1,	    0	;Mover minutos1 a W
	CALL	table
	MOVWF	PORTC
	CLRF	PORTD
	CLRF	PORTC
	
	BSF	PORTD,	    3	;Encender RD3
	MOVF	horas2,	    0	;Mover minutos2 a W
	CALL	table
	MOVWF	PORTC
	CLRF	PORTD
	CLRF	PORTC
	
	RETURN
	
    ee_write:
	;Se escribe a la memoria EEPROM de la siguiente forma
	;Localidad 0000   -   alamin1
	;Localidad 0001   -   alamin2
	;Localidad 0002   -   alahor1
	;Localidad 0003   -   alahor2
	BCF	INTCON,	    7	    ;Deshabilitar interrupciones
	;Guardar los valores actuales de la alarma
	BANKSEL	alamin1
	MOVF	alamin1,    0	    ;W = alamin1
	BANKSEL	EEDATA
	MOVWF	EEDATA		    ;EEDATA = alamin1
	MOVLW	0B00000000	    ;W = 0
	MOVWF	EEADR		    ;EEADR = 0
	BANKSEL	EECON1
	BCF	EECON1,	    7	    ;Para data memory
	BSF	EECON1,	    2	    ;WREN = 1
	
	MOVLW	0B01010101	    ;0x55 obligatorio
	MOVWF	EECON2
	MOVLW	0B10101010	    ;0xAA obligatorio
	MOVWF	EECON2
	
	BSF	EECON1,	    1	    ;Inicia la escritura
	
	BTFSC	EECON1,	    1
	GOTO	$-1		    ;Espera a que termine la escritura
	
	BANKSEL	alamin2
	
	MOVF	alamin2,    0	    ;W = alamin2
	BANKSEL	EEDATA
	MOVWF	EEDATA		    ;EEDATA = alamin2
	MOVLW	0B00000001	    ;W = 1
	MOVWF	EEADR		    ;EEADR = 1
	BANKSEL	EECON1
	BCF	EECON1,	    7	    ;Para data memory
	
	MOVLW	0B01010101	    ;0x55 obligatorio
	MOVWF	EECON2
	MOVLW	0B10101010	    ;0xAA obligatorio
	MOVWF	EECON2
	
	BSF	EECON1,	    1	    ;Inicia la escritura
	
	BTFSC	EECON1,	    1
	GOTO	$-1		    ;Espera a que termine la escritura
	
	BANKSEL	alahor1
	
	MOVF	alahor1,    0	    ;W = alahor1
	BANKSEL	EEDATA
	MOVWF	EEDATA		    ;EEDATA = alahor1
	MOVLW	0B00000010	    ;W = 2
	MOVWF	EEADR		    ;EEADR = 2
	BANKSEL	EECON1
	BCF	EECON1,	    7	    ;Para data memory
	
	MOVLW	0B01010101	    ;0x55 obligatorio
	MOVWF	EECON2
	MOVLW	0B10101010	    ;0xAA obligatorio
	MOVWF	EECON2
	
	BSF	EECON1,	    1	    ;Inicia la escritura
	
	BTFSC	EECON1,	    1
	GOTO	$-1		    ;Espera a que termine la escritura
	
	BANKSEL	alahor2
	
	MOVF	alahor2,    0	    ;W = alahor2
	BANKSEL	EEDATA
	MOVWF	EEDATA		    ;EEDATA = alahor2
	MOVLW	0B00000011	    ;W = 3
	MOVWF	EEADR		    ;EEADR = 3
	BANKSEL	EECON1
	BCF	EECON1,	    7	    ;Para data memory
	
	MOVLW	0B01010101	    ;0x55 obligatorio
	MOVWF	EECON2
	MOVLW	0B10101010	    ;0xAA obligatorio
	MOVWF	EECON2
	
	BSF	EECON1,	    1	    ;Inicia la escritura
	
	BTFSC	EECON1,	    1
	GOTO	$-1		    ;Espera a que termine la escritura
	
	BCF	EECON1,	    2	    ;WREN = 0
	BANKSEL	alamin1
	BSF	INTCON,	    7	    ;Habilitar interrupciones
	
	RETURN
	
    ee_read:
	BCF	INTCON,	    7	    ;Deshabilitar interrupciones
	
	BANKSEL	EEADR
	MOVLW	0B00000000	    ;W = 0
	MOVWF	EEADR		    ;EEADR = 0
	BANKSEL	EECON1
	BCF	EECON1,	    7	    ;Para data memory
	BSF	EECON1,	    0	    ;Inicia la lectura
	BANKSEL	EEDATA
	MOVF	EEDATA,	    0	    ;W = EEDATA
	BANKSEL	alamin1
	MOVWF	alamin1
	
	BANKSEL	EEADR
	MOVLW	0B00000001	    ;W = 1
	MOVWF	EEADR		    ;EEADR = 1
	BANKSEL	EECON1
	BCF	EECON1,	    7	    ;Para data memory
	BSF	EECON1,	    0	    ;Inicia la lectura
	BANKSEL	EEDATA
	MOVF	EEDATA,	    0	    ;W = EEDATA
	BANKSEL	alamin2
	MOVWF	alamin2
	
	BANKSEL	EEADR
	MOVLW	0B00000010	    ;W = 2
	MOVWF	EEADR		    ;EEADR = 2
	BANKSEL	EECON1
	BCF	EECON1,	    7	    ;Para data memory
	BSF	EECON1,	    0	    ;Inicia la lectura
	BANKSEL	EEDATA
	MOVF	EEDATA,	    0	    ;W = EEDATA
	BANKSEL	alahor1
	MOVWF	alahor1
	
	BANKSEL	EEADR
	MOVLW	0B00000011	    ;W = 3
	MOVWF	EEADR		    ;EEADR = 3
	BANKSEL	EECON1
	BCF	EECON1,	    7	    ;Para data memory
	BSF	EECON1,	    0	    ;Inicia la lectura
	BANKSEL	EEDATA
	MOVF	EEDATA,	    0	    ;W = EEDATA
	BANKSEL	alahor2
	MOVWF	alahor2
	
	BSF	INTCON,	    7	    ;Habilitar interrupciones
	RETURN
    
    hora_conf:
	BCF	PORTB,	    0
	BSF	PORTB,	    1
	BCF	PORTB,	    2
	;Incrementar unidades de minutos
	BTFSC	PORTA,	    1
	CALL	min_inc
	;Decrementar unidades de minutos
	BTFSC	PORTA,	    2
	CALL	min_dec
	;Incrementar unidades de horas
	BTFSC	PORTA,	    3
	CALL	hor_inc
	;Decrementar unidades de horas
	BTFSC	PORTA,	    4
	CALL	hor_dec
    
	BSF	PORTD,	    0	;Encender RD0
	MOVF	minutos1,   0	;Mover segundos1 a W
	CALL	table
	MOVWF	PORTC
	CLRF	PORTD
	CLRF	PORTC
	
	BSF	PORTD,	    1	;Encender RD1
	MOVF	minutos2,   0	;Mover segundos2 a W
	CALL	table
	MOVWF	PORTC
	CLRF	PORTD
	CLRF	PORTC
	
	BSF	PORTD,	    2	;Encender RD2
	MOVF	horas1,	    0	;Mover minutos1 a W
	CALL	table
	MOVWF	PORTC
	CLRF	PORTD
	CLRF	PORTC
	
	BSF	PORTD,	    3	;Encender RD3
	MOVF	horas2,	    0	;Mover minutos2 a W
	CALL	table
	MOVWF	PORTC
	CLRF	PORTD
	CLRF	PORTC
	RETURN
	
    min_inc:
	BTFSC	PORTA,	    1
	GOTO	$-1
	INCF	minutos1
	
	MOVLW	0B00001010	;10
	SUBWF	minutos1,   0	;Se guarda minutos1 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, han pasado 10 minutos
	GOTO	$+2
	GOTO	$+3
	CLRF	minutos1
	INCF	minutos2
	;De lo contrario, revisa las decenas
	MOVLW	0B00000110	;6
	SUBWF	minutos2,   0	;Se guarda minutos2 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, han pasado 60 minutos
	CLRF	minutos2
	;De lo contrario, retorna
	RETURN
	
    min_dec:
	BTFSC	PORTA,	    2
	GOTO	$-1
	DECF	minutos1
	
	MOVLW	0B11111111	;255
	SUBWF	minutos1,   0	;Se guarda minutos1 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, minutos1 hizo underflow
	GOTO	$+2
	;De lo contrario, retorna
	GOTO	$+13
	MOVLW	0B00001001	;9
	MOVWF	minutos1
	
	DECF	minutos2
	MOVLW	0B11111111	;255
	SUBWF	minutos2,   0	;Se guarda minutos2 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, minutos2 hizo underflow
	GOTO	$+2
	;De lo contrario, retorna
	GOTO	$+5
	MOVLW	0B00001001
	MOVWF	minutos1
	MOVLW	0B00000101
	MOVWF	minutos2
	RETURN
	
    hor_inc:
	BTFSC	PORTA,	    3
	GOTO	$-1
	INCF	horas1
	
	MOVLW	0B00001010	;10
	SUBWF	horas1,   0	;Se guarda horas1 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, han pasado 10 horas
	GOTO	$+2
	GOTO	$+3
	CLRF	horas1
	INCF	horas2
	;De lo contrario, revisa las decenas
	MOVLW	0B00000010	;2
	SUBWF	horas2,	    0	;Se guarda horas2 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, han pasado 20 horas
	GOTO	$+2
	;De lo contrario, retorna
	GOTO	$+8
	MOVLW	0B00000100	;4
	SUBWF	horas1,	    0	;Se guarda horas1 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, han pasado las 24 horas
	GOTO	$+2
	;De lo contrario, retorna
	GOTO	$+3
	CLRF	horas1
	CLRF	horas2
	
	RETURN
	
    hor_dec:
	BTFSC	PORTA,	    4
	GOTO	$-1
	DECF	horas1
	
	MOVLW	0B11111111	;255
	SUBWF	horas1,	    0	;Se guarda horas1 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, horas1 hizo underflow
	GOTO	$+2
	;De lo contrario, retorna
	GOTO	$+13
	MOVLW	0B00001001	;9
	MOVWF	horas1
	
	DECF	horas2
	MOVLW	0B11111111	;255
	SUBWF	horas2,	    0	;Se guarda horas2 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, horas2 hizo underflow
	GOTO	$+2
	;De lo contrario, retorna
	GOTO	$+5
	MOVLW	0B00000011	;3
	MOVWF	horas1
	MOVLW	0B00000010	;2
	MOVWF	horas2
	
	RETURN

    alarma:
	BCF	PORTB,	    0
	BCF	PORTB,	    1
	BSF	PORTB,	    2
	;Incrementar unidades de minutos
	BTFSC	PORTA,	    1
	CALL	alamin_inc
	;Decrementar unidades de minutos
	BTFSC	PORTA,	    2
	CALL	alamin_dec
	;Incrementar unidades de horas
	BTFSC	PORTA,	    3
	CALL	alahor_inc
	;Decrementar unidades de horas
	BTFSC	PORTA,	    4
	CALL	alahor_dec
    
	BSF	PORTD,	    0	;Encender RD0
	MOVF	alamin1,    0	;Mover alamin1 a W
	CALL	table
	MOVWF	PORTC
	CLRF	PORTD
	CLRF	PORTC
	
	BSF	PORTD,	    1	;Encender RD1
	MOVF	alamin2,    0	;Mover alamin2 a W
	CALL	table
	MOVWF	PORTC
	CLRF	PORTD
	CLRF	PORTC
	
	BSF	PORTD,	    2	;Encender RD2
	MOVF	alahor1,    0	;Mover alahor1 a W
	CALL	table
	MOVWF	PORTC
	CLRF	PORTD
	CLRF	PORTC
	
	BSF	PORTD,	    3	;Encender RD3
	MOVF	alahor2,    0	;Mover alahor2 a W
	CALL	table
	MOVWF	PORTC
	CLRF	PORTD
	CLRF	PORTC
	RETURN
	
    alamin_inc:
	BTFSC	PORTA,	    1
	GOTO	$-1
	INCF	alamin1
	
	MOVLW	0B00001010	;10
	SUBWF	alamin1,    0	;Se guarda alamin1 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, han pasado 10 minutos
	GOTO	$+2
	GOTO	$+3
	CLRF	alamin1
	INCF	alamin2
	;De lo contrario, revisa las decenas
	MOVLW	0B00000110	;6
	SUBWF	alamin2,    0	;Se guarda alamin2 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, han pasado 60 minutos
	CLRF	alamin2
	;De lo contrario, retorna
	RETURN
	
    alamin_dec:
	BTFSC	PORTA,	    2
	GOTO	$-1
	DECF	alamin1
	
	MOVLW	0B11111111	;255
	SUBWF	alamin1,    0	;Se guarda alamin1 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, alamin1 hizo underflow
	GOTO	$+2
	;De lo contrario, retorna
	GOTO	$+13
	MOVLW	0B00001001	;9
	MOVWF	alamin1
	
	DECF	alamin2
	MOVLW	0B11111111	;255
	SUBWF	alamin2,    0	;Se guarda alamin2 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, alamin2 hizo underflow
	GOTO	$+2
	;De lo contrario, retorna
	GOTO	$+5
	MOVLW	0B00001001
	MOVWF	alamin1
	MOVLW	0B00000101
	MOVWF	alamin2
	RETURN
	
    alahor_inc:
	BTFSC	PORTA,	    3
	GOTO	$-1
	INCF	alahor1
	
	MOVLW	0B00001010	;10
	SUBWF	alahor1,    0	;Se guarda alahor1 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, han pasado 10 horas
	GOTO	$+2
	GOTO	$+3
	CLRF	alahor1
	INCF	alahor2
	;De lo contrario, revisa las decenas
	MOVLW	0B00000010	;2
	SUBWF	alahor2,    0	;Se guarda alahor2 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, han pasado 20 horas
	GOTO	$+2
	;De lo contrario, retorna
	GOTO	$+8
	MOVLW	0B00000100	;4
	SUBWF	alahor1,    0	;Se guarda alahor1 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, han pasado las 24 horas
	GOTO	$+2
	;De lo contrario, retorna
	GOTO	$+3
	CLRF	alahor1
	CLRF	alahor2
	
	RETURN
	
    alahor_dec:
	BTFSC	PORTA,	    4
	GOTO	$-1
	DECF	alahor1
	
	MOVLW	0B11111111	;255
	SUBWF	alahor1,    0	;Se guarda alahor1 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, alahor1 hizo underflow
	GOTO	$+2
	;De lo contrario, retorna
	GOTO	$+13
	MOVLW	0B00001001	;9
	MOVWF	alahor1
	
	DECF	alahor2
	MOVLW	0B11111111	;255
	SUBWF	alahor2,    0	;Se guarda alahor2 - W en W
	BTFSC	STATUS,	    2	;Operacion anterior = 0
	;Si la operacion es 0, alahor2 hizo underflow
	GOTO	$+2
	;De lo contrario, retorna
	GOTO	$+5
	MOVLW	0B00000011	;3
	MOVWF	alahor1
	MOVLW	0B00000010	;2
	MOVWF	alahor2
	
	RETURN
	
    END