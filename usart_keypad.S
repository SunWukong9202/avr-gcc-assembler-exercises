#include<avr/io.h>
#include "m328p_io.inc"//redefine the lowest 63 io address
#include "macros.mac"

.equ TEMP, 0x10;
.equ TEMP_K, 0x12 //r18
.equ AUX_INC, 0x13 //r19
.equ ROW_INDEX, 0x14// r20
.equ COL_INDEX, 0x15//r21
.equ null, 0;


.global main
main:
INIT_STACK; refers to stack of the Mic itself
LOAD_IO DDRD, 0xfe;PORTD as output 0b1111_1111 to 7seg 
;PC as port ctrl
LOAD_IO DDRC, 0xff;PC0-PC3 as out
;PB as port read
LOAD_IO DDRB, 0xf0;PB0-PB3 as in 0b1111_0000
LOAD_IO PORTB, 0x0f; active pull up on PB0-PB3 0b0000_1111
LOAD_ARAM UCSR0B, (1 << RXEN0) | (1 << TXEN0)
;async mode, 9600 bauds, 8 bits, 1 stop bit, without parity
LOAD_ARAM UCSR0C, (1 << USBS0) | (1 << UCSZ01) | (1 << UCSZ00)
LOAD_ARAM UBRR0L, 103;
start:
  LDS TEMP, UCSR0A;
  SBRS TEMP, RXC0
  RJMP skip_rx;
  //code for rx
  LDS TEMP, UDR0; read from terminal
  RCALL search_code;
  RCALL stream_out;
  skip_rx:
  SBRS TEMP, UDRE0
  RJMP skip_tx;
  //code for tx
  RCALL start_keypad;read from keypad
  BRTC skip_tx;if nothing was pressed
  RCALL retrieve_ascii_code;
  STS UDR0, TEMP_K;send ascii code to the terminal
  skip_tx:
RJMP start;

search_code:
  RCALL load_array_ascii
  LDI AUX_INC, 0
  keep_looking:
  LPM TEMP_K, Z+
  INC AUX_INC
  CP TEMP_K, TEMP
  BREQ map
  CPI TEMP_K, null
  BRNE keep_looking;D
  //default code
  LDI TEMP_K, 0x02;
  RJMP return_from_search
  map:
  //code to map from ascii to 7seg format
  RCALL load_array
  search_map:
  LPM TEMP_K, Z+
  DEC AUX_INC
  BRNE search_map;
  return_from_search:
RET

retrieve_ascii_code:
  RCALL load_array_ascii;
  RCALL read_from_array;
RET

load_array_ascii:
  LDI ZH, hi8(array_ascii)//retrieve the ref to my array
  LDI ZL, lo8(array_ascii)//
RET

.global load_array
load_array:
  LDI ZH, hi8(array)//retrieve the ref to my array
  LDI ZL, lo8(array)//
RET


start_keypad:
  LDI TEMP_K, 0x01// init to active first row(PC0)
  LDI AUX_INC, 0x00// used as counter
  active_rows:
  COM TEMP_K// complement because we use 0 to active pin
  OUT PORTC, TEMP_K// send to active row pin
  RCALL check_pins// check if some pin is press
  BRTS reset
  INC AUX_INC//
  COM TEMP_K// complement to keep the state of pins
  LSL TEMP_K// shift to activate next row
  SBRS TEMP_K, 4//iterate up to reach PC4 
  RJMP active_rows//
  RJMP return//
  reset:
  RCALL btn_actived// if one was press
  return:
RET

stream_out:
  OUT PORTD, TEMP_K//
  SBRC TEMP_K, PD1
  SBI PORTB, PD5;
  SBRS TEMP_K, PD1;
  CBI PORTB, PD5;  
RET;

btn_actived:
  MOV ROW_INDEX, AUX_INC// assign row index
  RCALL load_array;
  RCALL read_from_array
  RCALL stream_out;
ret

check_pins:
  PUSH TEMP_K// store context
  PUSH AUX_INC//
  //load col with a default value, because later we check if keep that value
  LDI TEMP_K, 0x01// load to begin iterating over PORTB
  LDI AUX_INC, 0x00//init to assign COL_INDEX properly
  loop_in_pins:
  RCALL debounce// check if some bit was pressed
  BRTS check_pins_return//
  INC AUX_INC
  LSL TEMP_K// shift to check next bit
  SBRS TEMP_K, 4//if reach PB4 skip
  RJMP loop_in_pins//keep check the rest of pins
  check_pins_return:
  MOV COL_INDEX, AUX_INC//if so assign the correct index to COL_INDEX
  POP AUX_INC// restore context
  POP TEMP_K//
ret

debounce:
  PUSH AUX_INC//
  CLT// use T as bool to signal push press
  RCALL refresh_reg//
  COM AUX_INC//complement to check properly
  CPSE AUX_INC, TEMP_K//if they are equal, then we press a pin
  RJMP return_debounce//
  check_release:// finally we wait up to realease the pin
  RCALL refresh_reg//we load again the data in PINB
  CPI AUX_INC, 0xff//if all pins are set then the pin was release
  BREQ allow_action//if so 
  RJMP check_release// else we keep checking
  allow_action:
  SET// set T to signal push press
  return_debounce:
  POP AUX_INC//
ret//

refresh_reg:
  IN AUX_INC, PINB//
  ORI AUX_INC, 0xf0//
ret

//expression to retrieve data:Z + ROW_INDEX*4 + COL_INDEX
read_from_array:
  PUSH ROW_INDEX
  LDI TEMP_K, 4//load 4 to TEMP_K
  LDI AUX_INC, 0x00//we use AUX_INC as a zero register
  MUL ROW_INDEX, TEMP_K//ROW_INDEX*4
  MOV ROW_INDEX, r0//laod low part of mul to ROW_INDEX
  MOV TEMP_K, r1//load high part of mul to TEMP_K
  ADD ROW_INDEX, COL_INDEX//add the low part to COL_INDEX
  ADC TEMP_K, AUX_INC// add the high part to a zero reg, this
  //is only do it to propagate the carry if exist
  ADD ZL, ROW_INDEX//finally we sum low part to ZL(low)
  ADC ZH, TEMP_K//high part to ZH
  LPM TEMP_K, Z//load to data the bits pointed by Z
  POP ROW_INDEX;
ret//

.org 0x150
array: 
         //   1           2           3           A
.byte    0b01100000, 0b11011010, 0b11110010, 0b11101110
         //   4           5           6           B
.byte    0b01100110, 0b10110110, 0b10111110, 0b00111110
         //   7           8           9           C
.byte    0b11100000, 0b11111110, 0b11110110, 0b10011100
         //   E-*         0          F-#          D
.byte    0b10011110, 0b11111100, 0b10001110, 0b01111010

array_ascii:
.byte    '1', '2', '3', 'A'
.byte    '4', '5', '6', 'B'
.byte    '7', '8', '9', 'C'
.byte    '*', '0', '#', 'D'
null: .byte     0


