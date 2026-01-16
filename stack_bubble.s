.include "m328pdef.inc"
.include "macros.mac"

.equ begin, 0x155
.equ data, 0x10; r16
.equ AUX_H, 0x11;r17
.equ AUX_L, 0x12;r18
.equ left,0x13
.equ right,0x14
INIT_STACK; refers to stack of the Mic itself
;setup all for the stack 
LDI XH, hi8(begin);
LDI XL, lo8(begin);

;LOAD_ARAM end, ; load to Address RAM
LOAD_ARAM begin, 0xAA

LOAD_IO DDRD, 0xff;PORTD as output 0b1111_1111 

LOAD_IO DDRC, 0xc0;PC0-PC5 as input & PC6-PC7 as out 0b1100_0000
LOAD_IO PORTC,0x3f; active pull up on PC0-PC5 0b0011_1111

LOAD_IO DDRB, 0xE0;PB0-PB3 as in 0b1110_0000
LOAD_IO PORTB, 0x1f; active pull up on PB0-PB4 0b0001_1111

LDI data, 0xAA
main:
    SBIS PINC, PINC4; if PINB0 is'n press skip
    RJMP push_assist  
    SBIS PINC, PINC5; same as for PINB, but for PINB5
    RJMP pop_assist; else jump to decrement
    SBIS PINB, PINB4
    RJMP bubble_assist
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

bubble_assist:
    RCALL delay;
    SBIC PINB, PINB4
    RCALL bubble_sort
    LD data, X;
    RJMP assign

bubble_sort:
    RCALL init_to_begin;
    MOV YH,AUX_H 
    MOV YL,AUX_L
outer:    
    ;check if Y < X
    CP YH, XH;we compare the highers bits
    BRLO less_than;if YH < XH then undoubtedly Y < X
    BRNE greater_than;if they aren't equal then Y > X
    CPC YL, XL;if they are equal then we have the check once more
    BRLO less_than;indeed Y < H
greater_than: RJMP exit;because still left the odds of Y >= H we handle it here
less_than:;just for clarity sake
    MOV ZH,AUX_H 
    MOV ZL,AUX_L
inner:
    ;check if Z < X - Y
    CP ZH, XH;we compare the highers bits
    BRLO search_smallest;if YH < XH then undoubtedly Z < X
    BRNE outer_inc;if they aren't equal then Z > X
    CPC ZL, XL;if they are equal then we have the check once more
    BRLO search_smallest;indeed Z < H
    RJMP outer_inc;
search_smallest:
    ;check if Z < Z+1
    LD left, Z;
    LDD right, Z+1;
    CP left, right
    BRLO _swap;if left < right
    RJMP _inc;
_swap:
    ;right(Z+1) = left(Z)
    STD Z+1, left;
    ;left = right
    ST Z, right;
_inc: LD data, Z+;SBIW Z,1;
RJMP inner;
outer_inc: LD data, Y+;
RJMP outer;
exit: RET;

init_to_begin:
    LDI AUX_H, hi8(begin + 1);
    LDI AUX_L, lo8(begin + 1);
    ret

pop_a:
    LD data, X
    CPI data, 0xAA
    BREQ assign
    LD data, -X;
    LD data, X;
    RJMP assign

push_a:
    LD data, X+
    RJMP get_data
store:
    ST X, data
    RJMP assign

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
    DEC R22;1 cycle
    BRNE inner_loop; 2 cycle when branch 1 when not
    DEC R21;
    BRNE outer_loop;
    RET