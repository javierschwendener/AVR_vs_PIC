/*
///////////////////////////////////
 TEMPORIZADOR CON INTERRUPCIONES C
///////////////////////////////////
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
void timer0_set(void);

/*VARIABLES*/
int counter = 0;

void setup(void){
    ANSEL   =   0;
    ANSELH  =   0;
    TRISA   =   0b00011111;     // Entradas en A0, A1, A2, A3 y A4 por botones en la proto
    TRISB   =   0;
    TRISC   =   0;
    TRISD   =   0;
    PORTA   =   0;
    PORTB   =   0;
    PORTC   =   0;
    PORTD   =   0;
    OSCCONbits.IRCF0 = 1;
    OSCCONbits.IRCF1 = 1;
    OSCCONbits.IRCF2 = 1;
}

void main(void) {
    setup();
    timer0_set();
    while(1){
    }
}

void timer0_set(void){
    INTCONbits.GIE = 1;
    INTCONbits.T0IE = 1;
    OPTION_REGbits.T0CS = 0;
    OPTION_REGbits.T0SE = 0;
    OPTION_REGbits.PSA = 0;
    OPTION_REGbits.PS2 = 1;
    OPTION_REGbits.PS1 = 1;
    OPTION_REGbits.PS0 = 1;
    TMR0 = 128;
}

void __interrupt() ISR(void){
    if(counter == 14){
        if(PORTDbits.RD0 == 0){
            PORTDbits.RD0 = 1;
        }
        else{
            PORTDbits.RD0 = 0;
        }
        counter = 0;
    }
    else{
        counter = counter + 1;
    }
    INTCONbits.T0IF = 0;
    TMR0 = 128;
}