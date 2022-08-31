/*
////////////////////////////////////
 ENTRADAS Y SALIDAS PUERTO SIMPLE C
////////////////////////////////////
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

/*VARIABLES*/
int infnibble = 0;
int supnibble = 0;

void setup(void){
    ANSEL   =   0;
    ANSELH  =   0;
    PORTA   =   0;
    PORTB   =   0;
    PORTD   =   0;
    TRISA   =   0b00011111; //A0, A1, A2, A3 y A4 como entradas
    TRISB   =   0;
    TRISD   =   0;
    OSCCONbits.IRCF0 = 1;
    OSCCONbits.IRCF1 = 1;
    OSCCONbits.IRCF2 = 1;
    return;
}

void main(void) {
    setup();
    while(1){
        // CONTADOR 1
        // Suma
        if(PORTAbits.RA0 == 1){
            infnibble = infnibble + 1;
        }
        // Antirebote
        while(PORTAbits.RA0 == 1){
            NOP();
        }
        // OVERFLOW
        if (infnibble > 15){ //0b00001111
            infnibble = 0;
        }
        // Resta
        if(PORTAbits.RA1 == 1){
            infnibble = infnibble - 1;
        }
        // Antirebote
        while(PORTAbits.RA1 == 1){
            NOP();
        }
        // UNDERFLOW
        if(infnibble < 0){ //0b00000000
            infnibble = 15;
        }
        
        // CONTADOR 2
        if(PORTAbits.RA2 == 1){
            supnibble = supnibble + 1;
        }
        // Antirebote
        while(PORTAbits.RA2 == 1){
            NOP();
        }
        if (supnibble > 15){ //0b00001111
            supnibble = 0;
        }
        // Resta
        if(PORTAbits.RA3 == 1){
            supnibble = supnibble - 1;
        }
        // Antirebote
        while(PORTAbits.RA3 == 1){
            NOP();
        }
        // UNDERFLOW
        if(supnibble < 0){ //0b00000000
            supnibble = 15;
        }
        
        // Mostrar los resultados en el puerto D
        PORTD = (16*supnibble) + infnibble;
        
        // SUMA DE CONTADORES
        if(PORTAbits.RA4 == 1){
            PORTB = supnibble + infnibble;
        }
        // Antirebote
        while(PORTAbits.RA4 == 1){
            NOP();
        }
    }
}