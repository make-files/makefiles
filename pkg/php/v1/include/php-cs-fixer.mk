# PHP_CS_FIXER_REQ is a space separated list of prerequisites needed to run PHP
# CS Fixer.
PHP_CS_FIXER_REQ +=

################################################################################

# _PHP_CS_FIXER_CACHE_DIR is a path to the cache directory to use when running
# PHP CS Fixer.
_PHP_CS_FIXER_CACHE_DIR := artifacts/lint/php-cs-fixer

# _PHP_CS_FIXER_CACHE_FILE is a path to the cache file to use when running PHP
# CS Fixer.
_PHP_CS_FIXER_CACHE_FILE := $(_PHP_CS_FIXER_CACHE_DIR)/cache

# _PHP_CS_FIXER_REQ is a space separated list of automatically detected
# prerequisites needed to run PHP CS Fixer.
_PHP_CS_FIXER_REQ += vendor $(_PHP_CS_FIXER_CACHE_DIR) $(PHP_CS_FIXER_CONFIG_FILE) $(PHP_SOURCE_FILES) $(GENERATED_FILES)

# _PHP_CS_FIXER_ARGS is a space separated list of arguments to pass to PHP CS
# Fixer.
_PHP_CS_FIXER_ARGS := fix --config "$(PHP_CS_FIXER_CONFIG_FILE)" --cache-file "$(_PHP_CS_FIXER_CACHE_FILE)"

################################################################################

# lint --- Check for syntax, configuration, code style and/or formatting issues.
.PHONY: lint
lint:: php-cs-fixer

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: php-cs-fixer

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: php-cs-fixer-check

################################################################################

# php-cs-fixer --- Check for PHP code style and formatting issues, fixing
#                  automatically where possible.
.PHONY: php-cs-fixer
php-cs-fixer: $(PHP_CS_FIXER_REQ) $(_PHP_CS_FIXER_REQ)
	vendor/bin/php-cs-fixer $(_PHP_CS_FIXER_ARGS)

# php-cs-fixer-check --- Check for PHP code style and formatting issues, and
#                        fail if any issues are found.
.PHONY: php-cs-fixer-check
php-cs-fixer-check: $(PHP_CS_FIXER_REQ) $(_PHP_CS_FIXER_REQ)
	vendor/bin/php-cs-fixer $(_PHP_CS_FIXER_ARGS) --dry-run

################################################################################

artifacts/lint/php-cs-fixer:
	@mkdir -p "$@"
	@touch "$@"
