.include "m328pdef.inc"
.include "macros.mac"
.equ data, 0x10; r16
.equ AUX_L, 0x13;R19
.equ AUX_H, 0x14;R20
.equ TEMP, 0x15;21

INIT_STACK; refers to stack of the Mic itself

;port configuration
LOAD_IO DDRD, 0xff;PORTD as output 0b1111_1111 
LOAD_IO DDRC, 0xc0;PC0-PC5 as input & PC6-PC7 as out 0b1100_0000
LOAD_IO PORTC,0x3f; active pull up on PC0-PC5 0b0011_1111
LOAD_IO DDRB, 0xf0;PB0-PB3 as in 0b1111_0000
LOAD_IO PORTB, 0x0f; active pull up on PB0-PB3 0b0000_1111

;initialize X reg to the top of the stack
rcall init_top;

main:
    SBIS PINC, PINC4; if PINB0 is'n press skip
    RJMP push_assist  
    SBIS PINC, PINC5; same as for PINB, but for PINB5
    RJMP pop_assist; else jump to decrement
    assign:
    OUT PORTD, data
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
    RCALL read;can be tought as LD data, X
    CPI data, 0xAA;compare for empty
    BREQ assign;return/jump to assign
    LD r19, -X;dec X address reg
    RJMP assign

push_a:
    LD r19, X+; increment X
    RJMP get_data; get data from ports
store:
    RCALL write;can be tought as ST X, data
    RJMP assign

get_data:
    IN R17, PINC
    ANDI R17, 0x0F
    IN R18, PINB
    SWAP R18
    ANDI R18, 0xF0
    OR R18, R17
    COM R18
    mov data, R18
rjmp store

read:
    RCALL assign_address;assign address parameters
    RCALL read_from_eeprom;call subroutine to read
    MOV data, TEMP; were we want to store what we read
    RCALL update_top; keep top updated
    RET;return from this subroutine

write:
    RCALL assign_address;assign address parameters
    MOV TEMP, data;and also assign what we want to write
    RCALL write_in_eeprom; call subroutine
    RCALL update_top; keep top updated
    RET;return

assign_address:
    ;update to write/read properly
    MOV AUX_H, XH
    MOV AUX_L, XL;
    RET
    
;read top and init X reg
;
init_top:
    ;address of the high byte of top in eeprom
    LDI AUX_H, hi8(TOP_H);
    LDI AUX_L, lo8(TOP_H);
    RCALL read_from_eeprom;subroutine for read
    MOV XH, TEMP;we indicate were we can put the data
    ;we repeat for the low byte
    LDI AUX_H, hi8(TOP_L);
    LDI AUX_L, lo8(TOP_L);
    RCALL read_from_eeprom
    MOV XL, TEMP
    RCALL read;
    RET
;
;update top
;
update_top:
    ;address of the high byte of top in eeprom
    LDI AUX_H, hi8(TOP_H);
    LDI AUX_L, lo8(TOP_H);
    MOV TEMP, XH;we indicate what we can put in TOP_H
    RCALL write_in_eeprom;subroutine for write
    ;we repeat for the low byte
    LDI AUX_H, hi8(TOP_L);
    LDI AUX_L, lo8(TOP_L);
    MOV TEMP, XL
    RCALL write_in_eeprom;
    RET

write_in_eeprom: 
    sbic EECR, EEPE;wait while eeprom is busy
    rjmp write_in_eeprom
    ;get 
    out EEARH, AUX_H
    out EEARL, AUX_L
    out EEDR, TEMP
    sbi EECR, EEMPE ;set master enable
    sbi EECR, EEPE; set write enable
    ret

read_from_eeprom:
    sbic EECR, EEPE;wait while eeprom is busy
    rjmp read_from_eeprom
    ;get 
    out EEARH, AUX_H
    out EEARL, AUX_L
    sbi EECR, EERE; set Read Enable
    in TEMP, EEDR
    ret

delay:;1ms
    LDI R21, 32;200;
outer_loop: 
    LDI R22, 100;
inner_loop: 
    NOP;1 cycle
    NOP;1 cycle
    DEC R22;1 cycle*remove 2 if some got wrong
    BRNE inner_loop; 2 cycle when branch 1 when not
    DEC R21;
    BRNE outer_loop;
    RET

.section .eeprom
;.eeprom 0x400   ; Reserve 1024 bytes for EEPROM
.org 0x0A    ; Set the starting address to the 150th byte of EEPROM

TOP_H:
.byte 0x01      ; Store the value 0xAB in the 10th byte of EEPROM
TOP_L:
.byte 0x55

.org 0x155
EMPTY:
.byte 0xAA