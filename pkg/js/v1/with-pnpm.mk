# JS_PNPM_INSTALL_ARGS is a set of arguments passed to "pnpm install"
JS_PNPM_INSTALL_ARGS ?=

ifneq ($(MF_NON_INTERACTIVE),)
JS_PNPM_INSTALL_ARGS += --reporter append-only
endif

################################################################################

# JS_EXEC is the command to use for executing locally installed dependencies.
JS_EXEC := pnpm exec --

################################################################################

artifacts/link-dependencies.touch: package.json
	@mkdir -p "$(@D)"

ifeq ($(wildcard pnpm-lock.yaml),)
	pnpm install $(JS_PNPM_INSTALL_ARGS)
else
	pnpm install $(JS_PNPM_INSTALL_ARGS) --frozen-lockfile
endif

	@touch "$@"

################################################################################

artifacts/linker/production/node_modules: package.json
ifeq ($(wildcard pnpm-lock.yaml),)
	pnpm install $(JS_PNPM_INSTALL_ARGS) --prod --modules-dir "$@"
else
	pnpm install $(JS_PNPM_INSTALL_ARGS) --prod --modules-dir "$@" --frozen-lockfile
endif

	@touch "$@"
