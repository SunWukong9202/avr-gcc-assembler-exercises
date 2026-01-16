.include "m328pdef.inc"

.equ LCD_DATA_PORT , PORTD  ; define the data port for the LCD
.equ LCD_DATA_DIR , DDRD
.equ LCD_RS_PORT , PORTB   ; define the RS and EN ports for the LCD
.equ LCD_RS_DIR , DDRB
.equ LCD_EN_PORT , PORTB
.equ LCD_EN_DIR , DDRB

.org 0x0000                ; start of program memory

reset:
    ldi R16, lo8(RAMEND)   ; initialize the stack pointer
    out SPL, R16
    ldi R16, hi8(RAMEND)
    out SPH, R16

    ; initialize the LCD
    ldi R16, 0x38          ; function set: 8-bit mode, 2 lines, 5x7 font
    call lcd_command
    ldi R16, 0x0C          ; display on, cursor off, blink off
    call lcd_command
    ldi R16, 0x01          ; clear display
    call lcd_command
    ldi R16, 0x06          ; entry mode set: increment cursor, no display shift
    call lcd_command

loop:
    ; display "Hello, world!" on the LCD
    ldi R16, 0x80          ; set DDRAM address to 0x00 (first line)
    call lcd_command
    ldi R16, 'H'           ; send 'H' to the LCD
    call lcd_data
    ldi R16, 'e'           ; send 'e' to the LCD
    call lcd_data
    ldi R16, 'l'           ; send 'l' to the LCD
    call lcd_data
    ldi R16, 'l'           ; send 'l' to the LCD
    call lcd_data
    ldi R16, 'o'           ; send 'o' to the LCD
    call lcd_data
    ldi R16, ','           ; send ',' to the LCD
    call lcd_data
    ldi R16, ' '           ; send ' ' to the LCD
    call lcd_data
    ldi R16, 'w'           ; send 'w' to the LCD
    call lcd_data
    ldi R16, 'o'           ; send 'o' to the LCD
    call lcd_data
    ldi R16, 'r'           ; send 'r' to the LCD
    call lcd_data
    ldi R16, 'l'           ; send 'l' to the LCD
    call lcd_data
    ldi R16, 'd'           ; send 'd' to the LCD
    call lcd_data
    ldi R16, '!'           ; send '!' to the LCD
    call lcd_data

    rjmp loop               ; loop forever

lcd_command:
    ; set RS low to select command mode
    cbi LCD_RS_PORT, 0
    sbi LCD_RS_DIR, 0

    ; set EN high to enable LCD
    sbi LCD_EN_PORT, 1
    sbi LCD_EN_DIR, 1

    ; wait for EN to settle
    nop
    nop

    ; send command to data port
    out LCD_DATA_PORT, R16

    ; pulse EN high then low
    sbi LCD_EN_PORT, 1
    nop
    nop
    cbi LCD_EN_PORT, 1

    ; wait for command to execute
    ldi R17, 50
    lcd_command_delay:
        dec R17
        brne lcd_command_delay

    ret

    lcd_data:
    ; set RS high to select data mode
    sbi LCD_RS_PORT, 0
    sbi LCD_RS_DIR, 0

    ; set EN high to enable LCD
    sbi LCD_EN_PORT, 1
    sbi LCD_EN_DIR, 1

    ; wait for EN to settle
    nop
    nop

    ; send data to data port
    out LCD_DATA_PORT, R16

    ; pulse EN high then low
    sbi LCD_EN_PORT, 1
    nop
    nop
    cbi LCD_EN_PORT, 1

    ret