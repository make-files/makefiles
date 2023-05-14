# JS_TSC_TYPECHECK_SKIP_LIB is "true" if checking library types should be
# skipped.
JS_TSC_TYPECHECK_SKIP_LIB ?=

################################################################################

# tsc-typecheck --- Use tsc to check for TypeScript errors.
.PHONY: tsc-typecheck
tsc-typecheck: artifacts/link-dependencies.touch
ifeq ($(JS_TSC_TYPECHECK_SKIP_LIB),true)
	$(JS_EXEC) tsc --noEmit --skipLibCheck
else
	$(JS_EXEC) tsc --noEmit
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
