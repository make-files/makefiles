# JS_NPM_INSTALL_ARGS is a set of arguments passed to "npm install"
JS_NPM_INSTALL_ARGS ?=

ifneq ($(MF_NON_INTERACTIVE),)
	JS_NPM_INSTALL_ARGS += --no-progress
endif

################################################################################

node_modules: package.json
ifeq ($(wildcard package-lock.json),)
	npm install $(JS_NPM_INSTALL_ARGS)
else
	npm ci $(JS_NPM_INSTALL_ARGS)
endif

	@touch "$@"

package.json:
ifeq ($(wildcard package.json),)
	cp "$(MF_ROOT)/pkg/js/v1/etc/init.package.json" "$(MF_PROJECT_ROOT)/package.json"
endif

artifacts/npm/production/node_modules: package.json
	@mkdir -p "$(@D)"
	cp package.json "$(@D)/package.json"

ifeq ($(wildcard package-lock.json),)
	npm install $(JS_NPM_INSTALL_ARGS) --omit=dev --prefix "$(@D)"
else
	cp package-lock.json "$(@D)/package-lock.json"
	npm ci $(JS_NPM_INSTALL_ARGS) --omit=dev --prefix "$(@D)"
endif

	@touch "$@"