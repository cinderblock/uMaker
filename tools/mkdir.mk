# This file looks at the AUTO_GENERATED_FILES variable and adds directory creation
# dependencies to each

mkdirBinary ?= mkdir
mkdirCommand ?= $(mkdirBinary) -p

MKDIR_FILES ?= $(sort $(AUTO_GENERATED_FILES))
MKDIR_DIRS ?= $(sort $(realpath $(filter-out ./,$(dir $(MKDIR_FILES)))))

$(MKDIR_DIRS):
	$(ECO) "MKDIR	$@"
	$(mkdirCommand) $@

# Each file that we care about (aka generated files) should depend on its directory
.SECONDEXPANSION:
$(MKDIR_FILES): | $$(filter-out .,$$(realpath $$(dir $$@)))
