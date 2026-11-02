# JS_TSC_REQ is a space separated list of prerequisites needed to run tsc.
JS_TSC_REQ +=

################################################################################

# JS_TSC_TYPECHECK_SKIP_LIB is "true" if checking library types should be
# skipped.
JS_TSC_TYPECHECK_SKIP_LIB ?=

################################################################################

# tsc-typecheck --- Use tsc to check for TypeScript errors.
.PHONY: tsc-typecheck
tsc-typecheck: artifacts/link-dependencies.touch $$(GENERATED_FILES) $(JS_TSC_REQ)
ifeq ($(JS_TSC_TYPECHECK_SKIP_LIB),true)
	$(JS_EXEC) tsc --noEmit --skipLibCheck
else
	$(JS_EXEC) tsc --noEmit
endif

################################################################################

# If the project has a "tsconfig.build.json" file, it is used to build the
# project into the "artifacts/dist" directory. Its "outDir" option must be set
# to "artifacts/dist".
ifneq ($(wildcard tsconfig.build.json),)

# JS_PACKAGE_REQ is a space separated list of prerequisites needed before the
# built package is checked.
JS_PACKAGE_REQ ?= artifacts/dist

# artifacts/dist --- Build the project using tsc.
artifacts/dist: tsconfig.build.json $(wildcard tsconfig.json) artifacts/link-dependencies.touch $(JS_SOURCE_FILES) $$(GENERATED_FILES) $(JS_TSC_REQ)
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
