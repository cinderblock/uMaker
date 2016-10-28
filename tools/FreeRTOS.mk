FREERTOS_BASEPORT ?= ATMega323

FREERTOS_BASEDIR ?= ../FreeRTOS/FreeRTOS/

FREERTOS_SRCDIR ?= $(FREERTOS_BASEDIR)Source/
FREERTOS_INCDIR ?= $(FREERTOS_SRCDIR)include/

FREERTOS_PORTDIR ?= $(FREERTOS_SRCDIR)portable/GCC/$(FREERTOS_BASEPORT)/

FREERTOS_BLDDIR ?= $(Build_Path)FreeRTOS/

# Folder that has your `portmacro.h`
FREERTOS_PORTINC ?= $(Source_Path)FreeRTOSinc
FREERTOS_PORTINC_DIR ?= $(FREERTOS_PORTINC)/

FREERTOS_PORTMACRO_HEADER_NAME ?= portmacro.h

FREERTOS_PORTMACRO_HEADER_FILE ?= $(FREERTOS_PORTINC_DIR)$(FREERTOS_PORTMACRO_HEADER_NAME)

FREERTOS_PORTDEFS_NAME ?= FreeRTOSPortDefinitions.c
FREERTOS_PORTDEFS_FILE ?= $(Source_Path)$(FREERTOS_PORTDEFS_NAME)

# Relative to FREERTOS_SRCDIR
FREERTOS_C ?= croutine event_groups list queue tasks timers portable/MemMang/heap_1
FREERTOS_SRC ?= $(FREERTOS_C:%=%.c)

FREERTOS_AR ?= FreeRTOS.a

FREERTOS_OBJS ?= $(FREERTOS_SRC:%=$(FREERTOS_BLDDIR)%.o)

FREERTOS_OUT ?= $(Build_LibPath)$(FREERTOS_AR)

FREERTOS_GCCFLAGS_FINAL ?= $(BLD_GCCFLAGS_FINAL) $(FREERTOS_GCCFLAGS_EXTRA)

AUTO_INC += $(FREERTOS_INCDIR) $(FREERTOS_PORTINC)

AUTO_LIB += $(FREERTOS_OUT)

AUTO_GCC += $(FREERTOS_PORTDEFS_FILE)

FREERTOS_TARGET ?= FreeRTOS-lib


##### Targets

$(FREERTOS_PORTDEFS_FILE): | $(dir $(FREERTOS_PORTDEFS_FILE)) $(FREERTOS_PORTDIR)port.c
	$(ECO) "FreeRTOS init	$@"
	cp -u $(FREERTOS_PORTDIR)port.c $@

$(FREERTOS_PORTMACRO_HEADER_FILE): | $(dir $(FREERTOS_PORTMACRO_HEADER_FILE)) $(FREERTOS_PORTDIR)portmacro.h
	$(ECO) "FreeRTOS init	$@"
	cp -u $(FREERTOS_PORTDIR)portmacro.h $@

$(FREERTOS_PORTDEFS_FILE:$(Source_Path)%=$(Build_Path)%.o): | $(FREERTOS_PORTMACRO_HEADER_FILE)

$(FREERTOS_BLDDIR)%.c.o: $(FREERTOS_SRCDIR)%.c | $(FREERTOS_PORTMACRO_HEADER_FILE)
	$(ECO) "FreeRTOS CC $@"
	$(BLD_GCC) $< -o $@ -c $(FREERTOS_GCCFLAGS_FINAL)

$(FREERTOS_OUT): $(FREERTOS_OBJS)
	$(ECO) "FreeRTOS AR	$@"
	$(BLD_ARR) $@ $(FREERTOS_OBJS)

$(FREERTOS_OUT) $(FREERTOS_OBJS): | $(MAKEFILE_LIST)

$(FREERTOS_TARGET): $(FREERTOS_OUT)

.PHONY: $(FREERTOS_TARGET)
.PRECIOUS: $(FREERTOS_OBJS)
.SECONDARY: $(FREERTOS_OUT)

# Explicitly include all our build dep files
FREERTOS_DEPFILES = $(FREERTOS_OBJS:$(Build_Path)%=$(Build_DepPath)%.d)
-include $(FREERTOS_DEPFILES)

AUTO_GENERATED_FILES += $(FREERTOS_OUT) $(FREERTOS_OBJS) $(FREERTOS_DEPFILES) $(FREERTOS_PORTMACRO_HEADER_FILE) $(FREERTOS_PORTDEFS_FILE)
