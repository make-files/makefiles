# Always run tests by default, even if other makefiles are included beforehand.
.DEFAULT_GOAL := test

# PHP_SOURCE_FILES is a space separated list of source files in the repo.
PHP_SOURCE_FILES += $(shell PATH="$(PATH)" git-find '*.php')

# PHP_CS_FIXER_CONFIG_FILE is the path to any existing PHP CS Fixer
# configuration.
PHP_CS_FIXER_CONFIG_FILE ?= $(shell PATH="$(PATH)" find-first-matching-file .php_cs .php_cs.dist)

# PHP_PERIDOT_CONFIG_FILE is the path to any existing Peridot configuration.
PHP_PERIDOT_CONFIG_FILE ?= $(shell PATH="$(PATH)" find-first-matching-file peridot.php)

# PHP_PHPSTAN_CONFIG_FILE is the path to any existing PHPStan configuration.
PHP_PHPSTAN_CONFIG_FILE ?= $(shell PATH="$(PATH)" find-first-matching-file phpstan.neon phpstan.neon.dist)

# PHP_PHPUNIT_CONFIG_FILE is the path to any existing PHPUnit configuration.
PHP_PHPUNIT_CONFIG_FILE ?= $(shell PATH="$(PATH)" find-first-matching-file phpunit.xml phpunit.xml.dist)

################################################################################

# _PHP_TEST_ASSETS is a space separated list of all non-PHP files in the test
# directory.
_PHP_TEST_ASSETS := $(shell find test -type f -not -iname "*.php" 2> /dev/null)

# Ensure that dependencies are installed before attempting to build a Docker
# image.
DOCKER_BUILD_REQ += vendor

################################################################################

-include .makefiles/pkg/php/v1/composer.mk

# Test runners

ifneq ($(PHP_PERIDOT_CONFIG_FILE),)
-include .makefiles/pkg/php/v1/peridot.mk
endif

ifneq ($(PHP_PHPUNIT_CONFIG_FILE),)
-include .makefiles/pkg/php/v1/phpunit.mk
endif

# Lint tools

ifneq ($(PHP_PHPSTAN_CONFIG_FILE),)
-include .makefiles/pkg/php/v1/phpstan.mk
endif

ifneq ($(PHP_CS_FIXER_CONFIG_FILE),)
-include .makefiles/pkg/php/v1/php-cs-fixer.mk
endif
