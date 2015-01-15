#define F_CPU 8000000UL

#define baudRate

#define redLED 4
#define yelLED 0
#define serialOut 5
#define serialIn 6

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

void writeSerial(char value);
void init(void);

int serialIndex = 0;

int main()
{
    init();

    while(1) {
}
return 0;

}


/*-------------------------------------------------------
---------------------------------------------------------

//Interrupt Service Routine

---------------------------------------------------------
-------------------------------------------------------*/


ISR(TIMER0_COMPA_vect)
{   cli();
    writeSerial('z');
    sei();
}





/*-------------------------------------------------------
---------------------------------------------------------

//Function Prototypes

---------------------------------------------------------
-------------------------------------------------------*/


void init(void)
{

//set outputs
DDRB = 0xFF;

PORTB |= (1 << redLED);

//enable timer compare interrupt
TIMSK = 0x10;

//enable CTC mode, Compare Match Output A
TCCR0A = 0x02;

//Clock prescalar values (1, 8, 64, 256, 1024 = 0x01, 0x02, 0x03, 0x04, 0x05)
TCCR0B = 0x82;

//set compare value for CTC, 9600 Hz.  = 51.1
OCR0A = 0x33;

PORTB |= (1 << yelLED);

sei();


}

void writeSerial(char value)
{
    if (serialIndex == 0){
        PORTB &= (0 << redLED);
        serialIndex++;
        _delay_ms(1000);
    }

    if (serialIndex >= 1 & serialIndex < 8){
        PORTB = value;
        value = value >> 1;
        serialIndex++;
        _delay_ms(1000);
    }

    if (serialIndex == 8){
        PORTB &= (0 << redLED);
        PORTB &= (0 << yelLED);
        _delay_ms(1000);
        serialIndex = 0;
    }



}



