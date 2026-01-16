;********* debounce push buttons bits*************************
.equ DPB_PIN0, 0
.equ DPB_PIN1, 1
.equ DPB_PIN2, 2
.equ DPB_PIN3, 3
.equ DPB_PIN4, 4
.equ DPB_PIN5, 5
.equ DPB_PIN6, 6
.equ DPB_PIN7, 7

.equ	ADMUX	, 0x7c	; MEMORY MAPPED
.equ	ADCSRB	, 0x7b	; MEMORY MAPPED
.equ	ADCSRA	, 0x7a	; MEMORY MAPPED
.equ	ADCH	, 0x79	; MEMORY MAPPED
.equ	ADCL	, 0x78	; MEMORY MAPPED
.equ	EICRA	, 0x69	; MEMORY MAPPED
.equ	TIMSK0	, 0x6e	; MEMORY MAPPED
.equ	SREG, 0x3f
.equ	SPL, 0x3d
.equ	SPH, 0x3e

.equ	OCR0B	, 0x28
.equ	OCR0A	, 0x27
.equ	TCNT0	, 0x26
.equ	TCCR0B	, 0x25
.equ	TCCR0A	, 0x24

;eeprom i/o registers
.equ	EEARH, 0x22
.equ	EEARL, 0x21
.equ	EEDR, 0x20
.equ	EECR, 0x1f

.equ	EIMSK	, 0x1d
.equ	PORTD, 0x0b
.equ	DDRD, 0x0a
.equ	PIND, 0x09
.equ	PORTC, 0x08
.equ	DDRC, 0x07
.equ	PINC, 0x06
.equ	PORTB, 0x05
.equ	DDRB, 0x04
.equ	PINB, 0x03


; ***** PORTB ************************
; PORTB - Port B Data Register
.equ	PORTB0, 0	; Port B Data Register bit 0
.equ	PB0, 0	; For compatibility
.equ	PORTB1, 1	; Port B Data Register bit 1
.equ	PB1, 1	; For compatibility
.equ	PORTB2, 2	; Port B Data Register bit 2
.equ	PB2, 2	; For compatibility
.equ	PORTB3, 3	; Port B Data Register bit 3
.equ	PB3, 3	; For compatibility
.equ	PORTB4, 4	; Port B Data Register bit 4
.equ	PB4, 4	; For compatibility
.equ	PORTB5, 5	; Port B Data Register bit 5
.equ	PB5, 5	; For compatibility
.equ	PORTB6, 6	; Port B Data Register bit 6
.equ	PB6, 6	; For compatibility
.equ	PORTB7, 7	; Port B Data Register bit 7
.equ	PB7, 7	; For compatibility

; DDRB - Port B Data Direction Register
.equ	DDB0, 0	; Port B Data Direction Register bit 0
.equ	DDB1, 1	; Port B Data Direction Register bit 1
.equ	DDB2, 2	; Port B Data Direction Register bit 2
.equ	DDB3, 3	; Port B Data Direction Register bit 3
.equ	DDB4, 4	; Port B Data Direction Register bit 4
.equ	DDB5, 5	; Port B Data Direction Register bit 5
.equ	DDB6, 6	; Port B Data Direction Register bit 6
.equ	DDB7, 7	; Port B Data Direction Register bit 7

; PINB - Port B Input Pins
.equ	PINB0, 0	; Port B Input Pins bit 0
.equ	PINB1, 1	; Port B Input Pins bit 1
.equ	PINB2, 2	; Port B Input Pins bit 2
.equ	PINB3, 3	; Port B Input Pins bit 3
.equ	PINB4, 4	; Port B Input Pins bit 4
.equ	PINB5, 5	; Port B Input Pins bit 5
.equ	PINB6, 6	; Port B Input Pins bit 6
.equ	PINB7, 7	; Port B Input Pins bit 7


