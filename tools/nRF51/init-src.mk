# This Makefile, unlike most others, is reaally only intended to be used once.
# It will copy the necessary template files from the base nRF folder.

ifneq ($(VARS_INCLUDE),nRF51)
 $(error You need to include vars/nRF51.mk \(or equivalent\) to use this uMaker tool)
endif

NRF51_INIT_FILES_BASE ?= system_nrf51422.c gcc/gcc_startup_nrf51.s gcc/gcc_nrf51_common.ld gcc/gcc_nrf51_s110_xxaa.ld

NRF51_INIT_FILES ?= $(NRF51_INIT_FILES_BASE:%=$(NRF51_INITDIR)%)

##### Targets

nRF51-init-src: $(NRF51_INIT_FILES)

$(NRF_INITDIR)%:
	$(ECO) "cp nRF	$@"
	echo BLAH cp $(@:$(NRF51_INITDIR)=$(NRF51_TEMPLATE_DIR)) $@

.SECONDARY: $(NRF51_INIT_FILES)

.PHONY: nRF51-init-src

# Add directory targets to those that need them
.SECONDEXPANSION:
$(NRF51_INIT_FILES): | $$(dir $$@)
