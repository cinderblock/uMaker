
nRFjProg_SoftDevice_File ?= softdevice/softdevice.hex

nRFjProg_ProgrammerSerialNumber ?= 

nrfjprog: $(OUT_HEX)
	nrfjprog --erase --reset --program $(OUT_HEX) --snr $(nRFjProg_ProgrammerSerialNumber) --verify --programs $(nRFjProg_SoftDevice_File)

.PHONY: nrfjprog
