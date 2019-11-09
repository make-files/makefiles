# Ensure that dependencies are installed before attempting to build a Docker image.
DOCKER_BUILD_REQ += composer.json vendor

# prepare --- Perform tasks that need to be executed before committing. Stacks
# with the "prepare" target form the common makefile.
.PHONY: prepare
prepare:: artifacts/composer/validate.out

################################################################################

vendor: composer.lock
	composer install

composer.lock: composer.json
	composer install

composer.json:
	composer init --no-interaction

artifacts/composer/validate.out: composer.json
	@mkdir -p "$(@D)"
	composer validate --no-check-publish | tee "$@
