C3_STDLIB = $(GHRANTOS_DIR)/lib/$(LIB_PREFIX)stdc3$(STATIC_LIB_SUFFIX)
C3_STDLIB_DIR = $(GHRANTOS_DIR)/ghrantos/vendor/c3c/lib/std/

C3_STDLIB_SOURCES = $(wildcard $(C3_STDLIB_DIR)*.c3) \
					$(wildcard $(C3_STDLIB_DIR)hash/*.c3) \
					$(wildcard $(C3_STDLIB_DIR)core/*.c3) \
					$(wildcard $(C3_STDLIB_DIR)core/allocators/*.c3) \
					$(wildcard $(C3_STDLIB_DIR)core/os/*.c3)

ifeq ($(MODE), DEBUG)
	C3_STDLIB_FLAGS += -O0+
endif

ifeq ($(MODE), RELEASE)
	C3_STDLIB_FLAGS += -O3+
endif

$(C3_STDLIB): $(C3_STDLIB_SOURCES) | $(GHRANTOS_DIR)/lib
	@$(ECHO) "$(ACTION_PREFIX)$(C3C) static-lib -o $(subst $(STATIC_LIB_SUFFIX),,$@) $(filter %c3,$^) $(GLOBAL_C3FLAGS) $(C3_STDLIB_FLAGS)$(ACTION_SUFFIX)"
	@$(C3C) static-lib -o $(subst $(STATIC_LIB_SUFFIX),,$@) $(filter %c3,$^) $(GLOBAL_C3FLAGS) $(C3_STDLIB_FLAGS)
