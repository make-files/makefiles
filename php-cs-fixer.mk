# PHP_CS_FIXER_REQ is a space separated list of prerequisites needed to run PHP
# CS Fixer.
PHP_CS_FIXER_REQ +=

################################################################################

# _PHP_CS_FIXER_REQ is a space separated list of automatically detected
# prerequisites needed to run PHP CS Fixer.
_PHP_CS_FIXER_REQ += vendor $(PHP_CS_FIXER_CONFIG_FILE) $(PHP_SOURCE_FILES)

# _PHP_CS_FIXER_CACHE_FILE is a path to the cache file to use when running PHP
# CS Fixer.
_PHP_CS_FIXER_CACHE_FILE := artifacts/lint/php-cs-fixer/cache

# _PHP_CS_FIXER_ARGS is a space separated list of arguments to pass to PHP CS
# Fixer.
_PHP_CS_FIXER_ARGS := fix --config "$(PHP_CS_FIXER_CONFIG_FILE)" --cache-file "$(_PHP_CS_FIXER_CACHE_FILE)"

################################################################################

# lint --- Check for code style and formatting issues, fixing automatically
# where possible. Stacks with the "lint" target from other makefiles.
.PHONY: lint
lint:: lint-php-cs-fixer

# prepare --- Perform tasks that need to be executed before committing. Stacks
# with the "prepare" target from the common makefile.
.PHONY: prepare
prepare:: lint-php-cs-fixer

# ci --- Enforce code style and formatting rules. Stacks with the "ci" target
# from the common makefile.
.PHONY: ci
ci:: artifacts/lint/php-cs-fixer-ci.touch

# lint-php-cs-fixer --- Check for PHP code style and formatting issues, fixing
# automatically where possible.
.PHONY: lint-php-cs-fixer
lint-php-cs-fixer: artifacts/lint/php-cs-fixer-fix.touch

################################################################################

artifacts/lint/php-cs-fixer:
	@mkdir -p "$@"

artifacts/lint/php-cs-fixer-ci.touch: artifacts/lint/php-cs-fixer $(PHP_CS_FIXER_REQ) $(_PHP_CS_FIXER_REQ)
	vendor/bin/php-cs-fixer $(_PHP_CS_FIXER_ARGS) --dry-run

	@touch "$@"

artifacts/lint/php-cs-fixer-fix.touch: artifacts/lint/php-cs-fixer $(PHP_CS_FIXER_REQ) $(_PHP_CS_FIXER_REQ)
	vendor/bin/php-cs-fixer $(_PHP_CS_FIXER_ARGS)

	@touch "$@"
