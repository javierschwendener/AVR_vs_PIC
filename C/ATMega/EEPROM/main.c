/*
//////////////////
 MEMORIA EEPROM C
//////////////////
 */ 

#include <xc.h>

/*PROTOTIPOS*/
void eeprom_write(void);
void eeprom_read(void);

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
	// Se ejecuta la configuracion
	setup();
	// Loop
    while(1){
		if(PIND & (1<<0)){
			counter = counter + 1;
		}
		while(PIND & (1<<0)){
			asm("nop");
		}
		
		if(counter == 16){
			counter = 0;
		}
		
		if(PIND & (1<<1)){
			counter = counter - 1;
		}
		while(PIND & (1<<1)){
			asm("nop");
		}
			
		if(counter < 0){
			counter = 15;
		}
			
		switch(counter){
			case 0:
				PORTB = 0B00111111;
				break;
			case 1:
				PORTB = 0B00000011;
				break;
			case 2:
				PORTB = 0B01011110;
				break;
			case 3:
				PORTB = 0B01001111;
				break;
			case 4:
				PORTB = 0B01100011;
				break;
			case 5:
				PORTB = 0B01101101;
				break;
			case 6:
				PORTB = 0B01111101;
				break;
			case 7:
				PORTB = 0B00000111;
				break;
			case 8:
				PORTB = 0B01111111;
				break;
			case 9:
				PORTB = 0B01100111;
				break;
			case 10:
				PORTB = 0B01110111;
				break;
			case 11:
				PORTB = 0B01111001;
				break;
			case 12:
				PORTB = 0B00111100;
				break;
			case 13:
				PORTB = 0B01011011;
				break;
			case 14:
				PORTB = 0B01111100;
				break;
			case 15:
				PORTB = 0B01110100;
				break;
		}
		
		if(PIND & (1<<2)){
			eeprom_write();
		}
		while(PIND & (1<<2)){
			asm("nop");
		}
	
		if(PIND & (1<<3)){
			eeprom_read();
		}
		while(PIND & (1<<3)){
			asm("nop");
		}
	}
}

void eeprom_write(void){
	PORTC = 0B00000001;
	while(EECR & (1<<EEPE)){
		
	}	
	EEAR = 0;
	EEDR = counter;
	
	EECR |= (1<<EEMPE);
	EECR |= (1<<EEPE);
	PORTC = 0B00000000;
}

void eeprom_read(void){
	PORTC = 0B00000001;
	while(EECR & (1<<EEPE)){
		
	}
	EEAR = 0;
	EECR |= (1<<EERE);
	counter = EEDR;
	PORTC = 0B00000000;
}