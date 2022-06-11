# JS_YARN_INSTALL_ARGS is a set of arguments passed to "yarn install"
JS_YARN_INSTALL_ARGS ?=

ifneq ($(MF_NON_INTERACTIVE),)
	JS_YARN_INSTALL_ARGS += --non-interactive --no-progress
endif

################################################################################

node_modules: package.json
ifeq ($(wildcard yarn.lock),)
	yarn install $(JS_YARN_INSTALL_ARGS)
else
	yarn install $(JS_YARN_INSTALL_ARGS) --frozen-lockfile
endif

	@touch "$@"

package.json:
ifeq ($(wildcard package.json),)
	cp "$(MF_ROOT)/pkg/js/v1/etc/init.package.json" "$(MF_PROJECT_ROOT)/package.json"
endif

artifacts/yarn/production/node_modules: package.json
ifeq ($(wildcard yarn.lock),)
	yarn install $(JS_YARN_INSTALL_ARGS) --production --modules-folder "$@" --pure-lockfile
else
	yarn install $(JS_YARN_INSTALL_ARGS) --production --modules-folder "$@" --frozen-lockfile
endif

	@touch "$@"
