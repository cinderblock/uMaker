# This file will contain all targets and commands necessary to run avrdude.

# TODO: Rewrite this crap


#---------------- Programming Options (avrdude) ----------------

# Programming hardware
# Type: avrdude -c ?
# to get a full listing.
#
AVRDUDE_PROGRAMMER = usbtiny
#AVRDUDE_PROGRAMMER = arduino

# com1 = serial port. Use lpt1 to connect to parallel port.
AVRDUDE_PORT = USB
#AVRDUDE_PORT = /dev/ttyUSB0
#AVRDUDE_PORT = COM29


AVRDUDE_WRITE_FLASH  = -U  flash:w:$(HEXOUT)
#AVRDUDE_WRITE_EEPROM = -U eeprom:w:$(EPPOUT)
AVRDUDE_WRITE_FUSES = -U hfuse:w:$(OUTDIR)/hfuse.hex:i -U lfuse:w:$(OUTDIR)/lfuse.hex:i -U efuse:w:$(OUTDIR)/efuse.hex:i


#AVRDUDE_BITCLOCK = 10
AVRDUDE_BITCLOCK = 1

#AVRDUDE_BAUD = 1000000

# Uncomment the following if you want avrdude's erase cycle counter.
# Note that this counter needs to be initialized first using -Yn,
# see avrdude manual.
#AVRDUDE_ERASE_COUNTER = -y

# Uncomment the following if you do /not/ wish a verification to be
# performed after programming the device.
#AVRDUDE_NO_VERIFY = -V

# Increase verbosity level.  Please use this when submitting bug
# reports about avrdude. See <http://savannah.nongnu.org/projects/avrdude>
# to submit bug reports.
#AVRDUDE_VERBOSE = -v

#AVRDUDE_QUIET = -qq

AVRDUDE_FLAGS = -p $(MCU) -P $(AVRDUDE_PORT) -c $(AVRDUDE_PROGRAMMER)
AVRDUDE_FLAGS += $(AVRDUDE_NO_VERIFY)
AVRDUDE_FLAGS += $(AVRDUDE_VERBOSE)
AVRDUDE_FLAGS += $(AVRDUDE_QUIET)
AVRDUDE_FLAGS += $(AVRDUDE_ERASE_COUNTER)
ifdef AVRDUDE_BITCLOCK
AVRDUDE_FLAGS += -B $(AVRDUDE_BITCLOCK)
endif
ifdef AVRDUDE_BAUD
AVRDUDE_FLAGS += -b $(AVRDUDE_BAUD)
endif

avrdude-test:
	$(AVRDUDE) $(AVRDUDE_FLAGS)

# Program the device.
program: $(HEXOUT) $(EPPOUT)
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FLASH) $(AVRDUDE_WRITE_EEPROM)