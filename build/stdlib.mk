C3_STDLIB = $(GHRANTOS_DIR)/lib/$(LIB_PREFIX)stdc3$(STATIC_LIB_SUFFIX)
C3_STDLIB_DIR = $(GHRANTOS_DIR)/ghrantos/vendor/c3c/lib/std/

C3_STDLIB_SOURCES = $(wildcard $(C3_STDLIB_DIR)*.c3) \
					$(wildcard $(C3_STDLIB_DIR)hash/*.c3) \
					$(wildcard $(C3_STDLIB_DIR)core/*.c3) \
					$(wildcard $(C3_STDLIB_DIR)core/allocators/*.c3) \
					$(wildcard $(C3_STDLIB_DIR)core/os/*.c3)

# TODO: \`\` shell eval probably doesn't work on Windows
$(C3_STDLIB): $(C3_STDLIB_SOURCES) $(GHRANTOS_OBJECTS) | $(GHRANTOS_DIR)/lib
	@$(ECHO) "$(ACTION_PREFIX)$(C3C) compile-only --obj-out $(C3_STDLIB_DIR) -o $(subst $(STATIC_LIB_SUFFIX),,$@) $(filter %c3,$^) $(GLOBAL_C3FLAGS)$(ACTION_SUFFIX)"
	@$(C3C) compile-only --obj-out $(C3_STDLIB_DIR) -o $(subst $(STATIC_LIB_SUFFIX),,$@) $(filter %c3,$^) $(GLOBAL_C3FLAGS)
	@$(ECHO) "$(ACTION_PREFIX)$(AR) -r -c $@ `$(FIND) $(GHRANTOS_DIR) $(FIND_FNAME) "*.p.*.o"` `$(FIND) $(C3_STDLIB_DIR) $(FIND_FNAME) "*.o"`$(ACTION_SUFFIX)"
	@$(AR) -r -c $@ `$(FIND) $(GHRANTOS_DIR) $(FIND_FNAME) "std.*.o"` `$(FIND) $(C3_STDLIB_DIR) $(FIND_FNAME) "*.o"` 