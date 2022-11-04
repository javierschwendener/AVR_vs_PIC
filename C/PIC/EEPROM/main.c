/*
//////////////////
 MEMORIA EEPROM C
//////////////////
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
void ee_write(void);
void ee_read(void);

/*VARIABLES*/
int counter = 0;

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
        if(PORTAbits.RA0 == 1){
            counter = counter + 1;
        }
        while(PORTAbits.RA0 == 1){
            NOP();
        }
        
        if(counter == 16){
            counter = 0;
        }
        
        if(PORTAbits.RA1 == 1){
            counter = counter - 1;
        }
        while(PORTAbits.RA1 == 1){
            NOP();
        }
        
        if(counter < 0 ){
            counter = 15;
        }
        
        switch(counter){
            case 0:
                PORTD = 0B00111111;
                break;
            case 1:
                PORTD = 0B00000011;
                break;
            case 2:
                PORTD = 0B01011110;
                break;
            case 3:
                PORTD = 0B01001111;
                break;
            case 4:
                PORTD = 0B01100011;
                break;
            case 5:
                PORTD = 0B01101101;
                break;
            case 6:
                PORTD = 0B01111101;
                break;
            case 7:
                PORTD = 0B00000111;
                break;
            case 8:
                PORTD = 0B01111111;
                break;
            case 9:
                PORTD = 0B01100111;
                break;
            case 10:
                PORTD = 0B01110111;
                break;
            case 11:
                PORTD = 0B01111001;
                break;
            case 12:
                PORTD = 0B00111100;
                break;
            case 13:
                PORTD = 0B01011011;
                break;
            case 14:
                PORTD = 0B01111100;
                break;
            case 15:
                PORTD = 0B01110100;
                break;
        }
        
        if(PORTAbits.RA2 == 1){
            ee_write();
        }
        while(PORTAbits.RA2 == 1){
            NOP();
        }
        if(PORTAbits.RA3 == 1){
            ee_read();
        }
        while(PORTAbits.RA3 == 1){
            NOP();
        }
        
    }
}

void ee_write(void){
    PORTBbits.RB0 = 1;
    EEDATA = counter;
    EEADR = 0;
    EECON1bits.EEPGD = 0;
    EECON1bits.WREN = 1;
    
    EECON2 = 0x55;
    EECON2 = 0xAA;
    
    EECON1bits.WR = 1;
    
    while(EECON1bits.WR == 1){   
    }
    
    EECON1bits.WREN = 0;
    PORTBbits.RB0 = 0;
    return;
}

void ee_read(void){
    PORTBbits.RB0 = 1;
    EEADR = 0;
    EECON1bits.EEPGD = 0;
    EECON1bits.RD = 1;
    counter = EEDATA;
    PORTBbits.RB0 = 0;
    return;
}