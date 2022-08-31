/*
//////////////////////
 ENTRADAS Y SALIDAS C
//////////////////////
 */ 

#include <xc.h>

/*PROTOTIPOS*/


/*VARIABLES*/
int	infnibble = 0;
int supnibble = 0;

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
    while(1)
    {
		// CONTADOR 1
		// Suma
		if(PIND & (1<<0)){
			infnibble = infnibble + 1;
		}
		// Antirebote
		while(PIND & (1<<0)){
			asm("nop");
		}
		// Proteccion de overflow
		if(infnibble > 15){ //0b00001111
			infnibble = 0;
		}
		// Resta
		if(PIND & (1<<1)){
			infnibble = infnibble - 1;
		}
		// Antirebote
		while(PIND & (1<<1)){
			asm("nop");
		}
		// Proteccion de underflow
		if(infnibble < 0){ //0b00000000
			infnibble = 15;
		}
		
		// CONTADOR 2
		// Suma
		if(PIND & (1<<2)){
			supnibble = supnibble + 1;
		}
		// Antirebote
		while(PIND & (1<<2)){
			asm("nop");
		}
		// Proteccion de overflow
		if(supnibble > 15){ //0b00001111
			supnibble = 0;
		}
		// Resta
		if(PIND & (1<<3)){
			supnibble = supnibble - 1;
		}
		// Antirebote
		while(PIND & (1<<3)){
			asm("nop");
		}
		// Proteccion de underflow
		if(supnibble < 0){ //0b00000000
			supnibble = 15;
		}
		
		// Mostrar los resultados en el puerto B
		PORTB = (16*supnibble) + infnibble;
		
		// SUMA DE CONTADORES
		if(PIND & (1<<4)){
			PORTC = supnibble + infnibble;
		}
		// Antirebote
		while(PIND & (1<<4)){
			asm("nop");
		}
    }
}