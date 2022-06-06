# JS_PRETTIER_REQ is a space separated list of prerequisites needed to run
# Prettier.
JS_PRETTIER_REQ +=

################################################################################

# _JS_PRETTIER_REQ is a space separated list of automatically detected
# prerequisites needed to run Prettier.
_JS_PRETTIER_REQ += node_modules $(JS_PRETTIER_CONFIG_FILE) $(JS_SOURCE_FILES) $(JS_TEST_FILES) $(GENERATED_FILES)

# _JS_PRETTIER_ARGS is a space separated list of arguments to pass to Prettier.
_JS_PRETTIER_ARGS := --config "$(JS_PRETTIER_CONFIG_FILE)"

################################################################################

# lint --- Check for syntax, configuration, code style and/or formatting issues.
.PHONY: lint
lint:: prettier

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: artifacts/lint/prettier/write.touch

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: artifacts/lint/prettier/check.touch

################################################################################

# prettier --- Automatically fix JavaScript code style and formatting issues.
.PHONY: prettier
prettier: artifacts/lint/prettier/write.touch

################################################################################

artifacts/lint/prettier:
	@mkdir -p "$@"

artifacts/lint/prettier/check.touch: artifacts/lint/prettier $(JS_PRETTIER_REQ) $(_JS_PRETTIER_REQ)
	node_modules/.bin/prettier $(_JS_PRETTIER_ARGS) --check "$(MF_PROJECT_ROOT)"

	@touch "$@"

artifacts/lint/prettier/write.touch: artifacts/lint/prettier $(JS_PRETTIER_REQ) $(_JS_PRETTIER_REQ)
	node_modules/.bin/prettier $(_JS_PRETTIER_ARGS) --write "$(MF_PROJECT_ROOT)"

	@touch "$@"
