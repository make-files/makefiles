# JS_PRETTIER_REQ is a space separated list of prerequisites needed to run
# Prettier.
JS_PRETTIER_REQ +=

################################################################################

# _JS_PRETTIER_REQ is a space separated list of automatically detected
# prerequisites needed to run Prettier.
_JS_PRETTIER_REQ += artifacts/link-dependencies.touch

# _JS_PRETTIER_ARGS is a space separated list of arguments to pass to Prettier.
_JS_PRETTIER_ARGS := --config "$(JS_PRETTIER_CONFIG_FILE)"

################################################################################

# lint --- Check for syntax, configuration, code style and/or formatting issues.
.PHONY: lint
lint:: prettier

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: prettier

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: prettier-check

################################################################################

# prettier --- Automatically fix JavaScript code style and formatting issues.
.PHONY: prettier
prettier: $(JS_PRETTIER_REQ) $(_JS_PRETTIER_REQ)
	$(call js_exec,prettier) $(_JS_PRETTIER_ARGS) --write "$(MF_PROJECT_ROOT)"

# prettier-check --- Check for JavaScript code style and formatting issues.
.PHONY: prettier-check
prettier-check: $(JS_PRETTIER_REQ) $(_JS_PRETTIER_REQ)
	$(call js_exec,prettier) $(_JS_PRETTIER_ARGS) --check "$(MF_PROJECT_ROOT)"
