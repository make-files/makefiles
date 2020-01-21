# JS_YARN_INSTALL_ARGS is a set of arguments passed to "yarn install"
JS_YARN_INSTALL_ARGS ?= --pure-lockfile

################################################################################

# Ensure that dependencies are installed before attempting to build a Docker
# image.
DOCKER_BUILD_REQ += package.json yarn.lock

################################################################################

node_modules: yarn.lock
	yarn install $(JS_YARN_INSTALL_ARGS)

yarn.lock: package.json
	yarn install $(JS_YARN_INSTALL_ARGS)

	@touch "$@"

package.json:
ifeq ($(wildcard package.json),)
	cp "$(MF_ROOT)/pkg/js/v1/etc/init.package.json" "$(MF_PROJECT_ROOT)/package.json"
endif

artifacts/yarn/production/node_modules: yarn.lock
	yarn install $(JS_YARN_INSTALL_ARGS) --production --modules-folder "$@"
