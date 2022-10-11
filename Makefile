C3C ?= c3c
PERL ?= perl
PYTHON3 ?= python3

GENSTONE_DIR = ghrantos/vendor/Genstone
GHRANTOS_DIR = .

include $(GENSTONE_DIR)/build/common.mk
include $(GHRANTOS_DIR)/build/c3.mk
include $(GHRANTOS_DIR)/ghrantos/ghrantos.mk

.PHONY: all
.DEFAULT_GOAL := all
all: $(MODULE_NAMES) ghrantos

.PHONY: clean
clean: $(CLEAN_TARGETS) clean_ghrantos
	@$(ECHO) "$(ACTION_PREFIX)"
	-$(RMDIR) $(GHRANTOS_DIR)/tmp
	-$(RMDIR) $(GHRANTOS_DIR)/lib
	@$(ECHO) "$(ACTION_SUFFIX)"

.PHONY: test
test: all $(TEST_TARGETS) test_ghrantos

$(GHRANTOS_DIR)/tmp $(GHRANTOS_DIR)/lib:
	@$(ECHO) "$(ACTION_PREFIX)$(MKDIR) $@$(ACTION_SUFFIX)"
	-@$(MKDIR) $@
