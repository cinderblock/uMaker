# Generate all of the paths needed for all nRF51 SDK header files.

# Since Nordic uses the non-standard format of not including the directories that
# each included file is actually in. So, instead, let's just add all of the paths
# to the AUTO_INC variable.

# Search only in the real source directory
nRF51SDK_SourcePath ?= $(nRF51SDK_BasePath)components/

# Find everything by default
NRF51_HEADERS ?= *

# Set this variable if you only use some
NRF51_HEADER_FILES ?= $(NRF51_HEADERS:%=%.h)

# Filter the header files that the soft device replaces
ifneq (,$(filter-out blank,$(NRF51_SOFTDEVICE_VERSION)))
 NRF51_HEADER_FILES_FILTER_OTHER ?= $(nRF51SDK_SourcePath)drivers_nrf/nrf_soc_nosd/
endif

# Soft device header locations to be filtered-out since they're included manually
NRF51_HEADER_FILES_FILTER ?= $(NRF51_SOFTDEVICE_DIR) $(NRF51_HEADER_FILES_FILTER_OTHER)

# Find all the files that we're searching for. This will work for either a list of
# specific files we're looking for, or match the wildcard default. Also, filter
# out the softdevice folder since that needs special handling
NRF51_HEADER_FILES_FULL ?= $(filter-out $(NRF51_HEADER_FILES_FILTER)%,$(foreach file,$(NRF51_HEADER_FILES),$(shell find $(nRF51SDK_SourcePath) -type f -name "$(file)")))

# We only want to include the directories of each of theses files, and ideally only once.
NRF51_INCLUDES ?= $(sort $(dir $(NRF51_HEADER_FILES_FULL)))

# Append to the list of files to include
AUTO_INC += $(NRF51_INCLUDES)
