# _JS_YARN_MODERN will contain "true" if Yarn > 1 is in use.
_JS_YARN_MODERN := $(if $(wildcard .yarnrc.yml),true,)

################################################################################

# JS_YARN_INSTALL_ARGS is a set of arguments passed to "yarn install"
JS_YARN_INSTALL_ARGS ?=

ifneq ($(MF_NON_INTERACTIVE),)
ifneq ($(_JS_YARN_MODERN),true)
JS_YARN_INSTALL_ARGS += --non-interactive --no-progress
endif
endif

################################################################################

# JS_EXEC is the command to use for executing locally installed dependencies.
ifeq ($(_JS_YARN_MODERN),true)
JS_EXEC := yarn exec --
else
JS_EXEC := yarn exec --silent --
endif

################################################################################

artifacts/link-dependencies.touch: package.json
	@mkdir -p "$(@D)"

ifeq ($(wildcard yarn.lock),)
	yarn install $(JS_YARN_INSTALL_ARGS)
else
ifeq ($(_JS_YARN_MODERN),true)
	yarn install $(JS_YARN_INSTALL_ARGS) --immutable
else
	yarn install $(JS_YARN_INSTALL_ARGS) --frozen-lockfile
endif
endif

	@touch "$@"

################################################################################

ifneq ($(_JS_YARN_MODERN),true)

define _JS_YARN_PRODUCTION_NODE_MODULES_DEPRECATED
WARNING: The "artifacts/yarn/production/node_modules" make target is deprecated.
  - Use the new "artifacts/linker/production/node_modules" target instead.
endef

artifacts/yarn/production/node_modules: package.json
ifeq ($(wildcard yarn.lock),)
	yarn install $(JS_YARN_INSTALL_ARGS) --production --modules-folder "$@" --pure-lockfile
else
	yarn install $(JS_YARN_INSTALL_ARGS) --production --modules-folder "$@" --frozen-lockfile
endif

	@touch "$@"
	$(warning $(_JS_YARN_PRODUCTION_NODE_MODULES_DEPRECATED))

artifacts/linker/production/node_modules: package.json
ifeq ($(wildcard yarn.lock),)
	yarn install $(JS_YARN_INSTALL_ARGS) --production --modules-folder "$@" --pure-lockfile
else
	yarn install $(JS_YARN_INSTALL_ARGS) --production --modules-folder "$@" --frozen-lockfile
endif

	@touch "$@"

endif
