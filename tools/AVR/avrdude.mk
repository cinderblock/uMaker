# This file will contain all targets and commands necessary to run avrdude.

# TODO: Rewrite this crap


AVRDUDE ?= avrdude

AVRDUDE_PROGRAMMER ?= usbtiny

# Set these in YOUR makefile
#AVRDUDE_PORT = USB
#AVRDUDE_PORT = /dev/ttyUSB0
#AVRDUDE_PORT = COM29

#AVRDUDE_BITCLOCK = 10
#AVRDUDE_BITCLOCK = 1

#AVRDUDE_BAUD = 57600


AVRDUDE_WRITE_FLASH ?= -U flash:w:$(OUT_HEX)
#AVRDUDE_WRITE_EEPROM = -U eeprom:w:$(OUT_EEP)
AVRDUDE_WRITE_FUSES ?= -U hfuse:w:$(OUT_DIR)/hfuse.hex:i -U lfuse:w:$(OUT_DIR)/lfuse.hex:i -U efuse:w:$(OUT_DIR)/efuse.hex:i



AVRDUDE_FLAGS_REQUIRED ?= -p $(MCU) -c $(AVRDUDE_PROGRAMMER)

AVRDUDE_FLAGS_STANDARD ?= 

ifdef AVRDUDE_BITCLOCK
 AVRDUDE_FLAGS_AUTO += -B $(AVRDUDE_BITCLOCK)
endif

ifdef AVRDUDE_BAUD
 AVRDUDE_FLAGS_AUTO += -b $(AVRDUDE_BAUD)
endif

ifdef AVRDUDE_PORT
 AVRDUDE_FLAGS_AUTO += -P $(AVRDUDE_PORT)
endif

AVRDUDE_FLAGS_BASE ?= $(AVRDUDE_FLAGS_REQUIRED) $(AVRDUDE_FLAGS_STANDARD) $(AVRDUDE_FLAGS_AUTO)

avrdude-test:
	$(AVRDUDE) $(AVRDUDE_FLAGS_BASE)

# Program the device.
avrdude-flash: $(OUT_HEX)
	$(AVRDUDE) $(AVRDUDE_FLAGS_BASE) $(AVRDUDE_WRITE_FLASH)

# Program the device.
avrdude-eeprom: $(OUT_EEP)
	$(AVRDUDE) $(AVRDUDE_FLAGS_BASE) $(AVRDUDE_WRITE_EEPROM)

.PHONY: avrdude-eeprom avrdude-flash avrdude-test