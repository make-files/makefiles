# PHP_PERIDOT_REQ is a space separated list of prerequisites needed to run the
# Peridot tests.
PHP_PERIDOT_REQ +=

# PHP_PERIDOT_PRIMARY_REPORTER is the primary reporter used for displaying test
# results.
PHP_PERIDOT_PRIMARY_REPORTER ?= spec

################################################################################

# _PHP_PERIDOT_INI_FILE is the path to a PHP INI file that should be used when
# running Peridot tests.
_PHP_PERIDOT_INI_FILE ?= $(shell PATH="$(PATH)" find-first-matching-file php.peridot.ini)

# _PHP_PERIDOT_REQ is a space separated list of automatically detected
# prerequisites needed to run the Peridot tests.
_PHP_PERIDOT_REQ += vendor $(_PHP_PERIDOT_INI_FILE) $(PHP_PERIDOT_CONFIG_FILE) $(PHP_SOURCE_FILES) $(_PHP_TEST_ASSETS) $(_PHP_REQ)

# _PHP_PERIDOT_RUNTIME_ARGS is a set of arguments to pass to the PHP runtime
# when running Peridot tests.
ifeq ($(_PHP_PERIDOT_INI_FILE),)
_PHP_PERIDOT_RUNTIME_ARGS +=
else
_PHP_PERIDOT_RUNTIME_ARGS += -c "$(_PHP_PERIDOT_INI_FILE)"
endif

# _PHP_PERIDOT_ARGS is a set of arguments to use for every execution of Peridot.
_PHP_PERIDOT_ARGS := -c "$(PHP_PERIDOT_CONFIG_FILE)" --reporter "$(PHP_PERIDOT_PRIMARY_REPORTER)"

################################################################################

# test --- Executes all tests.
.PHONY: test
test:: test-peridot

# coverage --- Executes all tests, producing coverage reports.
.PHONY: coverage
coverage:: coverage-peridot

# coverage-open --- Opens all HTML coverage reports in a browser.
.PHONY: coverage-open
coverage-open:: coverage-peridot-open

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: ci-peridot

################################################################################

# test-peridot --- Executes all Peridot tests in this package.
.PHONY: test-peridot
test-peridot: artifacts/test/peridot.touch

# coverage-peridot --- Produces a Peridot HTML coverage report.
.PHONY: coverage-peridot
coverage-peridot: artifacts/coverage/peridot/index.html

# coverage-peridot-open --- Opens the Peridot HTML coverage report in a browser.
.PHONY: coverage-peridot-open
coverage-peridot-open: artifacts/coverage/peridot/index.html
	open "$<"

# ci-peridot --- Executes all Peridot tests in this package, and produces a
#                machine-readable coverage report.
.PHONY: ci-peridot
ci-peridot: artifacts/coverage/peridot/clover.xml

################################################################################

artifacts/coverage/peridot/index.html: $(PHP_PERIDOT_REQ) $(_PHP_PERIDOT_REQ)
	phpdbg $(_PHP_PERIDOT_RUNTIME_ARGS) -qrr vendor/bin/peridot $(_PHP_PERIDOT_ARGS) --reporter html-code-coverage --code-coverage-path "$(@D)"

artifacts/coverage/peridot/clover.xml: $(PHP_PERIDOT_REQ) $(_PHP_PERIDOT_REQ)
	phpdbg $(_PHP_PERIDOT_RUNTIME_ARGS) -qrr vendor/bin/peridot $(_PHP_PERIDOT_ARGS) --reporter clover-code-coverage --code-coverage-path "$(@D)"

artifacts/test/peridot.touch: $(PHP_PERIDOT_REQ) $(_PHP_PERIDOT_REQ)
	php $(_PHP_PERIDOT_RUNTIME_ARGS) vendor/bin/peridot $(_PHP_PERIDOT_ARGS)

	@mkdir -p "$(@D)"
	@touch "$@"
