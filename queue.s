.include "m328pdef.inc"
.include "macros.mac"

.equ front, 0x155
.equ back, 0x155
.equ data, 0x10; r16
.equ EEDPL, 0x13; R19
.equ EEDPH, 0x14;r20
INIT_STACK; refers to stack of the Mic itself
;setup all for the stack 
rcall init;

;LOAD_ARAM end, ; load to Address RAM
LOAD_ARAM front, 0xAA

LOAD_IO DDRD, 0xff;PORTD as output 0b1111_1111 

LOAD_IO DDRC, 0xc0;PC0-PC5 as input & PC6-PC7 as out 0b1100_0000
LOAD_IO PORTC,0x3f; active pull up on PC0-PC5 0b0011_1111

LOAD_IO DDRB, 0xf0;PB0-PB3 as in 0b1111_0000
LOAD_IO PORTB, 0x0f; active pull up on PB0-PB3 0b0000_1111

LDI data, 0xAA
main:
    SBIS PINC, PINC4; if PINB0 is'n press skip
    RJMP push_assist  
    SBIS PINC, PINC5; same as for PINB, but for PINB5
    RJMP pop_assist; else jump to decrement
    assign:
    out PORTD, data
rjmp main

push_assist:
    RCALL delay; first call a delay subroutine
    SBIC PINC, PINC4; check if the push button is'n press
    RJMP push_a;if so then increment the counter var
    RJMP assign;return to assign 
; for decrement we do exactly the same as for increment
pop_assist:
    RCALL delay;
    SBIC PINC, PINC5
    RJMP pop_a
    RJMP assign

pop_a:
    RCALL isEmpty
    breq return;
    CP X, Y;are equal
    breq reset;if so
 
    LD data, y;
    adiw Y, 1; inc Y = front
return:    
    RJMP assign

reset:
    rcall init;


push_a:
    rcall isEmpty
    breq assign_to_zero;set to next pos
    adiw X, 1;inc X = BACK
store:
    RJMP get_data
    ST X, data
    RJMP assign
assign_to_zero:
    rcall init;
    adiw X, 1;
    adiw Y, 1;
    rjmp store;

init:
    LDI XH, hi8(front);
    LDI XL, lo8(front);
    LDI YH, hi8(front);
    LDI YL, lo8(front);
    ret

isEmpty:
    CPI X, 0xAA
    BRNE return 
    CPI Y, 0xAA 
return: 
    ret

get_data:
    IN R17, PINC
    ANDI R17, 0x0F
    IN R18, PINB
    SWAP R18
    ANDI R18, 0XF0
    OR R18, R17
    COM R18
    mov data, R18
rjmp store

delay:;1ms
    LDI R21, 32;200;
outer_loop: 
    LDI R22, 100;
inner_loop: 
    NOP;1 cycle
    NOP;1 cycle
    DEC R2;1 cycle
    BRNE inner_loop; 2 cycle when branch 1 when not
    DEC R21;
    BRNE outer_loop;
    RET