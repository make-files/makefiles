MF_LANGUAGES += js

# Always run tests by default, even if other makefiles are included beforehand.
.DEFAULT_GOAL := test

# JS_SOURCE_FILES is a space separated list of all files in the src directory.
JS_SOURCE_FILES += $(shell PATH="$(PATH)" git-find src)

# JS_TEST_FILES is a space separated list of all files in the test directory.
JS_TEST_FILES += $(shell PATH="$(PATH)" git-find test)

# JS_ESLINT_CONFIG_FILE is the path to any existing ESLint configuration.
JS_ESLINT_CONFIG_FILE ?= $(shell PATH="$(PATH)" find-first-matching-file .eslintrc.* .eslintrc)

# JS_JEST_CONFIG_FILE is the path to any existing Jest configuration.
JS_JEST_CONFIG_FILE ?= $(shell PATH="$(PATH)" find-first-matching-file jest.config.*)

# JS_PRETTIER_CONFIG_FILE is the path to any existing Prettier configuration.
JS_PRETTIER_CONFIG_FILE ?= $(shell PATH="$(PATH)" find-first-matching-file .prettierrc .prettierrc.* prettier.config.*)

# JS_SIZE_LIMIT_CONFIG_FILE is the path to any existing Size Limit
# configuration.
JS_SIZE_LIMIT_CONFIG_FILE ?= $(shell PATH="$(PATH)" find-first-matching-file .size-limit.*)

# JS_WEBPACK_CONFIG_FILE is the path to any existing Webpack configuration.
JS_WEBPACK_CONFIG_FILE ?= $(shell PATH="$(PATH)" find-first-matching-file webpack.config.*)

################################################################################

# set-package-version --- Sets the version field in package.json to a semver
# representation of the HEAD commit.
.PHONY: set-package-version
set-package-version:
	cp package.json package.old.json
	jq '.version = "$(SEMVER)"' package.old.json > package.json
	rm package.old.json

################################################################################

# Docker builds depend on linking dependencies.
DOCKER_BUILD_REQ += artifacts/link-dependencies.touch

# Docker builds depend on all JS source files.
DOCKER_BUILD_REQ += $(JS_SOURCE_FILES)

################################################################################

package.json:
ifeq ($(wildcard package.json),)
	cp "$(MF_ROOT)/pkg/js/v1/etc/init.package.json" "$(MF_PROJECT_ROOT)/package.json"
endif

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

ifneq ($(JS_PRETTIER_CONFIG_FILE),)
-include .makefiles/pkg/js/v1/include/prettier.mk
endif

ifneq ($(JS_SIZE_LIMIT_CONFIG_FILE),)
-include .makefiles/pkg/js/v1/include/size-limit.mk
endif
