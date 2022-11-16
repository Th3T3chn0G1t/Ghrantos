GLOBAL_C3_PREPROCESSOR_FLAGS += -DGEN_DISABLED=0 -DGEN_ENABLED=1
GLOBAL_C3_PREPROCESSOR_FLAGS += -DGEN_DEBUG=0 -DGEN_RELEASE=1 -DGEN_BUILD_MODE=GEN_$(MODE)
GLOBAL_C3_PREPROCESSOR_FLAGS += -DGEN_LINUX=0 -DGEN_OSX=1 -DGEN_WINDOWS=2 -DGEN_PLATFORM=GEN_$(PLATFORM)
GLOBAL_C3_PREPROCESSOR_FLAGS += $(EXTRA_C3_PREPROCESSOR_FLAGS)

GLOBAL_C3FLAGS_STDLIB += --stdlib $(subst $(eval) ,,$(foreach component,$(subst /, ,$(dir $<)),../))$(GHRANTOS_DIR)/ghrantos/vendor/c3c/lib
GLOBAL_C3FLAGS += $(EXTRA_C3FLAGS)

ifeq ($(MODE), DEBUG)
	GLOBAL_C3FLAGS += -g --safe -O0+
endif

ifeq ($(MODE), RELEASE)
	GLOBAL_C3FLAGS += -g0 --fast -O3+
endif

%$(OBJECT_SUFFIX):
	$(C3C) compile-only $(GLOBAL_C3FLAGS) $(C3FLAGS) -o $@ $(filter %.processed.c3,$^) `$(FIND) $(GHRANTOS_DIR)/tmp $(FIND_FNAME) "*.c3i"`

tmp/%.processed.c3: */%.c3 | $(GHRANTOS_DIR)/tmp
	$(PYTHON3) $(GHRANTOS_DIR)/ghrantos/vendor/C3Bridger/c3bridger.py $< -o $@ --odir $(GHRANTOS_DIR)/tmp $(GLOBAL_C3_PREPROCESSOR_FLAGS) $(C3_PREPROCESSOR_FLAGS)

# @$(ECHO) "$(ACTION_PREFIX)$(CD) $(dir $@) $(AND) $(C3C) compile-only $(GLOBAL_C3FLAGS) $(GLOBAL_C3FLAGS_STDLIB) $(C3FLAGS) -o $@ $(foreach component,$(subst /, ,$(dir $<)),../)$(GHRANTOS_DIR)/tmp/$(notdir $*.c3)$(ACTION_SUFFIX)"
# @$(CD) $(dir $@) $(AND) $(C3C) compile-only $(GLOBAL_C3FLAGS) $(GLOBAL_C3FLAGS_STDLIB) $(C3FLAGS) -o $@ $(subst $(eval) ,,$(foreach component,$(subst /, ,$(dir $<)),../))$(GHRANTOS_DIR)/tmp/$(notdir $*.c3)
# $(CD) $(dir $@) $(AND) $(C3C) compile-only $(GLOBAL_C3FLAGS) $(GLOBAL_C3FLAGS_STDLIB) $(C3FLAGS) -o $@ `find $(subst $(eval) ,,$(foreach component,$(subst /, ,$(dir $<)),../))$(GHRANTOS_DIR)/tmp/ -name "*.c3"`
