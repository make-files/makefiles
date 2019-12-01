# PHP_PHPUNIT_REQ is a space separated list of prerequisites needed to run the
# PHPUnit tests.
PHP_PHPUNIT_REQ +=

# PHP_PHPUNIT_RESULT_CACHE_FILE is the path to use for the PHPUnit result cache
# file. Can be set to an empty value for older versions of PHPUnit that do not
# supprt the --cache-result-file option.
PHP_PHPUNIT_RESULT_CACHE_FILE ?= artifacts/test/phpunit.result.cache

################################################################################

# _PHP_PHPUNIT_REQ is a space separated list of automatically detected
# prerequisites needed to run the PHPUnit tests.
_PHP_PHPUNIT_REQ += vendor $(PHP_PHPUNIT_CONFIG_FILE) $(PHP_SOURCE_FILES) $(_PHP_TEST_ASSETS) $(_PHP_REQ)

# _PHP_PHPUNIT_ARGS is a set of arguments to use for every execution of PHPUnit.
_PHP_PHPUNIT_ARGS := -c "$(PHP_PHPUNIT_CONFIG_FILE)"

ifneq ($(PHP_PHPUNIT_RESULT_CACHE_FILE),)
	_PHP_PHPUNIT_ARGS += --cache-result-file "$(PHP_PHPUNIT_RESULT_CACHE_FILE)"
endif

# _PHP_PHPUNIT_COVERAGE_DRIVER is the extension or SAPI that will be used for
# PHPUnit code coverage generation.
_PHP_PHPUNIT_COVERAGE_DRIVER := $(shell $(MF_ROOT)/pkg/php/v1/bin/coverage-driver pcov xdebug phpdbg)

################################################################################

# test --- Executes all tests.
.PHONY: test
test:: test-phpunit

# coverage --- Executes all tests, producing coverage reports.
.PHONY: coverage
coverage:: coverage-phpunit

# coverage-open --- Opens all HTML coverage reports in a browser.
.PHONY: coverage-open
coverage-open:: coverage-phpunit-open

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: ci-phpunit

################################################################################

# test-phpunit --- Executes all PHPUnit tests in this package.
.PHONY: test-phpunit
test-phpunit: artifacts/test/phpunit.touch

# coverage-phpunit --- Produces a PHPUnit HTML coverage report.
.PHONY: coverage-phpunit
coverage-phpunit: artifacts/coverage/phpunit/index.html

# coverage-phpunit-open --- Opens the PHPUnit HTML coverage report in a browser.
.PHONY: coverage-phpunit-open
coverage-phpunit-open: artifacts/coverage/phpunit/index.html
	open "$<"

# ci-phpunit --- Executes all PHPUnit tests in this package, and produces a
#                machine-readable coverage report.
.PHONY: ci-phpunit
ci-phpunit: artifacts/coverage/phpunit/clover.xml

################################################################################

artifacts/coverage/phpunit/index.html: $(PHP_PHPUNIT_REQ) $(_PHP_PHPUNIT_REQ)
ifeq ($(_PHP_PHPUNIT_COVERAGE_DRIVER),phpdbg)
	phpdbg -qrr vendor/bin/phpunit $(_PHP_PHPUNIT_ARGS) --coverage-html="$(@D)"
else ifeq ($(_PHP_PHPUNIT_COVERAGE_DRIVER),pcov)
	@[[ ! -x vendor/bin/pcov ]] || vendor/bin/pcov clobber
	vendor/bin/phpunit $(_PHP_PHPUNIT_ARGS) --coverage-html="$(@D)"
else
	vendor/bin/phpunit $(_PHP_PHPUNIT_ARGS) --coverage-html="$(@D)"
endif

artifacts/coverage/phpunit/clover.xml: $(PHP_PHPUNIT_REQ) $(_PHP_PHPUNIT_REQ)
ifeq ($(_PHP_PHPUNIT_COVERAGE_DRIVER),phpdbg)
	phpdbg -qrr vendor/bin/phpunit $(_PHP_PHPUNIT_ARGS) --coverage-clover="$@"
else ifeq ($(_PHP_PHPUNIT_COVERAGE_DRIVER),pcov)
	@[[ ! -x vendor/bin/pcov ]] || vendor/bin/pcov clobber
	vendor/bin/phpunit $(_PHP_PHPUNIT_ARGS) --coverage-html="$(@D)"
else
	vendor/bin/phpunit $(_PHP_PHPUNIT_ARGS) --coverage-clover="$@"
endif

artifacts/test/phpunit.touch: $(PHP_PHPUNIT_REQ) $(_PHP_PHPUNIT_REQ)
	vendor/bin/phpunit $(_PHP_PHPUNIT_ARGS) --no-coverage

	@mkdir -p "$(@D)"
	@touch "$@"
