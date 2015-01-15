# C files
FILES = main.c
# chip name
MCU = atmega328p
# abbreviated chip name
P_MCU = m328p
# programmer
ISP = Arduino
# port
PORT = /dev/tty.usbmodem1421
#baud rate
BRATE = 115200


CFLAGS = -g -mmcu=$(MCU) -Os -Werror -mcall-prologues -fdata-sections -ffunction-sections
LDFLAGS = -Wl,-gc-sections -lm


# Makefile Targets

# Since the "all" target is the first target in the file, it will run when you simply type make (or make all).
#  We have configured this target so that it only compiles the program into .elf and .hex files, and displays their final sizes.

328All:
	avr-gcc $(CFLAGS) -o main.elf $(FILES) $(LDFLAGS)
	avr-objcopy -O ihex main.elf main.hex
	avr-size main.elf

tinyAll:
	avr-gcc -g -mmcu=attiny85 -Os -Werror -mcall-prologues -fdata-sections -ffunction-sections -o main.elf $(FILES) $(LDFLAGS)
	avr-objcopy -O ihex main.elf main.hex
	avr-size main.elf

# This target first executes the "all" target to compile your code, and then programs the hex file into the ATmega using avrdude.

attiny: tinyAll
	avrdude -p attiny85 -v -c usbtiny  -u -U flash:w:main.hex
	rm main.elf
	rm main.hex

uno: 328all
	avrdude -V -p $(MCU) -P $(PORT) -b $(BRATE) -v -c $(ISP)  -u -U flash:w:main.hex
	rm main.elf
	rm main.hex

# This target can be called to delete any existing compiled files (binaries), so you know that your next compile is fresh.
# The dash in front of rm is not passed to the shell, and just tells make to keep running if an error code is returned by rm.
clean:
	-rm -f main.elf main.hex main.lss

asm: all
	avr-objdump -h -S main.elf > main.lss

#fuses:
# 	avrdude -v -c $(ISP) -p $(P_MCU) -P usb -U hfuse:w:0xD7:m -U lfuse:w:0xE7:m


