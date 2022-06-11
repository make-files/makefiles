# JS_ESLINT_REQ is a space separated list of prerequisites needed to run ESLint.
JS_ESLINT_REQ +=

################################################################################

# _JS_ESLINT_REQ is a space separated list of automatically detected
# prerequisites needed to run ESLint.
_JS_ESLINT_REQ += node_modules

# _JS_ESLINT_CACHE_FILE is a path to the cache file to use when running ESLint.
_JS_ESLINT_CACHE_FILE := artifacts/lint/eslint/cache

# _JS_ESLINT_ARGS is a space separated list of arguments to pass to ESLint.
_JS_ESLINT_ARGS := --config "$(JS_ESLINT_CONFIG_FILE)" --cache --cache-location "$(_JS_ESLINT_CACHE_FILE)"

################################################################################

# lint --- Check for syntax, configuration, code style and/or formatting issues.
.PHONY: lint
lint:: eslint

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: eslint-strict

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: eslint-check

################################################################################

# eslint --- Check for JavaScript code style and formatting issues, fixing
#            automatically where possible. Warnings will not cause this target
#            to fail, but errors will.
.PHONY: eslint
eslint: $(JS_ESLINT_REQ) $(_JS_ESLINT_REQ)
	node_modules/.bin/eslint $(_JS_ESLINT_ARGS) --fix "$(MF_PROJECT_ROOT)"

# eslint-strict --- Same as the eslint target, but ESLint warnings will cause
#                   failures.
.PHONY: eslint-strict
eslint-strict: $(JS_ESLINT_REQ) $(_JS_ESLINT_REQ)
	node_modules/.bin/eslint $(_JS_ESLINT_ARGS) --fix --max-warnings 0 "$(MF_PROJECT_ROOT)"

# eslint-check --- Same as the eslint-strict target, but issues that could
#                  automatically be fixed will instead cause this target to
#                  fail.
.PHONY: eslint-check
eslint-check: $(JS_ESLINT_REQ) $(_JS_ESLINT_REQ)
	node_modules/.bin/eslint $(_JS_ESLINT_ARGS) --max-warnings 0 "$(MF_PROJECT_ROOT)"
