# Cygwin example
# TEENSYDIR = /cygdrive/c/Program\ Files/Arduino/hardware/tools

# Linux example
TEENSYDIR = /home/urjaman/fakeduino/arduino-1.0.6/hardware/tools

TCDIR = $(TEENSYDIR)/arm-none-eabi/bin/

CDEPS = Makefile

TARGET = main

OPTIONS = -DF_CPU=48000000 -DUSB_SERIAL -D__MK20DX256__ -DTEENSYDUINO=120
CFLAGS = -Wall -g -Os -mcpu=cortex-m4 -mthumb -nostdlib -fno-strict-aliasing -Ilib $(OPTIONS)
CXXFLAGS = -std=gnu++0x -felide-constructors -fno-exceptions -fno-rtti $(OPTIONS)
LDFLAGS = -Os -Wl,--gc-sections -Wl,--relax -mcpu=cortex-m4 -mthumb -Tlib/mk20dx256.ld
LIBS = -lm


CC = $(TCDIR)arm-none-eabi-gcc
CXX = $(TCDIR)arm-none-eabi-g++
AR = $(TCDIR)arm-none-eabi-ar
SIZE = $(TCDIR)arm-none-eabi-size
OBJCOPY = $(TCDIR)arm-none-eabi-objcopy

export OPTIONS CFLAGS CXXFLAGS TCDIR CC CXX AR

DEPS = $(CDEPS) main.h flash.h mybool.h uart.h
SOURCES = main.c uart.c flash.c spihw.c

include libfrser/Makefile.frser
include libfrser/Makefile.spilib
include libfrser/Makefile.lpcfwh



all: $(TARGET).hex

lib/core.a: $(CDEPS)
	cd lib && make clean && $(MAKE)

$(TARGET).elf: $(SOURCES) $(DEPS) lib/mk20dx256.ld lib/core.a
	$(CC) $(CFLAGS) $(LDFLAGS) -I.  -o $@ $(SOURCES) $(LIBS) lib/core.a


#$(TARGET).elf: local.o lib/mk20dx256.ld lib/core.a
#	$(CC) $(LDFLAGS) -o $@ local.o $(LIBS) lib/core.a

#local.o: $(SOURCES) $(DEPS)
#	$(CC) $(CFLAGS) -flto -c -o local.o $(SOURCES)


%.hex: %.elf
	$(SIZE) $<
	$(OBJCOPY) -O ihex -R .eeprom $< $@

program-win: $(TARGET).hex
	$(TEENSYDIR)/teensy_post_compile -file=$(basename $@) -path="$(shell cygpath -w `pwd`)" -tools="$(shell cygpath -w $(TEENSYDIR))"
	-$(TEENSYDIR)/teensy_reboot

program-cli: $(TARGET).hex
	teensy_loader_cli -mmcu=mk20dx256 -w $(TARGET).hex

clean:
	$(MAKE) -C lib clean
	-rm -rf *.o $(TARGET).elf $(TARGET).hex

objdump: $(TARGET).elf
	$(TCDIR)arm-none-eabi-objdump -xdSC $(TARGET).elf | less
