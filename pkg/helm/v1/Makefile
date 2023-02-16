# HELM_CHART_NAME is the name of the Helm chart for this repo.
HELM_CHART_NAME ?= $(notdir $(MF_PROJECT_ROOT))

# HELM_CHART_PATH is the path to the Helm chart for this repo.
HELM_CHART_PATH ?= charts

################################################################################

# _HELM_PACKAGE is the filename of the Helm package.
_HELM_PACKAGE = artifacts/helm/package/$(HELM_CHART_NAME)-$(SEMVER).tgz

# _HELM_FILES is a space separated list of every file in HELM_CHART_PATH.
_HELM_FILES = $(shell PATH="$(PATH)" git-find "$(HELM_CHART_PATH)")

################################################################################

# lint --- Check for syntax, configuration, code style and/or formatting issues.
.PHONY: lint
lint:: helm-lint

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: helm-lint

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: helm-lint

################################################################################

# helm-lint --- Uses helm lint to verify that the syntax of the templates are
# correct.
.PHONY: helm-lint
helm-lint:
	helm lint --strict "$(HELM_CHART_PATH)"

# helm-template --- Render the Helm templates to an artifacts directory.
.PHONY: helm-template
helm-template: artifacts/helm/template

# helm-package --- Packages the Helm chart in preparation for pushing to the
# registry. Automatically sets the chart and app version to a SemVer-compatible
# representation of the current Git tag/commit.
#
# See lib/core/include/common.mk for details on how this version is built.
.PHONY: helm-package
helm-package: $(_HELM_PACKAGE)

# helm-push --- Pushes the packaged Helm chart to the registry.
.PHONY: helm-push
helm-push: $(_HELM_PACKAGE)
ifndef HELM_REGISTRY
	$(error "HELM_REGISTRY must be defined in order to push.")
endif
	helm push $(_HELM_PACKAGE) $(HELM_REGISTRY)

################################################################################

artifacts/helm/template: $(_HELM_FILES)
	@rm -rf "$@"
	helm template --output-dir "$@" "$(HELM_CHART_PATH)"

$(_HELM_PACKAGE): $(_HELM_FILES)
	helm package \
		"$(HELM_CHART_PATH)" \
		--destination "$(@D)" \
		--version "$(SEMVER)" \
		--app-version "$(SEMVER)"
