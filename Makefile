# Define variables
PORT        =   COM3
DEVICE      =   atmega328p
PROGRAMMER  =   arduino
BAUD        =   115200
COMPILE     =   avr-gcc

# Default source file name
DEFAULT_SRC = default

# Source files without extension, separated by space
SRC_FILES ?= $(DEFAULT_SRC)

# Extract the base name of the first source file in the list
TARGET = $(basename $(firstword $(SRC_FILES)))

# Optimization level for the compiler
OPTIMIZATION = -Os

# Compiler flags
CFLAGS = -mmcu=$(DEVICE)

# Object files
OBJ_FILES = $(addsuffix .o,$(basename $(SRC_FILES)))

# Rules
.PHONY: all build upload clean

all: build upload clean

build: $(TARGET).elf

$(TARGET).elf: $(OBJ_FILES)
	${COMPILE} $(CFLAGS) $(OBJ_FILES) -o $@

%.o: %.S
	${COMPILE} $(CFLAGS) -c $< -o $@

$(TARGET).hex: $(TARGET).elf
	avr-objcopy -O ihex -R .eeprom $(TARGET).elf $@

upload: $(TARGET).hex
	avrdude -c ${PROGRAMMER} -P ${PORT} -b ${BAUD} -p ${DEVICE} -D -U flash:w:${TARGET}.hex:i

clean:
	rm -f *.o $(TARGET).elf $(TARGET).hex
	
# PORT        =   COM3
# DEVICE      =   atmega328p
# PROGRAMMER  =   arduino
# BAUD        =   115200
# COMPILE     =   avr-gcc

# # List of source files
# SRC_FILES ?= default
# # Extract the base name of the first .S file in the list
# TARGET = $(basename $(firstword $(SRC_FILES)))

# # Optimization level for the compiler
# OPTIMIZATION = -Os

# # Other compiler flags
# CFLAGS = -mmcu=$(DEVICE)

# # Object files
# OBJ_FILES = $(patsubst %.S,%,$(SRC_FILES))

# default: build upload clean

# build: $(addsuffix .o,$(OBJ_FILES))
# # Rule for compiling .S files into object files
# $(addsuffix .o,$(OBJ_FILES)): %.o: %.S $(SRC_FILES)
# 	${COMPILE} $(CFLAGS) -c $< -o $@

# # Rule for linking the object files into the final executable
# $(TARGET).elf: $(addsuffix .o,$(OBJ_FILES))
# 	${COMPILE} $(CFLAGS) $(addsuffix .o,$(OBJ_FILES)) -o $@

# # Rule for generating the .hex file from the executable
# $(TARGET).hex: $(TARGET).elf
# 	avr-objcopy -O ihex -R .eeprom $(TARGET).elf $@

# # Rule for uploading the code to the microcontroller
# upload: $(TARGET).hex
# 	avrdude -c ${PROGRAMMER} -P ${PORT} -b ${BAUD} -p ${DEVICE} -D -U flash:w:${TARGET}.hex:i

# # Rule for cleaning up the project
# clean:
# 	rm -f *.o $(TARGET).elf $(TARGET).hex

# # Add the names of the files you want to compile here, separated by spaces
# FILENAME		= default



# default: build upload clean

# build:
# 	${COMPILE} -g -mmcu=${DEVICE} -o ${FILENAME}.elf ${addsuffix .S, ${FILENAME}}
# 	avr-objcopy -O ihex -R .eeprom ${FILENAME}.elf ${FILENAME}.hex

# upload:
# 	avrdude -c ${PROGRAMMER} -P ${PORT} -b ${BAUD} -p ${DEVICE} -D -U flash:w:${FILENAME}.hex:i

# clean:
# 	rm ${FILENAME}.elf
# 	rm ${FILENAME}.hex

# build:
# 	${COMPILE} ${addsuffix .S, ${FILENAME}}
# 	avr-objcopy -O ihex -R .eeprom ${FILENAME}.elf ${FILENAME}.hex
