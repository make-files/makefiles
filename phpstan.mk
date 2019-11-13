# PHP_PHPSTAN_REQ is a space separated list of prerequisites needed to run
# PHPStan.
PHP_PHPSTAN_REQ +=

################################################################################

# _PHP_PHPSTAN_REQ is a space separated list of automatically detected
# prerequisites needed to run PHPStan.
_PHP_PHPSTAN_REQ += vendor $(PHP_PHPSTAN_CONFIG_FILE) $(PHP_SOURCE_FILES)

# _PHP_PHPSTAN_ARGS is a space separated list of arguments to pass to PHPStan.
_PHP_PHPSTAN_ARGS := analyze -c "$(PHP_PHPSTAN_CONFIG_FILE)"

################################################################################

# lint --- Check for syntax, configuration, code style and/or formatting issues.
.PHONY: lint
lint:: lint-phpstan

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: lint-phpstan

################################################################################

# lint-phpstan --- Check for PHP code style and formatting issues.
.PHONY: lint-phpstan
lint-phpstan: artifacts/lint/phpstan.touch

################################################################################

artifacts/lint/phpstan.touch: $(PHP_PHPSTAN_REQ) $(_PHP_PHPSTAN_REQ)
	vendor/bin/phpstan $(_PHP_PHPSTAN_ARGS)

	@mkdir -p "$(@D)"
	@touch "$@"
