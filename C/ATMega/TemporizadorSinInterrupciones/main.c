/*
///////////////////////////////////
 TEMPROIZADOR SIN INTERRUPCIONES C
///////////////////////////////////
 */ 

#include <xc.h>

/*PROTOTIPOS*/
void timer0_set(void);

/*VARIABLES*/
int counter = 0;

void setup(void){
	// Puertos B y C como salidas
	DDRB = 0b11111111;
	DDRC = 0b11111111;
	// Puerto D como entrada
	DDRD = 0b00000000;
	// Se establece el valor de los puertos como 0
	PORTB = 0;
	PORTC = 0;
	PORTD = 0;
}

int main(void)
{
	// Se ejecuta la configuracion de los puertos
	setup();
	timer0_set();
    while(1){
		if(TCNT0 == 128){
			TCNT0 = 0;
			counter = counter + 1;
		}
		if(counter == 15){
			counter = 0;
			if(PINB & (1<<0)){
				PORTB = 0;
			}
			else{
				PORTB = 1;
			}
		}
	}
}

void timer0_set(void){
	TCCR0A = 0B00000000;
	TCCR0B = 0B00000101;
	TCNT0 = 0;
}