; ***** PORTC ************************
; PORTC - Port C Data Register
.equ	PORTC0, 0	; Port C Data Register bit 0
.equ	PC0, 0	; For compatibility
.equ	PORTC1, 1	; Port C Data Register bit 1
.equ	PC1, 1	; For compatibility
.equ	PORTC2, 2	; Port C Data Register bit 2
.equ	PC2, 2	; For compatibility
.equ	PORTC3, 3	; Port C Data Register bit 3
.equ	PC3, 3	; For compatibility
.equ	PORTC4, 4	; Port C Data Register bit 4
.equ	PC4, 4	; For compatibility
.equ	PORTC5, 5	; Port C Data Register bit 5
.equ	PC5, 5	; For compatibility
.equ	PORTC6, 6	; Port C Data Register bit 6
.equ	PC6, 6	; For compatibility

; DDRC - Port C Data Direction Register
.equ	DDC0, 0	; Port C Data Direction Register bit 0
.equ	DDC1, 1	; Port C Data Direction Register bit 1
.equ	DDC2, 2	; Port C Data Direction Register bit 2
.equ	DDC3, 3	; Port C Data Direction Register bit 3
.equ	DDC4, 4	; Port C Data Direction Register bit 4
.equ	DDC5, 5	; Port C Data Direction Register bit 5
.equ	DDC6, 6	; Port C Data Direction Register bit 6

; PINC - Port C Input Pins
.equ	PINC0, 0	; Port C Input Pins bit 0
.equ	PINC1, 1	; Port C Input Pins bit 1
.equ	PINC2, 2	; Port C Input Pins bit 2
.equ	PINC3, 3	; Port C Input Pins bit 3
.equ	PINC4, 4	; Port C Input Pins bit 4
.equ	PINC5, 5	; Port C Input Pins bit 5
.equ	PINC6, 6	; Port C Input Pins bit 6


; ***** PORTD ************************
; PORTD - Port D Data Register
.equ	PORTD0, 0	; Port D Data Register bit 0
.equ	PD0, 0	; For compatibility
.equ	PORTD1, 1	; Port D Data Register bit 1
.equ	PD1, 1	; For compatibility
.equ	PORTD2, 2	; Port D Data Register bit 2
.equ	PD2, 2	; For compatibility
.equ	PORTD3, 3	; Port D Data Register bit 3
.equ	PD3, 3	; For compatibility
.equ	PORTD4, 4	; Port D Data Register bit 4
.equ	PD4, 4	; For compatibility
.equ	PORTD5, 5	; Port D Data Register bit 5
.equ	PD5, 5	; For compatibility
.equ	PORTD6, 6	; Port D Data Register bit 6
.equ	PD6, 6	; For compatibility
.equ	PORTD7, 7	; Port D Data Register bit 7
.equ	PD7, 7	; For compatibility

; DDRD - Port D Data Direction Register
.equ	DDD0, 0	; Port D Data Direction Register bit 0
.equ	DDD1, 1	; Port D Data Direction Register bit 1
.equ	DDD2, 2	; Port D Data Direction Register bit 2
.equ	DDD3, 3	; Port D Data Direction Register bit 3
.equ	DDD4, 4	; Port D Data Direction Register bit 4
.equ	DDD5, 5	; Port D Data Direction Register bit 5
.equ	DDD6, 6	; Port D Data Direction Register bit 6
.equ	DDD7, 7	; Port D Data Direction Register bit 7

; PIND - Port D Input Pins
.equ	PIND0, 0	; Port D Input Pins bit 0
.equ	PIND1, 1	; Port D Input Pins bit 1
.equ	PIND2, 2	; Port D Input Pins bit 2
.equ	PIND3, 3	; Port D Input Pins bit 3
.equ	PIND4, 4	; Port D Input Pins bit 4
.equ	PIND5, 5	; Port D Input Pins bit 5
.equ	PIND6, 6	; Port D Input Pins bit 6
.equ	PIND7, 7	; Port D Input Pins bit 7

