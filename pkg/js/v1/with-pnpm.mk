# JS_PNPM_INSTALL_ARGS is a set of arguments passed to "pnpm install"
JS_PNPM_INSTALL_ARGS ?=

ifneq ($(MF_NON_INTERACTIVE),)
JS_PNPM_INSTALL_ARGS += --reporter append-only
endif

################################################################################

node_modules: package.json
ifeq ($(wildcard pnpm-lock.yaml),)
	pnpm install $(JS_PNPM_INSTALL_ARGS)
else
	pnpm install $(JS_PNPM_INSTALL_ARGS) --frozen-lockfile
endif

	@touch "$@"

artifacts/pnpm/production/node_modules: package.json
ifeq ($(wildcard pnpm-lock.yaml),)
	pnpm install $(JS_PNPM_INSTALL_ARGS) --prod --modules-dir "$@"
else
	pnpm install $(JS_PNPM_INSTALL_ARGS) --prod --modules-dir "$@" --frozen-lockfile
endif

	@touch "$@"
