# JS_SIZE_LIMIT_REQ is a space separated list of prerequisites needed to run
# Size Limit
JS_SIZE_LIMIT_REQ +=

################################################################################

# _JS_SIZE_LIMIT_REQ is a space separated list of automatically detected
# prerequisites needed to run Size Limit.
_JS_SIZE_LIMIT_REQ += artifacts/link-dependencies.touch

################################################################################

# lint --- Check for syntax, configuration, code style and/or formatting issues.
.PHONY: lint
lint:: size-limit

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: size-limit

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: size-limit

################################################################################

# size-limit --- Check code size against pre-configured limits using Size Limit.
.PHONY: size-limit
size-limit: $(JS_SIZE_LIMIT_REQ) $(_JS_SIZE_LIMIT_REQ)
	$(JS_EXEC) size-limit