.equ	SREG_C, 0	; Carry Flag
.equ	SREG_Z, 1	; Zero Flag
.equ	SREG_N, 2	; Negative Flag
.equ	SREG_V, 3	; Two's Complement Overflow Flag
.equ	SREG_S, 4	; Sign Bit
.equ	SREG_H, 5	; Half Carry Flag
.equ	SREG_T, 6	; Bit Copy Storage
.equ	SREG_I, 7	; Global Interrupt Enable


; ***** DATA MEMORY DECLARATIONS *****************************************
.equ	FLASHEND, 0x3fff	; Note: Word address
.equ	IOEND, 0x00ff
.equ	SRAM_START, 0x0100
.equ	SRAM_SIZE, 2048
.equ	RAMEND, 0x08ff
.equ	XRAMEND, 0x0000
.equ	E2END, 0x03ff
.equ	EEPROMEND, 0x03ff
.equ	EEADRBITS, 10


; ***** CPU REGISTER DEFINITIONS *****************************************
.EQU	XH, 0x1B;
.EQU	XL, 0x1A;
.EQU	YH, 0x1D;
.EQU	YL, 0x1C;
.EQU	ZH, 0x1F;
.EQU	ZL, 0x1E;

; EECR - EEPROM Control Register
.equ	EERE, 0	; EEPROM Read Enable
.equ	EEPE, 1	; EEPROM Write Enable
.equ	EEMPE, 2	; EEPROM Master Write Enable
.equ	EERIE, 3	; EEPROM Ready Interrupt Enable
.equ	EEPM0, 4	; EEPROM Programming Mode Bit 0
.equ	EEPM1, 5	; EEPROM Programming Mode Bit 1

; ***** AD_CONVERTER *****************
; ADMUX - The ADC multiplexer Selection Register
.equ	MUX0	, 0	; Analog Channel and Gain Selection Bits
.equ	MUX1	, 1	; Analog Channel and Gain Selection Bits
.equ	MUX2	, 2	; Analog Channel and Gain Selection Bits
.equ	MUX3	, 3	; Analog Channel and Gain Selection Bits
.equ	ADLAR	, 5	; Left Adjust Result
.equ	REFS0	, 6	; Reference Selection Bit 0
.equ	REFS1	, 7	; Reference Selection Bit 1

; ADCSRA - The ADC Control and Status register A
.equ	ADPS0	, 0	; ADC  Prescaler Select Bits
.equ	ADPS1	, 1	; ADC  Prescaler Select Bits
.equ	ADPS2	, 2	; ADC  Prescaler Select Bits
.equ	ADIE	, 3	; ADC Interrupt Enable
.equ	ADIF	, 4	; ADC Interrupt Flag
.equ	ADATE	, 5	; ADC  Auto Trigger Enable
.equ	ADSC	, 6	; ADC Start Conversion
.equ	ADEN	, 7	; ADC Enable

; ***** TIMER_COUNTER_0 **************
; TIMSK0 - Timer/Counter0 Interrupt Mask Register
.equ	TOIE0	, 0	; Timer/Counter0 Overflow Interrupt Enable
.equ	OCIE0A	, 1	; Timer/Counter0 Output Compare Match A Interrupt Enable
.equ	OCIE0B	, 2	; Timer/Counter0 Output Compare Match B Interrupt Enable

; TIFR0 - Timer/Counter0 Interrupt Flag register
.equ	TOV0	, 0	; Timer/Counter0 Overflow Flag
.equ	OCF0A	, 1	; Timer/Counter0 Output Compare Flag 0A
.equ	OCF0B	, 2	; Timer/Counter0 Output Compare Flag 0B

; TCCR0A - Timer/Counter  Control Register A
.equ	WGM00	, 0	; Waveform Generation Mode
.equ	WGM01	, 1	; Waveform Generation Mode
.equ	COM0B0	, 4	; Compare Output Mode, Fast PWm
.equ	COM0B1	, 5	; Compare Output Mode, Fast PWm
.equ	COM0A0	, 6	; Compare Output Mode, Phase Correct PWM Mode
.equ	COM0A1	, 7	; Compare Output Mode, Phase Correct PWM Mode

