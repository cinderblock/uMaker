
# Convert ELF to COFF for use in debugging / simulating in AVR Studio or VMLAB.

COFF_OUT ?= $(OUT_DIR)$(TARGET).cof

COFF_TYPE ?= coff-avr
COFF_TYPE ?= coff-ext-avr

COFF_FLAGS_REQUIRED  = --debugging
COFF_FLAGS_REQUIRED += --change-section-address .data-0x800000
COFF_FLAGS_REQUIRED += --change-section-address .bss-0x800000
COFF_FLAGS_REQUIRED += --change-section-address .noinit-0x800000
COFF_FLAGS_REQUIRED += --change-section-address .eeprom-0x810000

COFF_FLAGS ?= -O $(COFF_TYPE) $(COFF_FLAGS_REQUIRED) $(COFF_FLAGS_EXTRA)

$(COFF_OUT): $(OUT_ELF)
	$(ECO) "COFF	$@"
	$(BLD_OCP) $< $@ $(COFF_FLAGS)
