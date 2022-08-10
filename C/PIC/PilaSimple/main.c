/*
///////////////
 PILA SIMPLE C
///////////////
*/

/*CONFIG*/
#pragma config FOSC     =   INTRC_NOCLKOUT
#pragma config WDTE     =   OFF
#pragma config PWRTE    =   OFF
#pragma config MCLRE    =   OFF
#pragma config CP       =   OFF
#pragma config CPD      =   OFF
#pragma config BOREN    =   OFF
#pragma config IESO     =   OFF
#pragma config FCMEN    =   OFF
#pragma config LVP      =   OFF
#pragma config BOR4V    =   BOR40V
#pragma config WRT      =   OFF

#define _XTAL_FREQ 8000000

#include <xc.h>

/*PROTOTIPOS*/
void func1(void);

/*VARIABLES*/

void setup(void){
    ANSEL   =   0;
    ANSELH  =   0;
    PORTA   =   0;
    PORTB   =   0;
    PORTC   =   0;
    PORTD   =   0;
    TRISA   =   0;
    TRISB   =   0;
    TRISC   =   0;
    TRISD   =   0;
    OSCCONbits.IRCF0 = 1;
    OSCCONbits.IRCF1 = 1;
    OSCCONbits.IRCF2 = 1;
}

void main(void) {
    setup();
    while(1){
        // Inicio de la medicion
        PORTD = 0b00000001;
        func1();
        PORTD = 0;
    }
}

void func1(void) {
    PORTD = 0b00000011;
    return;
}