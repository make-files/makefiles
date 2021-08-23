DOCKER_REPO := makefiles/test
PHP_PERIDOT_PRIMARY_REPORTER := dot
PHP_PHPUNIT_RESULT_CACHE_FILE :=

-include .makefiles/Makefile
-include .makefiles/pkg/php/v1/Makefile
-include .makefiles/pkg/docker/v1/Makefile

.makefiles/%:
	@curl -sfL https://makefiles.dev/v1 | bash /dev/stdin "$@"
