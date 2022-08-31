;//////////////////////////////////////////
; ENTRADAS Y SALIDAS CON PUERTO SIMPLE ASM
;//////////////////////////////////////////

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
  CONFIG  BOR4V	= BOR40V        ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
  CONFIG  WRT	= OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

// config statements should precede project file includes.
#include <xc.inc>
  
; Declaracion de variables
  PSECT	udata

  INFNIBBLE:
    DS 1
    
  SUPNIBBLE:
    DS 1
  
; Vector RESET
  PSECT code, delta = 2, abs
  ORG 0x0000
  resetVector:
    goto setup
    
; Setup
  PSECT code, delta = 2, abs
  ORG 0x000A
    setup:
	BANKSEL	ANSEL
	CLRF	ANSEL
	CLRF	ANSELH
	BANKSEL	OSCCON
	BSF	OSCCON,	4
	BSF	OSCCON,	5
	BSF	OSCCON,	6
	BANKSEL	TRISA
	CLRF	TRISA
	CLRF	TRISB
	CLRF	TRISD
	MOVLW	0b00011111
	MOVWF	TRISA	    ;A0, A1, A2, A3 y A4 como entradas
	BANKSEL	PORTA
	CLRF	PORTA
	CLRF	PORTB
	CLRF	PORTD
	CLRF	INFNIBBLE
	CLRF	SUPNIBBLE
	goto	loop   


; Main code
    loop:
	;Si se prende A0, aumentar el contador 1
	BTFSC	PORTA,	0
	CALL	suma1
	
	;Si se prende A1, decrementar el contador 1
	BTFSC	PORTA,	1
	CALL	resta1
	
	;Si se prende A2, aumentar el contador 2
	BTFSC	PORTA,	2
	CALL	suma2
	
	;Si se prende A3, decrementar el contador 2
	BTFSC	PORTA,	3
	CALL	resta2
	
	;Se mueven los resultados en el puerto D
	MOVLW	0B00001111	;(mascara)
	ANDWF	INFNIBBLE,  0	;AND INFNIBBLE & W, se guarda en W
	IORWF	SUPNIBBLE,  0	;OR SUPNIBBLE & W, se guarda en W
	MOVWF	PORTD
	
	;Si se prende A4, sumar ambos contadores
	BTFSC	PORTA,	4
	CALL	resultado
	
	GOTO	loop

    suma1:
	;Antirebote
	BTFSC	PORTA,	0
	GOTO	$-1
	CALL	nops
	MOVLW	0B00001111	;Se carga 15 al registro W
	SUBWF	INFNIBBLE,  0	;Se resta INFNIBBLE - W, guarda en W
	BTFSC	STATUS,	2	;Revisa STATUS Z (operacion anterior = 0)
	GOTO	$+3
	;En caso Z = 0
	INCF	INFNIBBLE	;Suma 1 al nibble inferior
	return
	;En caso Z = 1 (operacion anterior = 0)
	MOVLW	0B00000000	;Se carga 0 a W
	MOVWF	INFNIBBLE	;Se reinicia INFNIBBLE
	return
	
    suma2:
	;Antirebote
	BTFSC	PORTA,	2
	GOTO	$-1
	CALL	nops
	SWAPF	SUPNIBBLE,  1	;Se hace swap de los nibbles de la variable
	MOVLW	0B00001111	;Se carga 15 al registro W
	SUBWF	SUPNIBBLE,  0	;Se resta SUPNIBBLE - W, guarda en W
	BTFSC	STATUS,	2	;Revisa STATUS Z (operacion anterior = 0)
	GOTO	$+4
	;En caso Z = 0
	INCF	SUPNIBBLE	;Suma 1 al nibble superior (swap)
	SWAPF	SUPNIBBLE,  1	;Se hace swap nuevamente de los nibbles
	return
	;En caso Z = 1 (operacion anterior = 0)
	MOVLW	0B00000000	;Se carga 0 a W
	MOVWF	SUPNIBBLE	;Se reinicia SUPNIBBLE
	return
	
    resta1:
	;Antirebote
	BTFSC	PORTA,	1
	GOTO	$-1
	CALL	nops
	MOVLW	0B00001111	;Se carga 15 al registro W
	ANDWF	INFNIBBLE	;AND W & INFNIBBLE, se guarda en W
	BTFSC	STATUS,	2	;Se verifica el STATUS Z
	GOTO	$+3
	;En caso Z = 0
	DECF	INFNIBBLE	;Resta 1 al nibble inferior
	return
	;En caso Z = 1 (operacion anterior = 0)
	MOVLW	0b00001111	;Se carga 15 a W
	MOVWF	INFNIBBLE	;Se hace el underflow del contador
	return
	
    resta2:
	;Antirebote
	BTFSC	PORTA,	3
	GOTO	$-1
	CALL	nops
	
	SWAPF	SUPNIBBLE,  1	;Se hace swap de los nibbles de la variable
	MOVLW	0B00001111	;Se carga 15 al registro W
	ANDWF	SUPNIBBLE	;AND W & SUPNIBBLE, se guarda en W
	BTFSC	STATUS,	2	;Se verifica el STATUS Z
	GOTO	$+4
	;En caso Z = 0
	DECF	SUPNIBBLE	;Resta 1 al nibble inferior
	SWAPF	SUPNIBBLE,  1	;Se hace swap nuevamente
	return
	;En caso Z = 1 (operacion anterior = 0)
	MOVLW	0b00001111	;Se carga 15 a W
	MOVWF	SUPNIBBLE	;Se hace el underflow del contador
	SWAPF	SUPNIBBLE	;Se hace swap nuevamente
	return
	
    resultado:
	;Antirebote
	BTFSC	PORTA,	4
	GOTO	$-1
	CALL	nops
	
	SWAPF	SUPNIBBLE	;Swap de los nibbles de la variable
	MOVLW	0B00001111	;Mascara
	ANDWF	INFNIBBLE,  0	;AND W & INFNIBBLE, se guarda en W
	ADDWF	SUPNIBBLE,  0	;Suma SUPBIBBLE + W
	MOVWF	PORTB
	SWAPF	SUPNIBBLE
	
	return
	
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
	return
	
    END