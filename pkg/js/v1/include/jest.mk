# JS_JEST_REQ is a space separated list of prerequisites needed to run the Jest
# tests.
JS_JEST_REQ +=

################################################################################

# _JS_JEST_REQ is a space separated list of automatically detected
# prerequisites needed to run the Jest tests.
_JS_JEST_REQ += artifacts/link-dependencies.touch $(GENERATED_FILES)

# _JS_JEST_ARGS is a set of arguments to use for every execution of Jest.
_JS_JEST_ARGS := --config "$(JS_JEST_CONFIG_FILE)"

################################################################################

# test --- Executes all tests.
.PHONY: test
test:: jest

# coverage --- Executes all tests, producing coverage reports.
.PHONY: coverage
coverage:: jest-coverage

# coverage-open --- Opens all HTML coverage reports in a browser.
.PHONY: coverage-open
coverage-open:: jest-coverage-open

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: jest

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: jest-coverage-lcov

################################################################################

# jest --- Executes all Jest tests in this package.
.PHONY: jest
jest: $(JS_JEST_REQ) $(_JS_JEST_REQ)
	$(call js_exec,jest) $(_JS_JEST_ARGS)

# jest-coverage --- Produces a Jest HTML coverage report.
.PHONY: jest-coverage
jest-coverage: artifacts/coverage/jest/index.html

# jest-coverage-open --- Opens the Jest HTML coverage report in a browser.
.PHONY: jest-coverage-open
jest-coverage-open: artifacts/coverage/jest/index.html
	open "$<"

# jest-coverage-lcov --- Produces a Jest LCOV coverage report.
.PHONY: jest-coverage-lcov
jest-coverage-lcov: artifacts/coverage/jest/lcov.info

################################################################################

.PHONY: artifacts/coverage/jest/index.html # always rebuild
artifacts/coverage/jest/index.html: $(JS_JEST_REQ) $(_JS_JEST_REQ)
	$(call js_exec,jest) $(_JS_JEST_ARGS) --coverage --coverage-directory="$(@D)" --coverage-reporters text-summary --coverage-reporters html

.PHONY: artifacts/coverage/jest/lcov.info # always rebuild
artifacts/coverage/jest/lcov.info: $(JS_JEST_REQ) $(_JS_JEST_REQ)
	$(call js_exec,jest) $(_JS_JEST_ARGS) --ci --coverage --coverage-directory="$(@D)" --coverage-reporters text-summary --coverage-reporters lcovonly
