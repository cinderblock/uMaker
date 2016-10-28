
FUSE_OUT ?= $(Build_OutputPath)/fuses.hex

FUSE_OUT_L ?= $(Build_OutputPath)/lfuse.hex
FUSE_OUT_H ?= $(Build_OutputPath)/hfuse.hex
FUSE_OUT_E ?= $(Build_OutputPath)/efuse.hex

fuse: $(FUSE_OUT)

$(FUSE_OUT): $(OUT_ELF)
	$(BLD_OCP) -j .fuse -O ihex $< $@ --change-section-lma .fuse=0

$(FUSE_OUT_L): $(FUSE_OUT)
	srec_cat $< -Intel -crop 0x00 0x01 -offset  0x00 -O $@ -Intel

$(FUSE_OUT_H): $(FUSE_OUT)
	srec_cat $< -Intel -crop 0x01 0x02 -offset -0x01 -O $@ -Intel

$(FUSE_OUT_E): $(FUSE_OUT)
	srec_cat $< -Intel -crop 0x02 0x03 -offset -0x02 -O $@ -Intel

avrdude-fuse: $(FUSE_OUT_L) $(FUSE_OUT_H) $(FUSE_OUT_E)
	$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FUSES)

.PRECIOUS: $(FUSE_OUT)
.SECONDARY: $(FUSE_OUT_L) $(FUSE_OUT_H) $(FUSE_OUT_E)

.PHONY: fuse avrdude-fuse