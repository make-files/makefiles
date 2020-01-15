# PHP_PHPSTAN_REQ is a space separated list of prerequisites needed to run
# PHPStan.
PHP_PHPSTAN_REQ +=

################################################################################

# _PHP_PHPSTAN_REQ is a space separated list of automatically detected
# prerequisites needed to run PHPStan.
_PHP_PHPSTAN_REQ += vendor $(PHP_PHPSTAN_CONFIG_FILE) $(PHP_SOURCE_FILES) $(_PHP_REQ)

# _PHP_PHPSTAN_ARGS is a space separated list of arguments to pass to PHPStan.
_PHP_PHPSTAN_ARGS := analyze -c "$(PHP_PHPSTAN_CONFIG_FILE)"

################################################################################

# lint --- Check for syntax, configuration, code style and/or formatting issues.
.PHONY: lint
lint:: phpstan

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: artifacts/lint/phpstan/ci.touch

################################################################################

# phpstan --- Statically analyze code and report potential issues.
.PHONY: phpstan
phpstan: artifacts/lint/phpstan/analyze.touch

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: phpstan

################################################################################

artifacts/lint/phpstan:
	@mkdir -p "$@"

artifacts/lint/phpstan/analyze.touch: artifacts/lint/phpstan $(PHP_PHPSTAN_REQ) $(_PHP_PHPSTAN_REQ)
	vendor/bin/phpstan $(_PHP_PHPSTAN_ARGS)

	@touch "$@"

artifacts/lint/phpstan/ci.touch: artifacts/lint/phpstan $(PHP_PHPSTAN_REQ) $(_PHP_PHPSTAN_REQ)
	vendor/bin/phpstan $(_PHP_PHPSTAN_ARGS) --no-progress

	@touch "$@"
