# JS_SIZE_LIMIT_REQ is a space separated list of prerequisites needed to run
# Size Limit
JS_SIZE_LIMIT_REQ +=

################################################################################

# _JS_SIZE_LIMIT_REQ is a space separated list of automatically detected
# prerequisites needed to run Size Limit.
_JS_SIZE_LIMIT_REQ += node_modules $(JS_SIZE_LIMIT_CONFIG_FILE) $(JS_SOURCE_FILES) $(GENERATED_FILES)

################################################################################

# lint --- Check for syntax, configuration, code style and/or formatting issues.
.PHONY: lint
lint:: size-limit

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: artifacts/lint/size-limit.touch

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: artifacts/lint/size-limit.touch

################################################################################

# size-limit --- Check code size against pre-configured limits using Size Limit.
.PHONY: size-limit
size-limit: artifacts/lint/size-limit.touch

################################################################################

artifacts/lint/size-limit.touch: $(JS_SIZE_LIMIT_REQ) $(_JS_SIZE_LIMIT_REQ)
	@mkdir -p "$(@D)"

	node_modules/.bin/size-limit

	@touch "$@"
