# Always run tests by default, even if other makefiles are included beforehand.
.DEFAULT_GOAL := test

# JS_SOURCE_FILES is a space separated list of source files in the repo.
JS_SOURCE_FILES += $(shell PATH="$(PATH)" git-find '*.js')

# JS_ESLINT_CONFIG_FILE is the path to any existing ESLint configuration.
JS_ESLINT_CONFIG_FILE ?= $(shell PATH="$(PATH)" find-first-matching-file .eslintrc.* .eslintrc)

# JS_JEST_CONFIG_FILE is the path to any existing Jest configuration.
JS_JEST_CONFIG_FILE ?= $(shell PATH="$(PATH)" find-first-matching-file jest.config.*)

# JS_SIZE_LIMIT_CONFIG_FILE is the path to any existing Size Limit
# configuration.
JS_SIZE_LIMIT_CONFIG_FILE ?= $(shell PATH="$(PATH)" find-first-matching-file .size-limit.*)

# JS_WEBPACK_CONFIG_FILE is the path to any existing Webpack configuration.
JS_WEBPACK_CONFIG_FILE ?= $(shell PATH="$(PATH)" find-first-matching-file webpack.config.*)

################################################################################

# _JS_TEST_ASSETS is a space separated list of all non-JS files in the test
# directory.
_JS_TEST_ASSETS := $(shell find test -type f -not -iname "*.js" 2> /dev/null)

# Ensure that dependencies are installed before attempting to build a Docker
# image.
DOCKER_BUILD_REQ += node_modules $(JS_SOURCE_FILES)

################################################################################

# Build systems

ifneq ($(JS_WEBPACK_CONFIG_FILE),)
-include .makefiles/pkg/js/v1/include/webpack.mk
endif

# Test runners

ifneq ($(JS_JEST_CONFIG_FILE),)
-include .makefiles/pkg/js/v1/include/jest.mk
endif

# Lint tools

ifneq ($(JS_ESLINT_CONFIG_FILE),)
-include .makefiles/pkg/js/v1/include/eslint.mk
endif

ifneq ($(JS_SIZE_LIMIT_CONFIG_FILE),)
-include .makefiles/pkg/js/v1/include/size-limit.mk
endif
