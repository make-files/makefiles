# HELM_CHART_NAME is the name of the Helm chart for this repo.
HELM_CHART_NAME ?= $(notdir $(MF_PROJECT_ROOT))

# HELM_CHART_PATH is the path to the Helm chart for this repo.
HELM_CHART_PATH ?= charts

# HELM_VALUES_PATH is the path to the Helm values for this repo.
HELM_VALUES_PATH ?= $(HELM_CHART_PATH)/values.yaml

################################################################################

# _HELM_PACKAGE is the filename of the Helm package.
_HELM_PACKAGE = artifacts/helm/package/$(HELM_CHART_NAME)-$(SEMVER).tgz

# _HELM_PACKAGE_REQ is a space separated list of prerequisites needed to package
# the Helm chart.
_HELM_PACKAGE_REQ = $(shell PATH="$(PATH)" git-find "$(HELM_CHART_PATH)")

# _HELM_VALUES_ARG is a condintional flag that adds --values if HELM_VALUES_PATH
# exists.
ifeq ($(wildcard $(HELM_VALUES_PATH)),)
_HELM_VALUES_ARG =
else
_HELM_VALUES_ARG = --values "$(HELM_VALUES_PATH)"
endif

################################################################################

# helm-lint --- Uses helms lint command to verify that the syntax of the
# templates are correct.
.PHONY: helm-lint
helm-lint:
	helm lint --strict $(_HELM_VALUES_ARG) "$(HELM_CHART_PATH)"

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

$(_HELM_PACKAGE): $(_HELM_PACKAGE_REQ)
	helm package \
		"$(HELM_CHART_PATH)" \
		--destination "$(@D)" \
		--version "$(SEMVER)" \
		--app-version "$(SEMVER)"
