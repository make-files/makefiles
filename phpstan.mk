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

# lint --- Check for code style and formatting issues. Stacks with the "lint" target from other makefiles.
.PHONY: lint
lint:: lint-phpstan

# prepare --- Perform tasks that need to be executed before committing. Stacks with the "prepare" target from the common makefile.
.PHONY: prepare
prepare:: lint-phpstan

# ci --- Enforce code style and formatting rules. Stacks with the "ci" target from the common makefile.
.PHONY: ci
ci:: artifacts/lint/phpstan.touch

# lint-phpstan --- Check for PHP code style and formatting issues.
.PHONY: lint-phpstan
lint-phpstan: artifacts/lint/phpstan.touch

################################################################################

artifacts/lint/phpstan.touch: $(PHP_PHPSTAN_REQ) $(_PHP_PHPSTAN_REQ)
	vendor/bin/phpstan $(_PHP_PHPSTAN_ARGS)

	@mkdir -p "$(@D)"
	@touch "$@"
