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

artifacts/yarn/production/node_modules: package.json
ifeq ($(wildcard yarn.lock),)
	yarn install $(JS_YARN_INSTALL_ARGS) --production --modules-folder "$@" --pure-lockfile
else
	yarn install $(JS_YARN_INSTALL_ARGS) --production --modules-folder "$@" --frozen-lockfile
endif

	@touch "$@"
