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
test:: test-jest

# coverage --- Executes all tests, producing coverage reports.
.PHONY: coverage
coverage:: coverage-jest

# coverage-open --- Opens all HTML coverage reports in a browser.
.PHONY: coverage-open
coverage-open:: coverage-jest-open

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: test-jest

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: ci-jest

################################################################################

# test-jest --- Executes all Jest tests in this package.
.PHONY: test-jest
test-jest: artifacts/test/jest.touch

# coverage-jest --- Produces a Jest HTML coverage report.
.PHONY: coverage-jest
coverage-jest: artifacts/coverage/jest/index.html

# coverage-jest-open --- Opens the Jest HTML coverage report in a browser.
.PHONY: coverage-jest-open
coverage-jest-open: artifacts/coverage/jest/index.html
	open "$<"

# ci-jest --- Executes all Jest tests in this package, and produces a
#             machine-readable coverage report.
.PHONY: ci-jest
ci-jest: artifacts/coverage/jest/lcov.info

################################################################################

artifacts/coverage/jest/index.html: $(JS_JEST_REQ) $(_JS_JEST_REQ)
	node_modules/.bin/jest $(_JS_JEST_ARGS) --coverage --coverage-directory="$(@D)" --coverage-reporters text-summary --coverage-reporters html

artifacts/coverage/jest/lcov.info: $(JS_JEST_REQ) $(_JS_JEST_REQ)
	node_modules/.bin/jest $(_JS_JEST_ARGS) --ci --coverage --coverage-directory="$(@D)" --coverage-reporters text-summary --coverage-reporters lcovonly

artifacts/test/jest.touch: $(JS_JEST_REQ) $(_JS_JEST_REQ)
	node_modules/.bin/jest $(_JS_JEST_ARGS)

	@mkdir -p "$(@D)"
	@touch "$@"
