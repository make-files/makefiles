# Ensure that dependencies are installed before attempting to build a Docker image.
DOCKER_BUILD_REQ += vendor

-include .makefiles/pkg/php/v1/composer.mk
