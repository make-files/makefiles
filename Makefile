-include .makefiles/pkg/go1/v1/Makefile

.makefiles/%:
	curl -sfL https://makefiles.dev/v1 | bash /dev/stdin "$@"
