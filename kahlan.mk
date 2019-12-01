# PHP_KAHLAN_REQ is a space separated list of prerequisites needed to run the
# Kahlan tests.
PHP_KAHLAN_REQ +=

# PHP_KAHLAN_COVERAGE_LEVEL is the level of detail to use when outputting Kahlan
# coverage information to the console.
PHP_KAHLAN_COVERAGE_LEVEL ?= 1

################################################################################

# _PHP_KAHLAN_REQ is a space separated list of automatically detected
# prerequisites needed to run the Kahlan tests.
_PHP_KAHLAN_REQ += vendor $(PHP_KAHLAN_CONFIG_FILE) $(PHP_SOURCE_FILES) $(_PHP_TEST_ASSETS) $(_PHP_REQ)

# _PHP_KAHLAN_ARGS is a set of arguments to use for every execution of Kahlan.
_PHP_KAHLAN_ARGS := --config="$(PHP_KAHLAN_CONFIG_FILE)"

# _PHP_KAHLAN_COVERAGE_ARGS is a set of arguments to use for every execution of
# Kahlan that produces coverage reports.
_PHP_KAHLAN_COVERAGE_ARGS := $(_PHP_KAHLAN_ARGS) --coverage="$(PHP_KAHLAN_COVERAGE_LEVEL)"

# _PHP_KAHLAN_COVERAGE_DRIVER is the extension or SAPI that will be used for
# Kahlan code coverage generation.
_PHP_KAHLAN_COVERAGE_DRIVER := $(shell $(MF_ROOT)/pkg/php/v1/bin/coverage-driver xdebug phpdbg)

################################################################################

# test --- Executes all tests.
.PHONY: test
test:: test-kahlan

# coverage --- Executes all tests, producing coverage reports.
.PHONY: coverage
coverage:: coverage-kahlan

# coverage-open --- Opens all HTML coverage reports in a browser.
.PHONY: coverage-open
coverage-open:: coverage-kahlan-open

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: ci-kahlan

################################################################################

# test-kahlan --- Executes all Kahlan tests in this package.
.PHONY: test-kahlan
test-kahlan: artifacts/test/kahlan.touch

# coverage-kahlan --- Produces a Kahlan HTML coverage report.
.PHONY: coverage-kahlan
coverage-kahlan: artifacts/coverage/kahlan/index.html

# coverage-kahlan-open --- Opens the Kahlan HTML coverage report in a browser.
.PHONY: coverage-kahlan-open
coverage-kahlan-open: artifacts/coverage/kahlan/index.html
	open "$<"

# ci-kahlan --- Executes all Kahlan tests in this package, and produces a
#               machine-readable coverage report.
.PHONY: ci-kahlan
ci-kahlan: artifacts/coverage/kahlan/clover.xml

################################################################################

artifacts/coverage/kahlan:
	@mkdir -p "$@"

artifacts/coverage/kahlan/clover.xml: artifacts/coverage/kahlan $(PHP_KAHLAN_REQ) $(_PHP_KAHLAN_REQ)
ifeq ($(_PHP_KAHLAN_COVERAGE_DRIVER),phpdbg)
	phpdbg -d=pcov.enabled=0 -qrr vendor/bin/kahlan $(_PHP_KAHLAN_COVERAGE_ARGS) --clover="$@"
else
	vendor/bin/kahlan $(_PHP_KAHLAN_COVERAGE_ARGS) --clover="$@"
endif

artifacts/coverage/kahlan/index.html: artifacts/coverage/kahlan/lcov.info
	@genhtml -t "$(PROJECT_NAME)" -o "$(@D)" "$<" > /dev/null

artifacts/coverage/kahlan/lcov.info: artifacts/coverage/kahlan $(PHP_KAHLAN_REQ) $(_PHP_KAHLAN_REQ)
ifeq ($(_PHP_KAHLAN_COVERAGE_DRIVER),phpdbg)
	phpdbg -d=pcov.enabled=0 -qrr vendor/bin/kahlan $(_PHP_KAHLAN_COVERAGE_ARGS) --lcov="$@"
else
	vendor/bin/kahlan $(_PHP_KAHLAN_COVERAGE_ARGS) --lcov="$@"
endif

artifacts/test/kahlan.touch: $(PHP_KAHLAN_REQ) $(_PHP_KAHLAN_REQ)
	vendor/bin/kahlan $(_PHP_KAHLAN_ARGS)

	@mkdir -p "$(@D)"
	@touch "$@"
