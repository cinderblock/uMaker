# This tool copies nRF51 required common build files to the local directory if they do not exist.


# Catch this now
ifneq ($(VARS_INCLUDE),nRF51)
$(error You need to include vars/nRF51.mk \(or equivalent\) to use this uMaker tool)
endif

nRF51SDK_SourcePath ?= $(nRF51SDK_BasePath)components/

# This matches the folder name that Nordic assigns
NRF51_TOOLCHAIN_DIRNAME ?= toolchain

NRF51_TOOLCHAIN_BASEDIR ?= $(nRF51SDK_SourcePath)$(NRF51_TOOLCHAIN_DIRNAME)/

NRF51_TOOLCHAIN_HEADERS ?= $(NRF51_TOOLCHAIN_BASEDIR) $(NRF51_TOOLCHAIN_BASEDIR)gcc/

AUTO_INC += $(NRF51_TOOLCHAIN_HEADERS)

NRF51_TOOLCHAIN_LINK_DIR ?= $(NRF51_TOOLCHAIN_BASEDIR)gcc/

# Files that we need to copy to the source directory
NRF51_TOOLCHAIN_SRCSDK ?= system_$(DEVICESERIES).c gcc/gcc_startup_nrf51.s
NRF51_TOOLCHAIN_SRC ?= $(notdir $(NRF51_TOOLCHAIN_SRCSDK))

# Directory to copy the toolchain's init files to
NRF51_TOOLCHAIN_SRCDIR ?= $(Source_Path)nRF51/

NRF51_TOOLCHAIN_SRC_FULL ?= $(NRF51_TOOLCHAIN_SRC:%=$(NRF51_TOOLCHAIN_SRCDIR)%)

# Instead of compiling these sources ourselves, lets just let the build.mk script do this for us
AUTO_GCC += $(filter %.c,$(NRF51_TOOLCHAIN_SRC_FULL))
AUTO_ASM += $(filter %.s,$(NRF51_TOOLCHAIN_SRC_FULL))

# This uMaker script will create some source files if they don't already exist
# so add them to this list so that directories can be created.
AUTO_GENERATED_FILES += $(NRF51_TOOLCHAIN_SRC_FULL)

##### Targets

# Copy from BASEDIR to Source_Path
$(NRF51_TOOLCHAIN_SRCDIR)%:
	$(ECO) "nRF51 copy	$@"
	cp -u $(shell find $(NRF51_TOOLCHAIN_BASEDIR) -type f -name "$*") $@

# A convenience target for initializing our source files
nRF51/toolchain/copy: $(NRF51_TOOLCHAIN_SRC_FULL)

.PHONY: nRF51/toolchain/copy
