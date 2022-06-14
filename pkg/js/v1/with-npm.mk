# JS_NPM_INSTALL_ARGS is a set of arguments passed to "npm install"
JS_NPM_INSTALL_ARGS ?=

ifneq ($(MF_NON_INTERACTIVE),)
JS_NPM_INSTALL_ARGS += --no-progress
endif

################################################################################

# JS_EXEC is the command to use for executing locally installed dependencies.
JS_EXEC := npm exec --

################################################################################

artifacts/link-dependencies.touch: package.json
	@mkdir -p "$(@D)"

ifeq ($(wildcard package-lock.json),)
	npm install $(JS_NPM_INSTALL_ARGS)
else
	npm ci $(JS_NPM_INSTALL_ARGS)
endif

	@touch "$@"

################################################################################

artifacts/linker/production/node_modules: package.json
	@mkdir -p "$(@D)"
	cp package.json "$(@D)/package.json"

ifeq ($(wildcard package-lock.json),)
	npm install $(JS_NPM_INSTALL_ARGS) --omit=dev --prefix "$(@D)"
else
	cp package-lock.json "$(@D)/package-lock.json"
	npm ci $(JS_NPM_INSTALL_ARGS) --omit=dev --prefix "$(@D)"
endif

	@touch "$@"
