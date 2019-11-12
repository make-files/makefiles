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

# Ensure that dependencies are installed before attempting to build a Docker
# image.
DOCKER_BUILD_REQ += composer.json composer.lock

################################################################################

# prepare --- Perform tasks that need to be executed before committing. Stacks
# with the "prepare" target from the common makefile.
.PHONY: prepare
prepare:: artifacts/composer/validate.touch

# ci --- Validate composer.json and composer.lock. Stacks with the "ci" target
# from the common makefile.
.PHONY: ci
ci:: artifacts/composer/validate.touch

################################################################################

vendor: composer.lock
	composer install $(PHP_COMPOSER_INSTALL_ARGS)

composer.lock: | composer.json
	composer install $(PHP_COMPOSER_INSTALL_ARGS)

composer.json:
	composer init --no-interaction

artifacts/composer/validate.touch: composer.json
	$(eval ARGS := $(if $(PHP_COMPOSER_PUBLISH),$(PHP_COMPOSER_VALIDATE_PUBLISH_ARGS),$(PHP_COMPOSER_VALIDATE_NO_PUBLISH_ARGS)))
	composer validate $(ARGS)

	@mkdir -p "$(@D)"
	@touch "$@"
