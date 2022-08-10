/*
///////////////
 PILA SIMPLE C
///////////////
 */ 

#include <xc.h>
//#include <iom328p.h>

/*PROTOTIPOS*/
void func1(void);
/*VARIABLES*/

void setup(void){
	// Configuracion inicial de los puertos como salidas
	DDRB = 0b11111111;
	DDRC = 0b11111111;
	DDRD = 0b11111111;
	// Se establece el valor de los puertos como 0
	PORTB = 0;
	PORTC = 0;
	PORTD = 0;
}

int main(void)
{
	// Se ejecuta la configuracion de los puertos
	setup();
    while(1)
    {
		// Inicio de la medicion
		PORTD |= 1<<PORTD0;
		func1();
		// Fin de la medicion
		PORTD = 0;
    }
}

void func1(void){
	PORTD |= 1<<PORTD1;
	return;
}