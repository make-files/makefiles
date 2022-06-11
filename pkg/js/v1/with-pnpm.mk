# JS_PNPM_INSTALL_ARGS is a set of arguments passed to "pnpm install"
JS_PNPM_INSTALL_ARGS ?=

ifneq ($(MF_NON_INTERACTIVE),)
	JS_PNPM_INSTALL_ARGS += --reporter append-only
endif

################################################################################

# set-package-version --- Sets the version field in package.json to a semver
# representation of the HEAD commit.
.PHONY: set-package-version
set-package-version:
	pnpm version --no-git-tag-version --allow-same-version "$(SEMVER)"

################################################################################

node_modules: package.json
ifeq ($(wildcard pnpm-lock.yaml),)
	pnpm install $(JS_PNPM_INSTALL_ARGS)
else
	pnpm install $(JS_PNPM_INSTALL_ARGS) --frozen-lockfile
endif

	@touch "$@"

package.json:
ifeq ($(wildcard package.json),)
	cp "$(MF_ROOT)/pkg/js/v1/etc/init.package.json" "$(MF_PROJECT_ROOT)/package.json"
endif

artifacts/pnpm/production/node_modules: package.json
ifeq ($(wildcard pnpm-lock.yaml),)
	pnpm install $(JS_PNPM_INSTALL_ARGS) --prod --modules-dir "$@"
else
	pnpm install $(JS_PNPM_INSTALL_ARGS) --prod --modules-dir "$@" --frozen-lockfile
endif

	@touch "$@"
