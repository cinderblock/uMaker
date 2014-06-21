# This Makefile, unlike most others, is reaally only intended to be used once.
# It will copy the necessary template files from the base nRF folder.


NRF_INIT_FILES_BASE ?= system_nrf51422.c gcc/gcc_startup_nrf51.s gcc/gcc_nrf51_common.ld gcc/gcc_nrf51_s110_xxaa.ld

NRF_INIT_FILES ?= $(NRF_INIT_FILES:%=$(NRF_INITDIR)%)

##### Targets

nRFinit: $(NRF_INIT_FILES)

$(NRF_INITDIR)%:
	$(ECO) "cp nRF	$@"
	cp $(@:$(NRF_INITDIR)=$(NRF_TEMPLATE_DIR)) $@

.SECONDARY: $(NRF_INIT_FILES)

# Add directory targets to those that need them
.SECONDEXPANSION:
$(NRF_INIT_FILES): | $$(dir $$@)
