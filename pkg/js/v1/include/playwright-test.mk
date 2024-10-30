-include .makefiles/pkg/js/v1/include/playwright.mk

export PLAYWRIGHT_BLOB_OUTPUT_DIR=artifacts/playwright/report/blob
export PLAYWRIGHT_HTML_OUTPUT_DIR=artifacts/playwright/report/html
export PLAYWRIGHT_JSON_OUTPUT_DIR=artifacts/playwright/report/json
export PLAYWRIGHT_JUNIT_OUTPUT_DIR=artifacts/playwright/report/junit

export PLAYWRIGHT_HTML_OPEN=never

################################################################################

# JS_PLAYWRIGHT_TEST_PROJECTS is a space separated list of Playwright projects
# to run.
# (left undefined so it can be overridden by individual targets)

# JS_PLAYWRIGHT_TEST_REQ is a space separated list of prerequisites needed to
# run the Playwright tests.
JS_PLAYWRIGHT_TEST_REQ ?=

# JS_PLAYWRIGHT_TEST_FORBID_ONLY will forbid the use of .only in tests when set
# to a non-empty value.
# (left undefined so it can be overridden by individual targets)

# JS_PLAYWRIGHT_TEST_RETRIES sets the number of retries.
# (left undefined so it can be overridden by individual targets)

# JS_PLAYWRIGHT_TEST_REPORTERS sets the reporters to use.
# (left undefined so it can be overridden by individual targets)

# JS_PLAYWRIGHT_TEST_WORKERS sets the number of workers.
# (left undefined so it can be overridden by individual targets)

# JS_PLAYWRIGHT_TEST_TRACE will enable tracing when set to a non-empty value.
JS_PLAYWRIGHT_TEST_TRACE ?=

################################################################################

# _JS_PLAYWRIGHT_TEST_REQ is a space separated list of automatically detected
# prerequisites needed to run the Playwright tests.
_JS_PLAYWRIGHT_TEST_REQ += artifacts/link-dependencies.touch $(GENERATED_FILES)

# _JS_PLAYWRIGHT_TEST_ARGS is a set of arguments to use for every execution of Playwright.
ifneq ($(JS_PLAYWRIGHT_TEST_CONFIG_FILE),)
_JS_PLAYWRIGHT_TEST_ARGS += --config="$(JS_PLAYWRIGHT_TEST_CONFIG_FILE)"
endif
ifneq ($(JS_PLAYWRIGHT_TEST_TRACE),)
_JS_PLAYWRIGHT_TEST_ARGS += --trace=on
endif

################################################################################

# test --- Executes all tests.
.PHONY: test
test:: playwright-test

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: JS_PLAYWRIGHT_TEST_FORBID_ONLY ?= true
precommit:: playwright-test

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: JS_PLAYWRIGHT_TEST_FORBID_ONLY ?= true
ci:: JS_PLAYWRIGHT_TEST_REPORTERS ?= dot html $(if $(GITHUB_ACTIONS),github)
ci:: JS_PLAYWRIGHT_TEST_RETRIES ?= 2
ci:: JS_PLAYWRIGHT_TEST_WORKERS ?= 1
ci:: playwright-test

################################################################################

# playwright-test --- Executes all Playwright tests.
.PHONY: playwright-test
playwright-test:: JS_PLAYWRIGHT_TEST_REPORTERS ?= dot html
playwright-test:: JS_PLAYWRIGHT_TEST_RETRIES ?= 1
playwright-test: $(JS_PLAYWRIGHT_TEST_REQ) $(_JS_PLAYWRIGHT_TEST_REQ)
	$(JS_EXEC) playwright test $(_JS_PLAYWRIGHT_TEST_ARGS) --output=artifacts/playwright/output$(if $(JS_PLAYWRIGHT_TEST_WORKERS), --workers=$(JS_PLAYWRIGHT_TEST_WORKERS))$(if $(JS_PLAYWRIGHT_TEST_RETRIES), --retries=$(JS_PLAYWRIGHT_TEST_RETRIES))$(if $(JS_PLAYWRIGHT_TEST_FORBID_ONLY), --forbid-only) $(addprefix --reporter=,$(JS_PLAYWRIGHT_TEST_REPORTERS)) $(addprefix --project=,$(JS_PLAYWRIGHT_TEST_PROJECTS))

# playwright-test-ui --- Executes all Playwright tests in UI mode.
.PHONY: playwright-test-ui
playwright-test-ui: $(JS_PLAYWRIGHT_TEST_REQ) $(_JS_PLAYWRIGHT_TEST_REQ)
	$(JS_EXEC) playwright test $(_JS_PLAYWRIGHT_TEST_ARGS) --output=artifacts/playwright/output$(if $(JS_PLAYWRIGHT_TEST_WORKERS), --workers=$(JS_PLAYWRIGHT_TEST_WORKERS))$(if $(JS_PLAYWRIGHT_TEST_RETRIES), --retries=$(JS_PLAYWRIGHT_TEST_RETRIES))$(if $(JS_PLAYWRIGHT_TEST_FORBID_ONLY), --forbid-only) $(addprefix --reporter=,$(JS_PLAYWRIGHT_TEST_REPORTERS)) --ui $(addprefix --project=,$(JS_PLAYWRIGHT_TEST_PROJECTS))

# playwright-test-show-report --- Serves the Playwright test report.
.PHONY: playwright-test-show-report
playwright-test-show-report:
	$(JS_EXEC) playwright show-report
