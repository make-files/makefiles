# PHP_COMPOSER_INSTALL_ARGS is a set of arguments passed to "composer install"
PHP_COMPOSER_INSTALL_ARGS ?= --no-suggest --optimize-autoloader --prefer-dist

# The type of package as defined in the composer.json "type" property
PHP_COMPOSER_PACKAGE_TYPE := $(shell $(MF_ROOT)/pkg/php/v1/bin/composer-package-type)

# Whether this package is intended to be published
ifeq ($(PHP_COMPOSER_PACKAGE_TYPE),library)
PHP_COMPOSER_PUBLISH ?= true
else
PHP_COMPOSER_PUBLISH ?=
endif

# PHP_COMPOSER_VALIDATE_PUBLISH_ARGS and PHP_COMPOSER_VALIDATE_NO_PUBLISH_ARGS
# are arguments passed to "composer validate"
PHP_COMPOSER_VALIDATE_PUBLISH_ARGS    ?= --strict
PHP_COMPOSER_VALIDATE_NO_PUBLISH_ARGS ?= --no-check-publish

################################################################################

# Ensure that dependencies are installed before attempting to build a Docker
# image.
DOCKER_BUILD_REQ += composer.json composer.lock

################################################################################

# prepare --- Perform tasks that need to be executed before committing. Stacks
# with the "prepare" target form the common makefile.
.PHONY: prepare
prepare:: artifacts/composer/validate.touch

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
