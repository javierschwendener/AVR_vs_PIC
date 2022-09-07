;/////////////////////////////////////
; TEMPORIZADOR CON INTERRUPCIONES ASM
;/////////////////////////////////////

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

// config statements should precede project file includes.
#include <xc.inc>
  
; Declaracion de variables
  PSECT	udata

  TIMVAL:
    DS 1
    
  COUNTER:
    DS 1
  
; Vector RESET
  PSECT code, delta = 2, abs
  ORG 0x0000
  resetVector:
    goto setup
    
; Setup
  PSECT code, delta = 2
  ORG 0x000A
    setup:
	BANKSEL	ANSEL
	CLRF	ANSEL
	CLRF	ANSELH
	BANKSEL	OSCCON
	BSF	OSCCON,	4
	BSF	OSCCON,	5	;Se establece la frecuencia del PIC como 8MHz
	BSF	OSCCON,	6
	BANKSEL	OPTION_REG
	CALL	tmr0_set
	CLRF	TRISA
	CLRF	TRISB
	CLRF	TRISD
	MOVLW	0b00011111
	MOVWF	TRISA		;A0, A1, A2, A3 y A4 como entradas
	BANKSEL	PORTA
	CLRF	PORTA
	CLRF	PORTB
	CLRF	PORTD
	CLRF	TMR0
	CLRF	TIMVAL
	CLRF	COUNTER
	goto	loop   


; Main code
    loop:
	;Verificar el valor del TIMER 0
	MOVLW	0B11111111	;Mascara
	ANDWF	TMR0,	    0	;AND TMR0 & W, se guarda en W
	MOVWF	TIMVAL		;Se guarda TMR0 en TIMVAL
	BTFSC	TIMVAL,	    7	;Se verifica 0b10000000
	CALL	cont_int
	MOVLW	0B00001111	;Se mueve 15 a W (Para 250ms)
	SUBWF	COUNTER,    0	;Se resta COUNTER - W, se guarda en W
	BTFSC	STATUS,	    2	;Se verifica el STATUS Z (COUNTER - W = 0)
	CALL	blink
	
	GOTO	loop

	
	
    tmr0_set:
	MOVLW	0B11000000	    ;Mascara
	ANDWF	OPTION_REG, 0	    ;Se guardan dos bits de OPTION_REG
	IORLW	0B00000111	    ;Se establece la configuracion en W
	MOVWF	OPTION_REG	    ;Se mueve a OPTION_REG
	return
	
    cont_int:
	INCF	COUNTER	    ;Se incrementa una variable
	CLRF	TIMVAL	    ;Se reinicia el valor guardado del timer 0
	CLRF	TMR0	    ;Se reinicia el timer 0
	return
	
    blink:
	CLRF	COUNTER
	CLRF	TIMVAL	    ;Se limpian las variables usadas
	
	BTFSC	PORTD,	0   ;Se revisa el bit 0 del puerto b
	GOTO	$+3
	BSF	PORTD,	0   ;Se enciende la LED de medicion
	return
	BCF	PORTD,	0   ;Se apaga la LED de medicion
	return
	
    END