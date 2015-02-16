# This file looks at the AUTO_GENERATED_FILES variable and adds directory creation
# dependencies to each

MKDIR_FILES ?= $(sort $(AUTO_GENERATED_FILES))
MKDIR_DIRS ?= $(sort $(dir $(MKDIR_FILES)))

# Older version of make strip trailing '/' from targets unless they're explicitly declared as targets.
$(MKDIR_DIRS):
#	$(ECO) "MKDIR	$@"
#	$(MKD) $@

# Directories should always end in '/' so you can do things like this
%/:
	$(ECO) "MKDIR	$@"
	$(MKD) $@

# Each file that we care about (aka generated files) should depend on its directory
.SECONDEXPANSION:
$(MKDIR_FILES): | $$(dir $$@)
