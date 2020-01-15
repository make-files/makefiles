# JS_JEST_REQ is a space separated list of prerequisites needed to run the Jest
# tests.
JS_JEST_REQ +=

################################################################################

# _JS_JEST_REQ is a space separated list of automatically detected
# prerequisites needed to run the Jest tests.
_JS_JEST_REQ += node_modules $(JS_JEST_CONFIG_FILE) $(JS_SOURCE_FILES) $(_JS_TEST_ASSETS) $(_JS_REQ)

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
ci:: artifacts/coverage/jest/lcov.info

################################################################################

# jest --- Executes all Jest tests in this package.
.PHONY: jest
jest: artifacts/test/jest.touch

# jest-coverage --- Produces a Jest HTML coverage report.
.PHONY: jest-coverage
jest-coverage: artifacts/coverage/jest/index.html

# jest-coverage-open --- Opens the Jest HTML coverage report in a browser.
.PHONY: jest-coverage-open
jest-coverage-open: artifacts/coverage/jest/index.html
	open "$<"

################################################################################

artifacts/coverage/jest/index.html: $(JS_JEST_REQ) $(_JS_JEST_REQ)
	node_modules/.bin/jest $(_JS_JEST_ARGS) --coverage --coverage-directory="$(@D)" --coverage-reporters text-summary --coverage-reporters html

artifacts/coverage/jest/lcov.info: $(JS_JEST_REQ) $(_JS_JEST_REQ)
	node_modules/.bin/jest $(_JS_JEST_ARGS) --ci --coverage --coverage-directory="$(@D)" --coverage-reporters text-summary --coverage-reporters lcovonly

artifacts/test/jest.touch: $(JS_JEST_REQ) $(_JS_JEST_REQ)
	node_modules/.bin/jest $(_JS_JEST_ARGS)

	@mkdir -p "$(@D)"
	@touch "$@"
