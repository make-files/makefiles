# DOCKER_REPO is the fully-qualified Docker repository name.
ifndef DOCKER_REPO
$(error "DOCKER_REPO must be defined in the project's Makefile.")
endif

# DOCKER_TAGS is a space-separated list of tag names used when building a Docker
# image. The list defaults to just 'dev'. Note that the 'dev' tag cannot be
# pushed to the registry.
DOCKER_TAGS ?= dev

# DOCKER_BUILD_REQ is a space separated list of prerequisites needed to build
# the Docker image.
DOCKER_BUILD_REQ +=

# DOCKER_BUILD_ARGS is a space separate list of additional arguments to pass to
# the "docker build" command.
DOCKER_BUILD_ARGS +=

# DOCKER_PLATFORMS is a list of the target platforms for the Docker image.
DOCKER_PLATFORMS ?= linux/amd64

################################################################################

# _DOCKER_PUSH_GUARDS is a list of phony targets that are used as prerequisites
# to the docker-push target to prevent pushing "dev" tags.
_DOCKER_PUSH_GUARDS := $(foreach TAG,$(DOCKER_TAGS),_docker-push-guard-$(TAG))

# _DOCKER_BUILD_REQ is the union of DOCKER_BUILD_REQ and any other files that
# are always considered prerequisites to Docker builds.
_DOCKER_BUILD_REQ = Dockerfile .dockerignore $(DOCKER_BUILD_REQ)

# _DOCKER_QUALIFIED_TAGS is the list of fully-qualified Docker image tags made
# by concatenating DOCKER_REPO wich each value from DOCKER_TAGS. 
_DOCKER_QUALIFIED_TAGS = $(foreach TAG,$(DOCKER_TAGS),$(DOCKER_REPO):$(TAG))

# _DOCKER_QUALIFIED_TAGS_LIST and _DOCKER_PLATFORMS_LIST are comma-separated
# versions of _DOCKER_QUALIFIED_TAGS and DOCKER_PLATFORMS, respectively.
_DOCKER_QUALIFIED_TAGS_LIST = $(shell echo $(_DOCKER_QUALIFIED_TAGS) | tr ' ' ',')
_DOCKER_PLATFORMS_LIST = $(shell echo $(DOCKER_PLATFORMS) | tr ' ' ',')

################################################################################

# docker --- Builds a docker image for the current platform and "loads" the
# image into the local Docker server.
.PHONY: docker
docker: $(_DOCKER_BUILD_REQ)
	docker buildx build \
		--tag $(_DOCKER_QUALIFIED_TAGS_LIST) \
		--build-arg "VERSION=$(SEMVER)" \
		--pull \
		--load \
		.

# docker-test --- Builds docker images for each target platform then
# discards the result.
.PHONY: docker
docker-test: $(_DOCKER_BUILD_REQ)
	docker buildx build \
		--tag $(_DOCKER_QUALIFIED_TAGS_LIST) \
		--platform $(_DOCKER_PLATFORMS_LIST) \
		--build-arg "VERSION=$(SEMVER)" \
		--pull \
		.

# docker-build --- Builds docker images for each target platform and pushes
# those images, and a manifest list to the registry.
.PHONY: docker-push
docker-push: $(_DOCKER_BUILD_REQ) $(_DOCKER_PUSH_GUARDS)
	docker buildx build \
		--tag $(_DOCKER_QUALIFIED_TAGS_LIST) \
		--platform $(_DOCKER_PLATFORMS_LIST) \
		--build-arg "VERSION=$(SEMVER)" \
		--pull \
		--push \
		.

################################################################################

# Treat any dependencies of the Docker build as secondary build targets so that
# they are not deleted after a successful build.
.SECONDARY: $(DOCKER_BUILD_REQ)

.dockerignore:
	@echo .makefiles > "$@"
	@echo .git >> "$@"


.PHONY: $(_DOCKER_PUSH_GUARDS)
_docker-push-guard-dev:
	@echo "The 'dev' tag can not be pushed to the registry, did you forget to set the DOCKER_TAGS environment variable?"
	@exit 1

_docker-push-guard-%: 
