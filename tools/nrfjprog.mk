
nrfjprog: $(OUT_HEX)
	nrfjprog --eraseall
	nrfjprog --program $(OUT_HEX) --verify
	nrfjprog --pinreset

.PHONY: nrfjprog
