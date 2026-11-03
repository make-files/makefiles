# JS_PNPM_INSTALL_ARGS is a set of arguments passed to "pnpm install"
JS_PNPM_INSTALL_ARGS ?=

ifneq ($(MF_NON_INTERACTIVE),)
JS_PNPM_INSTALL_ARGS += --reporter append-only
endif

################################################################################

# _JS_PNPM is the command used to run pnpm. It is run via tool-exec, so that a
# project that declares pnpm in mise.toml uses that version. Its full path is
# used because GNU Make 3.81 does not search the exported PATH for commands that
# it runs without a shell.
_JS_PNPM := $(MF_ROOT)/lib/core/bin/tool-exec pnpm

# JS_EXEC is the command to use for executing locally installed dependencies.
JS_EXEC := $(_JS_PNPM) exec --

################################################################################

artifacts/link-dependencies.touch: package.json $(MF_TOOL_REQ)
	@mkdir -p "$(@D)"

ifeq ($(wildcard pnpm-lock.yaml),)
	$(_JS_PNPM) install $(JS_PNPM_INSTALL_ARGS)
else
	$(_JS_PNPM) install $(JS_PNPM_INSTALL_ARGS) --frozen-lockfile
endif

	@touch "$@"

################################################################################

artifacts/linker/production/node_modules: package.json $(MF_TOOL_REQ)
ifeq ($(wildcard pnpm-lock.yaml),)
	$(_JS_PNPM) install $(JS_PNPM_INSTALL_ARGS) --prod --modules-dir "$@"
else
	$(_JS_PNPM) install $(JS_PNPM_INSTALL_ARGS) --prod --modules-dir "$@" --frozen-lockfile
endif

	@touch "$@"
