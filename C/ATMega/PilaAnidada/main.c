/*
////////////////
 PILA ANIDADA C
////////////////
 */ 

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
	// Configuracion inicial de los puertos como salidas
	DDRD = 0b11111111;
	// Se establece el valor de los puertos como 0
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
	asm("nop");
	func2();
	return;
}

void func2(void){
	asm("nop");
	func3();
	return;
}

void func3(void){
	asm("nop");
	func4();
	return;
}

void func4(void){
	asm("nop");
	func5();
	return;
}

void func5(void){
	asm("nop");
	func6();
	return;
}

void func6(void){
	asm("nop");
	func7();
	return;
}

void func7(void){
	asm("nop");
	func8();
	return;
}
void func8(void){
	PORTD |= 1<<PORTD1;
	return;
}