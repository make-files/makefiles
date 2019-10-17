# DOCKER_REPO is the fully-qualified Docker repository name.
ifndef DOCKER_REPO
$(error "DOCKER_REPO must be defined in the project's Makefile.")
endif

# DOCKER_TAG is the name of the tag used when building a Docker image.
# The default tag of 'dev' can not be pushed to the registry.
DOCKER_TAG ?= dev

# DOCKER_BUILD_REQ is a space separated list of prerequisites needed to build
# the Docker image.
DOCKER_BUILD_REQ +=

# DOCKER_BUILD_ARGS is a space separate list of additional arguments to pass to
# the "docker build" command.
DOCKER_BUILD_ARGS +=

# docker --- Builds a docker image from the Dockerfile in the root of the
# repository.
.PHONY: docker
docker: artifacts/docker/build-$(DOCKER_TAG).touch

# docker-build --- Builds a docker image from the Dockerfile in the root of the
# repository and pushes it to the registry.
.PHONY: docker-push
docker-push: artifacts/docker/push-$(DOCKER_TAG).touch

################################################################################

.dockerignore:
	@echo .makefiles > "$@"
	@echo .git >> "$@"

artifacts/docker/build-%.touch: Dockerfile .dockerignore $(DOCKER_BUILD_REQ)
	docker build \
		--pull \
		--build-arg "VERSION=$(GIT_HASH_COMMITTISH)" \
		--build-arg "TAG=$*" \
		--tag "$(DOCKER_REPO):$*" \
		$(DOCKER_BUILD_ARGS) \
		.

	@mkdir -p "$(@D)"
	@touch "$@"

.PHONY: artifacts/docker/push-dev
artifacts/docker/push-dev.touch:
	@echo "The 'dev' tag can not be pushed to the registry!"
	@exit 1

artifacts/docker/push-%.touch: artifacts/docker/build-%.touch
	docker push "$(DOCKER_REPO):$*"
	@mkdir -p "$(@D)"
	@touch "$@"
