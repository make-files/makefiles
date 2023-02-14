# PHP_PERIDOT_REQ is a space separated list of prerequisites needed to run the
# Peridot tests.
PHP_PERIDOT_REQ +=

# PHP_PERIDOT_PRIMARY_REPORTER is the primary reporter used for displaying test
# results.
PHP_PERIDOT_PRIMARY_REPORTER ?= spec

################################################################################

# _PHP_PERIDOT_REQ is a space separated list of automatically detected
# prerequisites needed to run the Peridot tests.
_PHP_PERIDOT_REQ += vendor $(PHP_PERIDOT_CONFIG_FILE) $(PHP_SOURCE_FILES) $(_PHP_TEST_ASSETS) $(GENERATED_FILES)

# _PHP_PERIDOT_ARGS is a set of arguments to use for every execution of Peridot.
_PHP_PERIDOT_ARGS := -c "$(PHP_PERIDOT_CONFIG_FILE)" --reporter "$(PHP_PERIDOT_PRIMARY_REPORTER)"

# _PHP_PERIDOT_COVERAGE_DRIVER is the extension or SAPI that will be used for
# Peridot code coverage generation.
_PHP_PERIDOT_COVERAGE_DRIVER := $(shell $(MF_ROOT)/pkg/php/v1/bin/coverage-driver xdebug phpdbg)

################################################################################

# test --- Executes all tests.
.PHONY: test
test:: peridot

# coverage --- Executes all tests, producing coverage reports.
.PHONY: coverage
coverage:: peridot-coverage

# coverage-open --- Opens all HTML coverage reports in a browser.
.PHONY: coverage-open
coverage-open:: peridot-coverage-open

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: peridot

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: artifacts/coverage/peridot/clover.xml

################################################################################

# peridot --- Executes all Peridot tests in this package.
.PHONY: peridot
peridot: artifacts/test/peridot.touch

# peridot-coverage --- Produces a Peridot HTML coverage report.
.PHONY: peridot-coverage
peridot-coverage: artifacts/coverage/peridot/index.html

# peridot-coverage-open --- Opens the Peridot HTML coverage report in a browser.
.PHONY: peridot-coverage-open
peridot-coverage-open: artifacts/coverage/peridot/index.html
	$(MF_BROWSER) "$<"

################################################################################

artifacts/coverage/peridot/index.html: $(PHP_PERIDOT_REQ) $(_PHP_PERIDOT_REQ)
ifeq ($(_PHP_PERIDOT_COVERAGE_DRIVER),phpdbg)
	phpdbg -d=pcov.enabled=0 -qrr vendor/bin/peridot $(_PHP_PERIDOT_ARGS) --reporter html-code-coverage --code-coverage-path "$(@D)"
else
	vendor/bin/peridot $(_PHP_PERIDOT_ARGS) --reporter html-code-coverage --code-coverage-path "$(@D)"
endif

artifacts/coverage/peridot/clover.xml: $(PHP_PERIDOT_REQ) $(_PHP_PERIDOT_REQ)
ifeq ($(_PHP_PERIDOT_COVERAGE_DRIVER),phpdbg)
	phpdbg -d=pcov.enabled=0 -qrr vendor/bin/peridot $(_PHP_PERIDOT_ARGS) --reporter clover-code-coverage --code-coverage-path "$(@D)"
else
	vendor/bin/peridot $(_PHP_PERIDOT_ARGS) --reporter clover-code-coverage --code-coverage-path "$(@D)"
endif

artifacts/test/peridot.touch: $(PHP_PERIDOT_REQ) $(_PHP_PERIDOT_REQ)
	vendor/bin/peridot $(_PHP_PERIDOT_ARGS)

	@mkdir -p "$(@D)"
	@touch "$@"
