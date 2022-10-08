GLOBAL_C3_PREPROCESSOR_FLAGS += -fno-blocks
GLOBAL_C3_PREPROCESSOR_FLAGS += -DGEN_DISABLED=0 -DGEN_ENABLED=1
GLOBAL_C3_PREPROCESSOR_FLAGS += -DGEN_DEBUG=0 -DGEN_RELEASE=1 -DGEN_BUILD_MODE=GEN_$(MODE)
GLOBAL_C3_PREPROCESSOR_FLAGS += -DGEN_LINUX=0 -DGEN_OSX=1 -DGEN_WINDOWS=2 -DGEN_C3_COMPAT=-1 -DGEN_PLATFORM=GEN_C3_COMPAT -DC3_GEN_PLATFORM=GEN_$(PLATFORM)
GLOBAL_C3_PREPROCESSOR_FLAGS += $(EXTRA_C3_PREPROCESSOR_FLAGS)

GLOBAL_C3FLAGS += $(EXTRA_C3FLAGS)

ifeq ($(MODE), DEBUG)
	GLOBAL_C3FLAGS += -g -O0 --safe
endif

ifeq ($(MODE), RELEASE)
	GLOBAL_C3FLAGS += -g0 -O3 --fast
endif

# TODO: Investigate way to precompile stdlib
%$(OBJECT_SUFFIX): %.c3 | $(GHRANTOS_DIR)/tmp
	@$(ECHO) "$(ACTION_PREFIX)$(CLANG) -xc $(GLOBAL_C3_PREPROCESSOR_FLAGS) $(C3_PREPROCESSOR_FLAGS) -E -o $(GHRANTOS_DIR)/tmp/$(notdir $*.i) $<$(ACTION_SUFFIX)"
	@$(CLANG) -xc $(GLOBAL_C3_PREPROCESSOR_FLAGS) $(C3_PREPROCESSOR_FLAGS) -E -o $(GHRANTOS_DIR)/tmp/$(notdir $*.i) $<

	@$(ECHO) "$(ACTION_PREFIX)"
	$(CAT) $(GHRANTOS_DIR)/tmp/$(notdir $*.i) \
	| $(PERL) -pe 's/^#.*$$//g' \
	| $(PERL) -pe 's/\bextern\s+(.+)\);/extern fn \1);/g' \
	| $(PERL) -pe 's/\binline\b/fn/g' \
	| $(PERL) -pe 's/->/./g' \
	| $(PERL) -pe 's/\b__asm\s*\((\s*".*"\s*)+\)//g' \
	| $(PERL) -0777pe 's/\s*int\s+scandir\([\w*()\s,]+\)\s*;/\ndefine scandir_fn_0_t = fn int(dirent_t**, dirent_t**);\ndefine scandir_fn_1_t = fn int(dirent_t*);\nint scandir(char*, dirent_t***, scandir_fn_0_t, scandir_fn_1_t);\n/gs' \
	| $(PERL) -pe 's/extern\s+(.+)\s+([A-Z]\w+[^)]);/extern \1 g_\2;/g' \
	| $(PERL) -pe 's/extern int optind, opterr, optopt;/extern int optind; extern int opterr; extern int optopt;/g' \
	| $(PERL) -pe 's/\blong\s+unsigned\b/ulong/g' \
	| $(PERL) -pe 's/\blong\s+long\b/long/g' \
	| $(PERL) -pe 's/\b(signed|const|restrict|_Noreturn)\b//g' \
	| $(PERL) -pe 's/\b_Bool\b/bool/g' \
	| $(PERL) -pe 's/__attribute__\s*\(\(.+\)\)//g' \
	| $(PERL) -pe 's/\b__builtin_va_list\b/void/g' \
	| $(PERL) -pe 's/\bunsigned\s+/u/g' \
	| $(PERL) -pe 's/\b(long|short)\s+int\b/\1/g' \
	| $(PERL) -pe 's/\b(long|short)\s+uint\b/\1/g' \
	| $(PERL) -pe 's/\b(ulong|ushort)\s+int\b/\1/g' \
	| $(PERL) -pe 's/\b(ulong|ushort)\s+uint\b/\1/g' \
	| $(PERL) -pe 's/\blong\s+double\b/void/g' \
	| $(PERL) -pe 's/\buchar\b/char/g' \
	| $(PERL) -pe 's/([^\$$])sizeof\((\w+)\)/\1\2.sizeof/g' \
	| $(PERL) -pe 's/\(void\)/()/g' \
	| $(PERL) -0777pe 's/\b(\w+)_t\b/C_\1_t/gs' \
	| $(PERL) -0777pe 's/\btypedef\s+(struct|union|enum)\s+(\w+)\n/typedef \1 \2 /g' \
	| $(PERL) -0777pe 's/\btypedef\s+(struct|union|enum)\s*\n/typedef \1 \2 /g' \
	| $(PERL) -0777pe 's/\btypedef\s+([\w*\s]+)([\s*]+)(\w+);/define \3 = \1\2;/g' \
	| $(PERL) -0777pe 's/\btypedef\s+([\w*\s]+)\s+(\w+)(\[.+\]);/define \2 = \1\3;/g' \
	| $(PERL) -0777pe 's/\btypedef\s+enum\s*{([\w\s,=<]*)}\s+(\w+);/enum \2 {\1}/gs' \
	| $(PERL) -0777pe 's/\btypedef\s+(struct|union)\s*{([\w*\[\];\s+]*)}\s+(\w+);/\1 \3 {\2}/gs' \
	| $(PERL) -0777pe 's/\btypedef\s+([\w\s*]+)\s*\([\*\s]*([\w\s]+)\)\s*(\([^\n]*\))/define \2 = fn \1\3/g' \
	| $(PERL) -0777pe 's/\b(struct|union)\s+(?!C_)/\1 C_\2/gs' \
	| $(PERL) -pe 's/^(struct|union)\s+(\w+);/define \2 = void*;/g' \
	| $(PERL) -pe 's/\bdefine\s+((?!C_)\w+)/define C_\1/g' \
	| $(PERL) -pe 's/\b(\w+)([\s*]+)(\w+)\s*(\[.+\]);/\1\2\4 \3;/g' \
	| $(PERL) -0777pe 's/\b(struct|union)\s+(\w+)\s+{([\w*\[\];\s+]*;)*\s*([\w*]+)\s*\(\**([\w]+)\)\s*(\([^\n]*\));/define \2_\5 = fn \4 \6;\n\1 \2 {\3 \2_\5 \5;/gs' \
	| $(PERL) -pe 's/([^^])(struct|union)\s+(\w+)/\1\3/g' \
	| $(PERL) -pe 's/\bC_(\w+)(?<!_t)\b/C_\1\2_t/g' \
	| $(PERL) -0777pe 's/\b(struct|union)\s+(\w+)\s+\{([\w*\[\];\s+\n]*;)*\s*\};/\1 \2 {\3}/gs' \
	| $(PERL) -pe 's/\btypedef\s+(\w+)\s*{/struct \1 {/g' \
	| $(PERL) -0777pe 's/\b(struct|union)\s+C_(\w+)_t\s*{(.*)}\s*\2;/\1 C_\2_t {\3}/gs' \
	| $(PERL) -pe 's/\b(\w+\s*\**)\s*\b(\w+)\s*\[\]/\1* \2/g' \
	| $(PERL) -pe 's/^\s+//g' \
	| $(PERL) -pe 's/^((?!(return|macro))[\w]+)([\s*]+)(\w+)\(/extern fn \1\2\3 \4(/g' \
	| $(PERL) -pe 's/\bdefine\s+(\w+)\s*=\s*\1/define \1 = void/g' \
	| $(PERL) -pe 's/^([A-Z_]+)\s*=.*$$/\1,/g' \
	| $(PERL) -pe 's/\bva_list\s+\w+\s*\)/...)/g' \
	| $(PERL) -pe 's/([0-9]+)UL/\1u64/g' \
	| $(PERL) -pe 's/\bDIR\b/C_DIR_t/g' \
	| $(PERL) -pe 's/\bfd_set\b/C_fd_set_t/g' \
	| $(PERL) -pe 's/(,?)\s*([\w\s*]+)([\s*]+)(\w+)\[([0-9]+)\]/\1\2\3[\5] \4/g' \
	| $(PERL) -pe 's/_Exit\(int\)\s*;/__c3_Exit(int) \@extname("_Exit");/g' \
	| $(PERL) -pe 's/\bstruct\s+C_dirent_t([\s*]+)readdir/extern fn C_dirent_t\1 readdir/g' \
	| $(PERL) -0777pe 's/\buint\s+(alarm|sleep)\s*\(uint\)\s*;/extern fn uint \1(uint);/gs' \
	| $(PERL) -0777pe 's/\benum\s+(\w+)\s*{\s*(([A-Z_]+,?\s*)+)};/enum \1 {\2}/gs' \
	| $(PERL) -pe 's/\bFILE\*/C_FILE_t\*/g' \
	| $(PERL) -pe 's/\bC3_(const|inline)\b/\1/g' \
	| $(ADDITIONAL_C2C3_PASS) \
	| $(PERL) -pe 's/^extern fn ([\w\s*]+)([\s*]+)(\w+)\b(.*);$$/\$$if (!\$$defined(C_C3_block_def_\3_t)): extern fn \1\2\3\4; \$$endif;/g' \
	> $(GHRANTOS_DIR)/tmp/$(notdir $*.c3)
	@$(ECHO) "$(ACTION_SUFFIX)"

	@$(ECHO) "$(ACTION_PREFIX)$(CD) $(dir $@) $(AND) $(C3C) compile-only $(GLOBAL_C3FLAGS) $(C3FLAGS) -o $@ $(foreach component,$(subst /, ,$(dir $<)),../)$(GHRANTOS_DIR)/tmp/$(notdir $*.c3)$(ACTION_SUFFIX)"
	@$(CD) $(dir $@) $(AND) $(C3C) compile-only $(GLOBAL_C3FLAGS) $(C3FLAGS) -o $@ $(subst $(eval) ,,$(foreach component,$(subst /, ,$(dir $<)),../))$(GHRANTOS_DIR)/tmp/$(notdir $*.c3)
