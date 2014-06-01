fuse: $(OUTDIR)/$(TARGET).elf
	avr-objcopy -j .fuse -O ihex $(OUTDIR)/$(TARGET).elf $(OUTDIR)/fuses.hex --change-section-lma .fuse=0
	srec_cat $(OUTDIR)/fuses.hex -Intel -crop 0x00 0x01 -offset  0x00 -O $(OUTDIR)/lfuse.hex -Intel
	srec_cat $(OUTDIR)/fuses.hex -Intel -crop 0x01 0x02 -offset -0x01 -O $(OUTDIR)/hfuse.hex -Intel
	srec_cat $(OUTDIR)/fuses.hex -Intel -crop 0x02 0x03 -offset -0x02 -O $(OUTDIR)/efuse.hex -Intel
	@$(AVRDUDE) $(AVRDUDE_FLAGS) $(AVRDUDE_WRITE_FUSES)

