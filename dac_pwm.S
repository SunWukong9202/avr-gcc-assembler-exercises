#include<avr/io.h>
#include "m328p_io.inc"//redefine the lowest 63 io address
#include "macros.mac"
.equ TEMP, 0x11;

.global main
main:
CBI DDRC, DDC0;for adc0 - PC0 as input
SBI DDRD, DDD6;for pwm 0CA0 - PD6 as output
;select pwm phase correct(mode 4), compare mode: clear when up, set when down
LOAD_IO TCCR0A, (1 << WGM00) | (1 << COM0A1) 
LOAD_IO TCCR0B, (1 << CS00);select no prescaling
LOAD_ARAM ADCSRA, 0x87; 0b1000_0111 enable adc and clk/128
LOAD_ARAM ADMUX, (1 << ADLAR); activate AREF and select ADC0, and left adjust
keep_busy:
  LDI TEMP, 0xC7;set start conversion
  STS ADCSRA, TEMP;load configuration
  wait_for_conversion:
  LDS TEMP, ADCSRA;load to keep looking for ADIF
  SBRS TEMP, ADIF;skip if ADIF = 1
  RJMP wait_for_conversion;else keep waiting
  LDS TEMP, ADCH;read high data
  OUT OCR0A, TEMP;send 8 MSB's bits to pwm wave generator
RJMP keep_busy;