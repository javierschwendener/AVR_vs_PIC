/*
///////////////
 PILA SIMPLE C
///////////////
*/

/*CONFIG*/
#pragma config FOSC     =   XT
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

/*VARIABLES*/

void setup(void){
    ANSEL   =   0;
    ANSELH  =   0;
    PORTA   =   0;
    PORTB   =   0;
    PORTC   =   0;
    PORTD   =   0;
    TRISA   =   0b00011111;
    TRISB   =   0;
    TRISC   =   0;
    TRISD   =   0;
    OSCCONbits.IRCF0 = 1;
    OSCCONbits.IRCF1 = 1;
    OSCCONbits.IRCF2 = 1;
    return;
}

void main(void) {
    setup();
    while(1){
        // Contador 1
        if(PORTAbits.RA0 == 1){
            PORTD = PORTD + 1;
        }
        // Overflow
        if(PORTD == 0b00010000){
            PORTD = 0;
        }
        // Antirebote
        while(PORTAbits.RA0 == 1){
            NOP();
        }
        if(PORTAbits.RA1 == 1){
            PORTD = PORTD - 1;
        }
        // Underflow
        if(PORTD == 0b11111111){
            PORTD = 0b00001111;
        }
        // Antirebote
        while(PORTAbits.RA1 == 1){
            NOP();
        }
        
        // Contador 2
        if(PORTAbits.RA2 == 1){
            PORTC = PORTC + 1;
        }
        // Overflow
        if(PORTC == 0b00010000){
            PORTC = 0;
        }
        // Antirebote
        while(PORTAbits.RA2 == 1){
            NOP();
        }
        if(PORTAbits.RA3 == 1){
            PORTC = PORTC - 1;
        }
        // Underflow
        if(PORTC == 0b11111111){
            PORTC = 0b00001111;
        }
        // Antirebote
        while(PORTAbits.RA3 == 1){
            NOP();
        }
        
        // Sumatoria de contadores
        if(PORTAbits.RA4 == 1){
            PORTB = PORTC + PORTD;
        }
        // Antirebote
        while(PORTAbits.RA4 == 1){
            NOP();
        }
    }
    return;
}