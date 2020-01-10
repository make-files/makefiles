# Always run tests by default, even if other makefiles are included beforehand.
.DEFAULT_GOAL := test

# JS_SOURCE_FILES is a space separated list of source files in the repo.
JS_SOURCE_FILES += $(shell PATH="$(PATH)" git-find '*.js')

################################################################################

# _JS_TEST_ASSETS is a space separated list of all non-JS files in the test
# directory.
_JS_TEST_ASSETS := $(shell find test -type f -not -iname "*.js" 2> /dev/null)

# Ensure that dependencies are installed before attempting to build a Docker
# image.
DOCKER_BUILD_REQ += node_modules
