;////////////////////
; MEMORIA EEPROM ASM
;////////////////////

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
    
  counter:
    DS 1
    
  
; Vector RESET
  PSECT code, delta = 2, abs
  ORG 0x0000
    resetVector:
	GOTO setup
    
; Vector Interrupcion
  PSECT code, class = CODE, delta = 2
  ORG 0x0004
    
    ;SAVE:
	MOVWF   w_temp
	SWAPF   STATUS, W
	MOVWF   s_temp
	
    INTERRUPT:
	MOVLW	0B00000001
	MOVWF	PORTB
	
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
	
	;CALL	eeprom_set
	
	BANKSEL TRISA
	MOVLW	0B00011111
	MOVWF	TRISA		;A0, A1, A2, A3 y A4 como entradas por circuito en proto
	CLRF	TRISB
	CLRF	TRISD
	BANKSEL	PORTA
	CLRF	PORTA
	CLRF	PORTB
	CLRF	PORTD
	CLRF	counter
	
	GOTO	loop


; Main code
    loop:
	BTFSC	PORTA,	    0
	INCF	counter
	BTFSC	PORTA,	    0
	GOTO	$-1
	
	MOVLW	0B00010000  ;16
	SUBWF	counter,    0
	BTFSC	STATUS,	    2
	CLRF	counter
	
	MOVLW	0B11111111
	ANDWF	counter,    0
	
	;MOVLW	0B00000000
	
	CALL	table
	
	MOVWF	PORTD
	
	GOTO	loop
    
    table:
	ADDWF	PCL,	1
	RETLW	0B00111111  ;0
	RETLW	0B00000011  ;1
	RETLW	0B01011110  ;2
	RETLW	0B01001111  ;3
	RETLW	0B01100011  ;4
	RETLW	0B01101101  ;5
	RETLW	0B01111101  ;6
	RETLW	0B00000111  ;7
	RETLW	0B01111111  ;8
	RETLW	0B01100111  ;9
	RETLW	0B01110111  ;A
	RETLW	0B01111001  ;B
	RETLW	0B00111100  ;C
	RETLW	0B01011011  ;D
	RETLW	0B01111100  ;E
	RETLW	0B01110100  ;F
	
    eeprom_set:
	MOVLW	0B00001111
	MOVWF	PORTB
	RETURN
	
    END