; TCCR0B - Timer/Counter Control Register B
.equ	CS00	, 0	; Clock Select
.equ	CS01	, 1	; Clock Select
.equ	CS02	, 2	; Clock Select
.equ	WGM02	, 3	; 
.equ	FOC0B	, 6	; Force Output Compare B
.equ	FOC0A	, 7	; Force Output Compare A

; TCNT0 - Timer/Counter0
.equ	TCNT0_0	, 0	; 
.equ	TCNT0_1	, 1	; 
.equ	TCNT0_2	, 2	; 
.equ	TCNT0_3	, 3	; 
.equ	TCNT0_4	, 4	; 
.equ	TCNT0_5	, 5	; 
.equ	TCNT0_6	, 6	; 
.equ	TCNT0_7	, 7	; 

; OCR0A - Timer/Counter0 Output Compare Register
.equ	OCR0A_0	, 0	; 
.equ	OCR0A_1	, 1	; 
.equ	OCR0A_2	, 2	; 
.equ	OCR0A_3	, 3	; 
.equ	OCR0A_4	, 4	; 
.equ	OCR0A_5	, 5	; 
.equ	OCR0A_6	, 6	; 
.equ	OCR0A_7	, 7	; 

; OCR0B - Timer/Counter0 Output Compare Register
.equ	OCR0B_0	, 0	; 
.equ	OCR0B_1	, 1	; 
.equ	OCR0B_2	, 2	; 
.equ	OCR0B_3	, 3	; 
.equ	OCR0B_4	, 4	; 
.equ	OCR0B_5	, 5	; 
.equ	OCR0B_6	, 6	; 
.equ	OCR0B_7	, 7	; 

; ***** EXTERNAL_INTERRUPT ***********
; EICRA - External Interrupt Control Register
.equ	ISC00	, 0	; External Interrupt Sense Control 0 Bit 0
.equ	ISC01	, 1	; External Interrupt Sense Control 0 Bit 1
.equ	ISC10	, 2	; External Interrupt Sense Control 1 Bit 0
.equ	ISC11	, 3	; External Interrupt Sense Control 1 Bit 1

; EIMSK - External Interrupt Mask Register
.equ	INT0	, 0	; External Interrupt Request 0 Enable
.equ	INT1	, 1	; External Interrupt Request 1 Enable

; ***** INTERRUPT VECTORS ************************************************
.equ	INT0addr	, 0x0002	; External Interrupt Request 0
.equ	INT1addr	, 0x0004	; External Interrupt Request 1
.equ	PCI0addr	, 0x0006	; Pin Change Interrupt Request 0
.equ	PCI1addr	, 0x0008	; Pin Change Interrupt Request 0
.equ	PCI2addr	, 0x000a	; Pin Change Interrupt Request 1
.equ	WDTaddr	, 0x000c	; Watchdog Time-out Interrupt
.equ	OC2Aaddr	, 0x000e	; Timer/Counter2 Compare Match A
.equ	OC2Baddr	, 0x0010	; Timer/Counter2 Compare Match A
.equ	OVF2addr	, 0x0012	; Timer/Counter2 Overflow
.equ	ICP1addr	, 0x0014	; Timer/Counter1 Capture Event
.equ	OC1Aaddr	, 0x0016	; Timer/Counter1 Compare Match A
.equ	OC1Baddr	, 0x0018	; Timer/Counter1 Compare Match B
.equ	OVF1addr	, 0x001a	; Timer/Counter1 Overflow
.equ	OC0Aaddr	, 0x001c	; TimerCounter0 Compare Match A
.equ	OC0Baddr	, 0x001e	; TimerCounter0 Compare Match B
.equ	OVF0addr	, 0x0020	; Timer/Couner0 Overflow