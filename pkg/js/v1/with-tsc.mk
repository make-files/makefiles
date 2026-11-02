# JS_TSC_REQ is a space separated list of prerequisites needed to run tsc.
JS_TSC_REQ +=

################################################################################

# _JS_TSC_REQ is a space separated list of automatically detected prerequisites
# needed to run tsc. It includes GENERATED_FILES, so that generated sources,
# such as TypeScript generated from protocol buffers definitions, exist before
# they're type-checked or compiled.
_JS_TSC_REQ += artifacts/link-dependencies.touch $$(GENERATED_FILES)

################################################################################

# JS_TSC_TYPECHECK_SKIP_LIB is "true" if checking library types should be
# skipped.
JS_TSC_TYPECHECK_SKIP_LIB ?=

################################################################################

# tsc-typecheck --- Use tsc to check for TypeScript errors.
.PHONY: tsc-typecheck
tsc-typecheck: $(JS_TSC_REQ) $(_JS_TSC_REQ)
ifeq ($(JS_TSC_TYPECHECK_SKIP_LIB),true)
	$(JS_EXEC) tsc --noEmit --skipLibCheck
else
	$(JS_EXEC) tsc --noEmit
endif

################################################################################

# If the project has a "tsconfig.build.json" file, it is used to build the
# project into the "artifacts/dist" directory. Its "outDir" option must be set
# to "artifacts/dist".
#
# The tools that check the built package, such as publint, arethetypeswrong and
# @skypack/package-check, build it first. Nothing else depends on it.
ifneq ($(wildcard tsconfig.build.json),)

# _JS_TSC_DIST is the directory that the project is built into. The makefiles
# for tools that check the built package depend on it, using second expansion
# so that it doesn't matter whether they're included before this file.
_JS_TSC_DIST = artifacts/dist

# artifacts/dist --- Build the project using tsc.
artifacts/dist: tsconfig.build.json $(wildcard tsconfig.json) $(JS_SOURCE_FILES) $(JS_TSC_REQ) $(_JS_TSC_REQ)
	@rm -rf "$@"
	$(JS_EXEC) tsc -p "$<"
	@touch "$@"

endif

################################################################################

# lint --- Check for syntax, configuration, code style and/or formatting issues.
.PHONY: lint
lint:: tsc-typecheck

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: tsc-typecheck

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: tsc-typecheck
