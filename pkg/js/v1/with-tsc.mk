# tsc-typecheck --- Use tsc to check for TypeScript errors.
.PHONY: tsc-typecheck
tsc-typecheck: artifacts/link-dependencies.touch
	$(JS_EXEC) tsc --noEmit

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
