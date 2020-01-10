# JS_ESLINT_REQ is a space separated list of prerequisites needed to run ESLint.
JS_ESLINT_REQ +=

################################################################################

# _JS_ESLINT_REQ is a space separated list of automatically detected
# prerequisites needed to run ESLint.
_JS_ESLINT_REQ += node_modules $(JS_ESLINT_CONFIG_FILE) $(JS_SOURCE_FILES) $(_JS_REQ)

# _JS_ESLINT_CACHE_FILE is a path to the cache file to use when running ESLint.
_JS_ESLINT_CACHE_FILE := artifacts/lint/eslint/cache

# _JS_ESLINT_ARGS is a space separated list of arguments to pass to ESLint.
_JS_ESLINT_ARGS := --config "$(JS_ESLINT_CONFIG_FILE)" --cache --cache-location "$(_JS_ESLINT_CACHE_FILE)"

################################################################################

# lint --- Check for syntax, configuration, code style and/or formatting issues.
.PHONY: lint
lint:: lint-eslint

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: precommit-eslint

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: ci-eslint

################################################################################

# lint-eslint --- Check for JavaScript code style and formatting issues, fixing
#                 automatically where possible. Warnings will not cause this
#                 target to fail, but errors will.
.PHONY: lint-eslint
lint-eslint: artifacts/lint/eslint/fix.touch

# ci-eslint --- Check for JavaScript code style and formatting issues, and fail
#               if any issues are detected.
.PHONY: ci-eslint
ci-eslint: artifacts/lint/eslint/ci.touch

# lint-eslint --- Check for JavaScript code style and formatting issues, fixing
#                 automatically where possible. Both warnings and errors will
#                 cause this target to fail.
.PHONY: precommit-eslint
precommit-eslint:: artifacts/lint/eslint/precommit.touch

################################################################################

artifacts/lint/eslint:
	@mkdir -p "$@"

artifacts/lint/eslint/ci.touch: artifacts/lint/eslint $(JS_ESLINT_REQ) $(_JS_ESLINT_REQ)
	node_modules/.bin/eslint $(_JS_ESLINT_ARGS) --max-warnings 0 "$(MF_PROJECT_ROOT)"

	@touch "$@"

artifacts/lint/eslint/fix.touch: artifacts/lint/eslint $(JS_ESLINT_REQ) $(_JS_ESLINT_REQ)
	node_modules/.bin/eslint $(_JS_ESLINT_ARGS) --fix "$(MF_PROJECT_ROOT)"

	@touch "$@"

artifacts/lint/eslint/precommit.touch: artifacts/lint/eslint $(JS_ESLINT_REQ) $(_JS_ESLINT_REQ)
	node_modules/.bin/eslint $(_JS_ESLINT_ARGS) --fix --max-warnings 0 "$(MF_PROJECT_ROOT)"

	@touch "$@"
