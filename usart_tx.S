#include<avr/io.h>
#include "m328p_io.inc"//redefine the lowest 63 io address
#include "macros.mac"

.equ TEMP, 0x10;
.equ AUX, 0x11;
.equ BUFFER, 0x12;
.equ BCD_H, 0x13;r19
.equ BCD_L, 0x14;r20
.equ ADD_3, 0x15;

.global main
main:
INIT_STACK
LOAD_ARAM UCSR0B, (1 << TXEN0)
;async mode, 9600 bauds, 8 bits, 1 stop bit, without parity
LOAD_ARAM UCSR0C, (1 << USBS0) | (1 << UCSZ01) | (1 << UCSZ00)
LOAD_ARAM UBRR0L, 103;
LOAD_ARAM ADCSRA, 0x8F; 0b1000_1111 enable adc, clk/128 and interrupts
LOAD_ARAM ADMUX, (1 << ADLAR) | (1 << MUX2); activate AREF and select ADC4, and left adjust

start:
  LDI TEMP, 0xC7;set start conversion
  STS ADCSRA, TEMP;load configuration
  wait_for_conversion:
  LDS TEMP, ADCSRA;load to keep looking for ADIF
  SBRS TEMP, ADIF;skip if ADIF = 1
  RJMP wait_for_conversion;else keep waiting
  LDS AUX, ADCH;read high data
  //usart code
  ; RCALL bin_to_BCD
  ; LDI BUFFER, '0'
  ; ANDI BCD_H, 0x0f;
  ; ADD BCD_H, BUFFER
  ; MOV AUX, BCD_H
  ; RCALL transmit
  ; MOV AUX, BCD_L
  ; SWAP AUX
  ; ANDI AUX, 0x0f;
  ; ADD AUX, BUFFER
  ; RCALL transmit;
  ; MOV AUX, BCD_L
  ; ANDI AUX, 0x0f
  ; ADD AUX, BUFFER
  ; RCALL transmit;
  ; LDI AUX, 0x20;
  
  RCALL transmit;
  RCALL delay
RJMP start;

transmit:
  LDS TEMP, UCSR0A;
  SBRS TEMP, UDRE0;0xc6	
  RJMP transmit;
  STS UDR0, AUX;
RET

bin_to_BCD:
  LDI BCD_H, 0;
  LDI BCD_L, 0;
  LDI TEMP, 8;
  LDI ADD_3, 3;
  loop:
  MOV BUFFER, BCD_L
  ANDI BUFFER, 0x0f
  CPI BUFFER, 5
  BRLO skip_add_1
  ADD BCD_L, ADD_3
  skip_add_1:
  MOV BUFFER, BCD_L
  ANDI BUFFER, 0x5f
  CPI BUFFER, 5
  BRLO skip_add_2
  ADD BUFFER, ADD_3
  SWAP BUFFER
  ANDI BUFFER, 0xf0
  ANDI BCD_L, 0x0f
  OR BCD_L, BUFFER
  skip_add_2:
  LSL AUX;
  ROL BCD_L;
  ROL BCD_H;
  DEC TEMP;
  BRNE loop;
RET

delay:
    ldi  r18, 41
    ldi  r19, 150
    ldi  r20, 128
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1
RET