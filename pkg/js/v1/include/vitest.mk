# JS_VITEST_PROJECTS is a space separated list of Vitest projects to run.
# (left undefined so it can be overridden by individual targets)

# JS_VITEST_REQ is a space separated list of prerequisites needed to run the
# Vitest tests.
JS_VITEST_REQ ?=

# JS_VITEST_FORBID_ONLY will forbid the use of .only in tests when set to a
# non-empty value.
# (left undefined so it can be overridden by individual targets)

################################################################################

# _JS_VITEST_REQ is a space separated list of automatically detected
# prerequisites needed to run the Vitest tests.
_JS_VITEST_REQ += artifacts/link-dependencies.touch artifacts/vitest/browser/public $(GENERATED_FILES)

# _JS_VITEST_ARGS is a set of arguments to use for every execution of Vitest.
_JS_VITEST_ARGS := --run
ifneq ($(JS_VITEST_CONFIG_FILE),)
_JS_VITEST_ARGS += --config="$(JS_VITEST_CONFIG_FILE)"
endif
ifneq ($(JS_VITEST_WORKSPACE_FILE),)
_JS_VITEST_ARGS += --workspace="$(JS_VITEST_WORKSPACE_FILE)"
endif

################################################################################

# test --- Executes all tests.
.PHONY: test
test:: vitest

# coverage --- Executes all tests, producing coverage reports.
.PHONY: coverage
coverage:: vitest-coverage

# coverage-open --- Opens all HTML coverage reports in a browser.
.PHONY: coverage-open
coverage-open:: vitest-coverage-open

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: JS_VITEST_FORBID_ONLY ?= true
precommit:: vitest

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: JS_VITEST_FORBID_ONLY ?= true
ci:: vitest-coverage-lcov

################################################################################

# vitest --- Executes all Vitest tests.
.PHONY: vitest
vitest: $(JS_VITEST_REQ) $(_JS_VITEST_REQ)
	$(JS_EXEC) vitest $(_JS_VITEST_ARGS)$(if $(JS_VITEST_FORBID_ONLY), --allowOnly=false) $(addprefix --project=,$(JS_VITEST_PROJECTS))

# vitest-coverage --- Produces a Vitest HTML coverage report.
.PHONY: vitest-coverage
vitest-coverage: artifacts/coverage/vitest/index.html

# vitest-coverage-open --- Opens the Vitest HTML coverage report in a browser.
.PHONY: vitest-coverage-open
vitest-coverage-open: artifacts/coverage/vitest/index.html
	$(MF_BROWSER) "$<"

# vitest-coverage-lcov --- Produces a Vitest LCOV coverage report.
.PHONY: vitest-coverage-lcov
vitest-coverage-lcov: artifacts/coverage/vitest/lcov.info

################################################################################

.PHONY: artifacts/coverage/vitest/index.html # always rebuild
artifacts/coverage/vitest/index.html: $(JS_VITEST_REQ) $(_JS_VITEST_REQ)
	$(JS_EXEC) vitest $(_JS_VITEST_ARGS)$(if $(JS_VITEST_FORBID_ONLY), --allowOnly=false) --coverage.enabled --coverage.reportsDirectory="$(@D)" --coverage.reporter=text --coverage.reporter=html $(addprefix --project=,$(JS_VITEST_PROJECTS))

.PHONY: artifacts/coverage/vitest/lcov.info # always rebuild
artifacts/coverage/vitest/lcov.info: $(JS_VITEST_REQ) $(_JS_VITEST_REQ)
	$(JS_EXEC) vitest $(_JS_VITEST_ARGS)$(if $(JS_VITEST_FORBID_ONLY), --allowOnly=false) --coverage.enabled --coverage.reportsDirectory="$(@D)" --coverage.reporter=text --coverage.reporter=lcovonly $(addprefix --project=,$(JS_VITEST_PROJECTS))

artifacts/vitest/browser/public::
	@mkdir -p "$@"
