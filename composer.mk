# PHP_COMPOSER_INSTALL_ARGS is a set of arguments passed to "composer install"
PHP_COMPOSER_INSTALL_ARGS ?= --no-suggest --optimize-autoloader --prefer-dist

# PHP_COMPOSER_PUBLISH should be non-empty if this package is intended to be
# published
PHP_COMPOSER_PUBLISH ?=

# PHP_COMPOSER_VALIDATE_PUBLISH_ARGS and PHP_COMPOSER_VALIDATE_NO_PUBLISH_ARGS
# are arguments passed to "composer validate"
PHP_COMPOSER_VALIDATE_PUBLISH_ARGS    ?= --strict
PHP_COMPOSER_VALIDATE_NO_PUBLISH_ARGS ?= --no-check-publish

################################################################################

# _PHP_COMPOSER_PACKAGE_TYPE is the package type as defined in the composer.json
# "type" property
_PHP_COMPOSER_PACKAGE_TYPE := $(shell $(MF_ROOT)/pkg/php/v1/bin/composer-package-type)

# Default PHP_COMPOSER_PUBLISH to true for libraries
ifeq ($(_PHP_COMPOSER_PACKAGE_TYPE),library)
PHP_COMPOSER_PUBLISH ?= true
endif

# _PHP_COMPOSER_VALIDATE_ARGS is a set of arguments to use for every execution
# of composer validate.
_PHP_COMPOSER_VALIDATE_ARGS := $(if $(PHP_COMPOSER_PUBLISH),$(PHP_COMPOSER_VALIDATE_PUBLISH_ARGS),$(PHP_COMPOSER_VALIDATE_NO_PUBLISH_ARGS))

# Ensure that dependencies are installed before attempting to build a Docker
# image.
DOCKER_BUILD_REQ += composer.json composer.lock

################################################################################

# lint --- Check for syntax, configuration, code style and/or formatting issues.
.PHONY: lint
lint:: lint-composer-validate

# prepare --- Perform tasks that need to be executed before committing.
.PHONY: prepare
prepare:: lint-composer-validate

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: lint-composer-validate

################################################################################

# lint-composer-validate --- Validate composer.json and composer.lock.
.PHONY: lint-composer-validate
lint-composer-validate: artifacts/lint/composer-validate.touch

################################################################################

vendor: composer.lock
	composer install $(PHP_COMPOSER_INSTALL_ARGS)

composer.lock: composer.json
ifeq ($(wildcard composer.lock),)
	composer install $(PHP_COMPOSER_INSTALL_ARGS)
else
	composer validate $(_PHP_COMPOSER_VALIDATE_ARGS) && touch "$@"
endif

composer.json:
ifeq ($(wildcard composer.json),)
	composer init --no-interaction
endif

artifacts/lint/composer-validate.touch: composer.json
	composer validate $(_PHP_COMPOSER_VALIDATE_ARGS)

	@mkdir -p "$(@D)"
	@touch "$@"
