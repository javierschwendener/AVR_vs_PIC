;/////////////////
; PILA SIMPLE ASM
;/////////////////

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
	BANKSEL	OSCCON
	BSF	OSCCON,	4
	BSF	OSCCON,	5
	BSF	OSCCON,	6
	BANKSEL	TRISD
	CLRF	TRISD
	BANKSEL	PORTD
	CLRF	PORTD
	goto	loop


; Main code
    loop:
	; Inicio de la medicion
	BSF	PORTD,	0
	CALL	func1
	CLRF	PORTD
	GOTO	loop   
    
; Se define una funcion
    func1:
	;Se enciende una bandera fisica en el PIC (PIN 0 de PORTD)
	BSF	PORTD,	1
	return
	
; Fin del programa
    END