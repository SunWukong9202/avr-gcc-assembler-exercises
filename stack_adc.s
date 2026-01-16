.include "m328pdef.inc"
.include "macros.mac"

.equ begin, 0x155
.equ data, 0x10; r16

INIT_STACK; refers to stack of the Mic itself
;setup all for the stack 
LDI XH, hi8(begin);
LDI XL, lo8(begin);

;LOAD_ARAM end, ; load to Address RAM
LOAD_ARAM begin, 0xAA

LOAD_IO DDRD, 0xff;PORTD as output 0b1111_1111 

LOAD_IO DDRC, 0xc7;0b1100_1110 PC0 and PC4-PC5 as input
LOAD_IO PORTC,0x20; active pull up on PC5 0b0010_0000

LOAD_ARAM ADCSRA, 0x87; 0b1000_0111 enable adc and clk/128
LOAD_ARAM ADMUX, 0x20;0b0010_0000;(1 << ADLAR); activate AREF and ADC0, and left adjust

LDI data, 0xAA
main:
    SBIS PINC, PINC4; if PINC4 is'n press skip
    RJMP push_assist  
    SBIS PINC, PINC5; same as for PINC4, but for PINC5
    RJMP pop_assist; else jump to decrement
    assign:
    out PORTD, data
rjmp main

push_assist:
    SBIC PINC, PINC4; check if the push button is'n press
    RJMP push_a;if so then increment the counter var
    RJMP push_assist

pop_assist:
    SBIC PINC, PINC5
    RJMP pop_a
    RJMP pop_assist
    
pop_a:
    LD data, X
    CPI data, 0xAA
    BREQ assign
    LD r19, -X;
    RJMP assign

push_a:
    LD data, X+
    RJMP get_data
store:
    ST X, data
    RJMP assign

get_data:
  	LDI data, 0xC7; init a new conversion
    STS ADCSRA, data;
    wait_for_conversion:
    LDS data, ADCSRA;
    SBRS data, ADIF
    RJMP wait_for_conversion;
    LDS data, ADCH;read the last 8 significant bits
rjmp store