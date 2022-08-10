/*
////////////////
 PILA ANIDADA C
////////////////
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
void func2(void);
void func3(void);
void func4(void);
void func5(void);
void func6(void);
void func7(void);
void func8(void);

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
        // Inicio de la medicion
        PORTDbits.RD0 = 1;
        func1();
        // Fin de la medicion
        PORTD = 0;
    }
    return;
}

void func1(void) {
    asm("NOP");
    func2();
    return;
}

void func2(void) {
    asm("NOP");
    func3();
    return;
}

void func3(void) {
    asm("NOP");
    func4();
    return;
}

void func4(void) {
    asm("NOP");
    func5();
    return;
}

void func5(void) {
    asm("NOP");
    func6();
    return;
}

void func6(void) {
    asm("NOP");
    func7();
    return;
}

void func7(void) {
    asm("NOP");
    func8();
    return;
}

void func8(void) {
    // Bandera del CALL
    PORTDbits.RD1 = 1;
    return;
}