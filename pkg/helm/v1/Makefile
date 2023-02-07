# HELM_CHART_PATH is the path to the Helm chart for this repo.
HELM_CHART_PATH ?= charts

################################################################################

# helm-package --- Packages the Helm chart in preparation for pushing to a Helm
# repository. Automatically sets the chart and app version to a
# SemVer-compatible representation of the current Git tag/commit.
#
# See lib/core/include/common.mk for details on how this version is built.
.PHONY: helm-package
helm-package:
	helm package \
		"$(HELM_CHART_PATH)" \
		--destination artifacts/helm/package \
		--version "$(SEMVER)" \
		--app-version "$(SEMVER)"
