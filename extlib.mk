
# Create object files from Lib's Makefile
$(LIBDIR)/%.a: 
	$(ECO) "Lib: $@"
	$(ECO) $(MAKE) -c $($*_DIR) -f $($*_DIR)/Makefile \
	-Rrs MCU=$(MCU) LIBOUT="$(abspath $@)" "$(abspath $@)"
