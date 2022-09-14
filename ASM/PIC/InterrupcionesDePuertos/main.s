;///////////////////////////////
; INTERRUPCIONES DE PUERTOS ASM
;///////////////////////////////

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

  w_temp:
    DS 1
    
  s_temp:
    DS 1
    
  
; Vector RESET
  PSECT code, delta = 2, abs
  ORG 0x0000
    resetVector:
	GOTO setup
    
; Vector Interrupcion
  PSECT code, class = CODE, delta = 2
  ORG 0x0004
    
    SAVE:
        MOVWF   w_temp
        SWAPF   STATUS, W
	MOVWF   s_temp
	
    INTERRUPT:
	;Secuencia para que la LED RD0 se comporte segun el estado de RB0
	BTFSC	PORTB,	0
	BSF	PORTD,	0
	BTFSS	PORTB,	0
	BCF	PORTD,	0
    
	;Secuencia para el toggle de la LED en RD0
	;BTFSC	PORTB,	0	;Revisa si la interrupcion fue por presionar el
	;GOTO	$+6		;boton RB0
	
	;BTFSC   PORTD,  0
	;GOTO    $+3
	;BSF	PORTD,  0
	;GOTO    $+2
	;BCF	PORTD,  0
	
	BCF	INTCON, 0	;Se limpia la bandera de interrupcion del Puerto B
	
    LOAD:
	SWAPF   s_temp, W
	MOVWF   STATUS
	SWAPF   w_temp, F
	SWAPF   w_temp, W
	RETFIE
    
    
; Setup
  PSECT code, class = CODE, delta = 2
  ORG 0x00A0
    
    setup:
	BANKSEL	ANSEL
	CLRF	ANSEL
	CLRF	ANSELH
	BANKSEL	OSCCON
	BSF	OSCCON,	4
	BSF	OSCCON,	5	;Se establece la frecuencia del PIC como 8MHz
	BSF	OSCCON,	6
	CALL	portb_iset
	MOVLW	0B00000001	;B0 como entrada
	MOVWF	TRISB
	MOVWF	IOCB
	CLRF	TRISD
	MOVLW	0B00011110
	MOVWF	TRISA		;A1, A2, A3 y A4 como entradas por circuito en proto
	BANKSEL	PORTA
	CLRF	PORTA
	CLRF	PORTB
	CLRF	PORTD
	goto	loop   


; Main code
    loop:
	GOTO	loop

	
    portb_iset:
    	MOVLW	0B10001000	    ;Se habilitan las interrupciones del PIC
	MOVWF	INTCON		    ;y la interrupcion del Puerto B
	return
	
    END