# Ensure that dependencies are installed before attempting to build a Docker image.
DOCKER_BUILD_REQ += composer.json composer.lock

# prepare --- Perform tasks that need to be executed before committing. Stacks
# with the "prepare" target form the common makefile.
.PHONY: prepare
prepare:: artifacts/composer/validate.touch

################################################################################

vendor: composer.lock
	composer install

composer.lock: | composer.json
	composer install

composer.json:
	composer init --no-interaction

artifacts/composer/validate.touch: composer.json
	composer validate --no-check-publish

	@mkdir -p "$(@D)"
	@touch "$@"
