# Ensure that the Webpack build runs before attempting to build a Docker image.
DOCKER_BUILD_REQ += artifacts/webpack/build/production

################################################################################

# release --- Produce all build assets necessary for a release.
.PHONY: release
release:: artifacts/webpack/build/production

# debug --- Produce all debugging build assets.
.PHONY: debug
debug:: artifacts/webpack/build/development
