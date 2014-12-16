
FREERTOS_BASEDIR ?= ../FreeRTOS/FreeRTOS/

FREERTOS_SRCDIR ?= $(FREERTOS_BASEDIR)Source/
FREERTOS_INCDIR ?= $(FREERTOS_SRCDIR)include/

FREERTOS_BLDDIR ?= $(BLD_DIR)FreeRTOS/

# Folder that has your `portmacro.h`
FREERTOS_EXTRA_INCLUDES ?= $(SRCDIR)FreeRTOSinc

# Relative to FREERTOS_SRCDIR
FREERTOS_C ?= croutine event_groups list queue tasks timers
FREERTOS_SRC ?= $(FREERTOS_C:%=%.c)

FREERTOS_AR ?= FreeRTOS.a

FREERTOS_OBJS ?= $(FREERTOS_SRC:%=$(FREERTOS_BLDDIR)%.o)

FREERTOS_OUT ?= $(BLD_LIBDIR)$(FREERTOS_AR)

FREERTOS_GCCFLAGS_FINAL ?= $(BLD_GCCFLAGS_FINAL) $(FREERTOS_GCCFLAGS_EXTRA)

AUTO_INC += $(FREERTOS_INCDIR) $(FREERTOS_EXTRA_INCLUDES)

AUTO_LIB += $(FREERTOS_OUT)


##### Targets

$(FREERTOS_BLDDIR)%.c.o: $(FREERTOS_SRCDIR)%.c
	$(ECO) "FreeRTOS	CC $@"
	$(BLD_GCC) $< -o $@ $(FREERTOS_GCCFLAGS_FINAL)

$(FREERTOS_OUT): $(FREERTOS_OBJS)
	$(ECO) "FreeRTOS AR	$@"
	$(BLD_ARR) $@ $(FREERTOS_OBJS)

$(FREERTOS_OUT) $(FREERTOS_OBJS): | $(MAKEFILE_LIST)

FreeRTOS-lib: $(FREERTOS_OUT)

.PHONY: FreeRTOS-lib
.PRECIOUS: $(FREERTOS_OBJS)
.SECONDARY: $(FREERTOS_OUT)

# Explicitly include all our build dep files
FREERTOS_DEPFILES = $(FREERTOS_OBJS:$(BLD_DIR)%=$(BLD_DEPDIR)%.d)
-include $(FREERTOS_DEPFILES)

# Older version of make strip trailing '/' from targets unless they're explicitly declared
$(sort $(dir $(FREERTOS_OUT) $(FREERTOS_OBJS) $(FREERTOS_DEPFILES))):
	$(ECO) "MKDIR	$@"
	$(MKD) $@

# Add directory targets to those that need them
.SECONDEXPANSION:
$(FREERTOS_OUT) $(FREERTOS_OBJS) $(FREERTOS_DEPFILES): | $$(dir $$@)
