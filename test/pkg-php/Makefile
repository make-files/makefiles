DOCKER_REPO := makefiles/test

-include .makefiles/Makefile
-include .makefiles/pkg/php/v1/Makefile
-include .makefiles/pkg/docker/v1/Makefile

.makefiles/%:
	@curl -sfL https://makefiles.dev/v1 | bash /dev/stdin "$@"

################################################################################

.PHONY: noop
noop:
