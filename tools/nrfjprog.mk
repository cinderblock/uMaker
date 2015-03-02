
nrfjprog: $(OUT_HEX)
	nrfjprog --erase --reset --program $(OUT_HEX) --snr $(SNR) --verify --programs softdevice.hex

.PHONY: nrfjprog
