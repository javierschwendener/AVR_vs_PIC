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
	BANKSEL	TRISA
	CLRF	TRISA
	CLRF	TRISB
	CLRF	TRISC
	CLRF	TRISD
	MOVLW	0b00011111  ;A0 y A1 como entradas
	MOVWF	TRISA
	BANKSEL	PORTA
	CLRF	PORTA
	CLRF	PORTB
	CLRF	PORTC
	CLRF	PORTD
	goto	loop


; Main code
    loop:
	;Si se prende A0, aumentar el contador 1
	BTFSC	PORTA,	0
	INCF	PORTD
	;Antirebote
	BTFSC	PORTA,	0
	GOTO	$-1
	;Si se prende A1, decrementar el contador 1
	BTFSC	PORTA,	1
	DECF	PORTD
	;Antirebote
	BTFSC	PORTA,	1
	GOTO	$-1
	;Si se prende el bit 7 del puerto D, se coloca el valor 0b00001111
	MOVLW	0b00001111
	BTFSC	PORTD,	7
	MOVWF	PORTD
	;Si se prende el bit 4 del puerto D, reiniciar el contador 1
	;Esto con el fin de que el contador sea de 4 bits
	BTFSC	PORTD,	4
	CLRF	PORTD
	;Si se prende A2, aumentar el contador 2
	BTFSC	PORTA,	2
	INCF	PORTC
	;Antirebote
	BTFSC	PORTA,	2
	GOTO	$-1
	;Si se prende A3, decrementar el contador 2
	BTFSC	PORTA,	3
	DECF	PORTC
	;Antirebote
	BTFSC	PORTA,	3
	GOTO	$-1
	;Si se prende el bit 7 del puerto C, se coloca el valor 0b00001111
	MOVLW	0b00001111
	BTFSC	PORTC,	7
	MOVWF	PORTC
	;Si se prende el bit 4 del puerto C, reiniciar el contador 2
	BTFSC	PORTC,	4
	CLRF	PORTC
	;Se suman ambos contadores y se muestra el resultado en el puerto B
	MOVF	PORTD,	0   ;Se mueve PORTD a W
	BTFSC	PORTA,	4
	ADDWF	PORTC,	0   ;Se suma W + PORTC
	BTFSC	PORTA,	4
	MOVWF	PORTB	    ;Pasa W al PORTB
	;Antirrebote
	BTFSC	PORTA,	4
	GOTO	$-1
	GOTO	loop
    END