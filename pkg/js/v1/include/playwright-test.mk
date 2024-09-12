-include .makefiles/pkg/js/v1/include/playwright.mk

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

################################################################################

# _JS_PLAYWRIGHT_TEST_REQ is a space separated list of automatically detected
# prerequisites needed to run the Playwright tests.
_JS_PLAYWRIGHT_TEST_REQ += artifacts/link-dependencies.touch $(GENERATED_FILES)

# _JS_PLAYWRIGHT_TEST_ARGS is a set of arguments to use for every execution of Playwright.
ifneq ($(JS_PLAYWRIGHT_TEST_CONFIG_FILE),)
_JS_PLAYWRIGHT_TEST_ARGS += --config="$(JS_PLAYWRIGHT_TEST_CONFIG_FILE)"
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
ci:: playwright-test

################################################################################

# playwright-test --- Executes all Playwright tests.
.PHONY: playwright-test
playwright-test: $(JS_PLAYWRIGHT_TEST_REQ) $(_JS_PLAYWRIGHT_TEST_REQ)
	$(JS_EXEC) playwright test $(_JS_PLAYWRIGHT_TEST_ARGS)$(if $(JS_PLAYWRIGHT_TEST_FORBID_ONLY), --forbid-only) $(addprefix --project=,$(JS_PLAYWRIGHT_TEST_PROJECTS))

# playwright-test-ui --- Executes all Playwright tests in UI mode.
.PHONY: playwright-test-ui
playwright-test-ui: $(JS_PLAYWRIGHT_TEST_REQ) $(_JS_PLAYWRIGHT_TEST_REQ)
	$(JS_EXEC) playwright test $(_JS_PLAYWRIGHT_TEST_ARGS)$(if $(JS_PLAYWRIGHT_TEST_FORBID_ONLY), --forbid-only) --ui $(addprefix --project=,$(JS_PLAYWRIGHT_TEST_PROJECTS))
