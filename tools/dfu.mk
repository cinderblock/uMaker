# This file will contain all targets and commands necessary to run dfu-programmer

DFU_HEX ?= $(OUT_HEX)
DFU_TARGET ?= $(MCU)

DFU ?= dfu-programmer

DFU_TARGETED ?= $(DFU) $(DFU_TARGET)

dfu-flash: $(DFU_HEX)
	$(ECO) Flashing	$(DFU_HEX)
	$(DFU_TARGETED) flash --force $(DFU_HEX)

dfu-erase:
	$(ECO) Erasing $(DFU_TARGET)
	$(DFU_TARGETED) erase || exit 0

dfu-reset:
	$(DFU_TARGETED) reset

dfu-start:
	$(DFU_TARGETED) start

.PHONY: dfu-flash dfu-reset dfu-start dfu-erase
