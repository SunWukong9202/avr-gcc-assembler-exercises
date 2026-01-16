.include "m328pdef.inc"
.include "macros.mac"

.equ COUNT, 0x10;
.equ TEMP, 0x11;
.equ FACTOR, 0x12
.equ AUX, 0x13
.equ SB_H, 0x14
.equ SB_L, 0x15

LOAD_IO DDRD, 0xff; PORTD as output
LOAD_IO DDRB, 0x3f; PB0-PB5 0B0011_1111
LOAD_IO DDRC, 0xfe; PC0(ADC0) as input
LOAD_ARAM ADCSRA, 0x87; 0b1000_0111 enable adc and clk/128
LOAD_ARAM ADMUX, 0x20;0b0010_0000;(1 << ADLAR); activate AREF and ADC0, and left adjust
LDI FACTOR, 18; constant factor increment
main:
    LDI TEMP, 0xC7;start conversion
    STS ADCSRA, TEMP;
    wait_for_conversion:
    LDS TEMP, ADCSRA;
    SBRS TEMP, ADIF
    RJMP wait_for_conversion;
    LDI COUNT, 14;
    LDS TEMP, ADCH;read high data
    LDI SB_H, 0X3F; we begin with all 14 bits set
    LDI SB_L, 0XFF;
    check_level:
    MUL COUNT, FACTOR; get an aprox. digital reference for voltage
    MOV AUX, R0;
    CP AUX, TEMP; check if aprox. ref is less than actual conversion
    BRLO exit; if so exit
    DEC COUNT;else check with next ref
    CLC;clear to send only 0 when we rotate
    ROR SB_H;we rotate to clear the last bit set
    ROR SB_L;we propagate to the lower reg
    BRNE check_level;if count != 0 repeat
    exit:; send data to ports
    OUT PORTD, SB_L
    OUT PORTB, SB_H
RJMP main;