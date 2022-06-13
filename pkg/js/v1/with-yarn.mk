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

# _js_node_exec returns a command that executes the supplied executable.
ifeq ($(_JS_YARN_MODERN),true)
define _js_node_exec
yarn exec -- $1
endef
else
define _js_node_exec
yarn exec --silent -- $1
endef
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

artifacts/yarn/production/node_modules: artifacts/linker/production/node_modules
	@mkdir -p "$(@D)"

	ln -sf ../../linker/production/node_modules "$@"

artifacts/linker/production/node_modules: package.json
ifeq ($(wildcard yarn.lock),)
	yarn install $(JS_YARN_INSTALL_ARGS) --production --modules-folder "$@" --pure-lockfile
else
	yarn install $(JS_YARN_INSTALL_ARGS) --production --modules-folder "$@" --frozen-lockfile
endif

	@touch "$@"

endif
