-include .makefiles/go1/v1/Makefile

.makefiles/%:
	curl -sfSL https://makefiles.dev/v1 | bash /dev/stdin "$@"
