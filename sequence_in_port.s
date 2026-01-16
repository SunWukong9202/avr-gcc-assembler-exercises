.include "m328pdef.inc"
.include "macros.mac"
.equ go_forward, 0x10
.equ go_backward, 0x11
.equ temp, 0x12
INIT_STACK; refers to stack of the Mic itself

LOAD_IO DDRD, 0xff;PORTD as output 0b1111_1111 
LDI go_forward, 0b00001000; go to LSB
LDI go_backward,0b00010000; go to MSB

main:
  MOV temp, go_backward;we store the content of go_back in temp
  OR temp, go_forward; we merge temp(to avoid overwrite go_backward) and go_forward
  OUT PORTD, temp;we send temp who has the two active pins
  ROR go_forward;we rotate the active pin to the right 
  ROL go_backward;rotate to left
  ;if ROR set C then ROL will propagate it to go_back and will
  ;set C again so we propagate to go_forward doing a ROR one more time
  ;in such a way that both REG's propagate at the same time
  BRCS ror_forward
  SBRC go_forward, PD3; we avoid the delay if PD3 is set
  RJMP main;
  RCALL delay_250ms
RJMP main;

ror_forward:
  ROR go_forward;
;return to main in such way that we avoid the delay
;that will allow us to keep the same delay for every transition
;ignoring of course the cycles wasted for one iteration without delay
rjmp main

delay_250ms:
    ldi  r18, 21
    ldi  r19, 75
    ldi  r20, 191
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
    nop
ret