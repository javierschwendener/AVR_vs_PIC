/*
/////////////////////////////
 INTERRUPCIONES DE PUERTOS C
/////////////////////////////
 */ 

#include <xc.h>
#include <avr/interrupt.h>

/*PROTOTIPOS*/
void pini_set(void);

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
	sei();
}

int main(void)
{
	// Se ejecuta la configuracion de los puertos
	setup();
	pini_set();
    while(1){
	}
}

void pini_set(void){
	PCICR = 0B00000100;
	PCMSK2 = 0B00000001;
}

ISR(PCINT2_vect, ISR_NAKED){
	if(PIND & (1<<0)){
		PORTB = 1;
	}
	else{
		PORTB = 0;
	}
	
	/*
	if(PIND & (1<<0)){
		if(PINB & (1<<0)){
			PORTB = 0;
		}
		else{
			PORTB = 1;
		}
	}
	*/
	
	reti();
}