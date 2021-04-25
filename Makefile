# Always run tests by default, even if other makefiles are included beforehand.
.DEFAULT_GOAL := test

# Build Go source files from protocol buffers definitions.
#
# Any files in underscore-prefixed directory names are ignored, as per the Go
# convention of using underscores to exclude files and directories from the
# build.
GENERATED_FILES += $(foreach f,$(PROTO_FILES:.proto=.pb.go),$(if $(findstring /_,/$f),,$f))
GENERATED_FILES += $(foreach f,$(PROTO_GRPC_FILES:.proto=_grpc.pb.go),$(if $(findstring /_,/$f),,$f))

# GO_ARCHIVE_FILES is a space separated list of additional files to include in
# the release archives. The compiled binaries are included by default.
GO_ARCHIVE_FILES +=

# GO_SOURCE_FILES is a space separated list of source files that are used by the
# build process.
GO_SOURCE_FILES += $(shell PATH="$(PATH)" git-find '*.go')

# Disable CGO by default.
# See https://golang.org/cmd/cgo
CGO_ENABLED ?= 0

# GO_APP_VERSION is a human-readable string describing the application version.
# If the "main" package has a variable named "version" it is set to this value
# at link time.
GO_APP_VERSION ?= $(SEMVER)

# GO_DEBUG_ARGS and GO_RELEASE_ARGS are arguments passed to "go build" for the
# "debug" and "release" targets, respectively.
GO_DEBUG_ARGS   ?= -v -ldflags "-X main.version=$(GO_APP_VERSION)"
GO_RELEASE_ARGS ?= -v -ldflags "-X main.version=$(GO_APP_VERSION) -s -w"

# Build matrix configuration.
#
# GO_MATRIX_OS is a whitespace separated set of operating systems.
# GO_MATRIX_ARCH is a whitespace separated set of CPU architectures.
#
# The build-matrix is constructed from all permutations of GO_MATRIX_OS and
# GO_MATRIX_ARCH. The default is to build only for the OS and architecture
# specified by the GOHOSTOS and GOHOSTARCH environment variables, that is the OS
# and architecture of current system.
GOHOSTOS   := $(shell go env GOHOSTOS)
GOHOSTARCH := $(shell go env GOHOSTARCH)
GO_MATRIX_OS   ?= $(GOHOSTOS)
GO_MATRIX_ARCH ?= $(GOHOSTARCH)

# GO_TEST_REQ is a space separated list of prerequisites needed to run tests.
GO_TEST_REQ +=

# GO_BUILD_BEFORE_TEST indicates whether debug binaries should be built before
# running the tests.
#
# If it non-empty, all debug binaries for the current host are added to
# GO_TEST_REQ.
GO_BUILD_BEFORE_TEST ?=

################################################################################

# _GO_COMMAND_DIR and _GO_PLUGIN_DIR are the names of directories in the root of
# the project that contain subdirectories that are "main" packages that are to
# be built into executables and plugins, respectively.
_GO_COMMAND_DIR = cmd
_GO_PLUGIN_DIR = lib

# _GO_COMMAND_PACKAGES and _GO_PLUGIN_PACKAGES are lists of directory names that
# contain "main" packages that are to be built into executables and plugins,
# respectively.
_GO_COMMAND_PACKAGES = $(notdir $(shell find $(_GO_COMMAND_DIR) cmd -type d -mindepth 1 -maxdepth 1 2> /dev/null))
_GO_PLUGIN_PACKAGES = $(notdir $(shell find $(_GO_PLUGIN_DIR) -type d -mindepth 1 -maxdepth 1 2> /dev/null))

# _GO_BUILDMODE_PLUGIN_PATTERNS is a list of patterns that are matched against
# the binary name to determine if we're building a command or a plugin.
_GO_BUILDMODE_PLUGIN_PATTERNS = %.so %.dll

# _GO_BINARIES_xxx is a list of binaries to produce in a build, including both
# executables and plugins.
_GO_BINARIES_NIX = $(_GO_COMMAND_PACKAGES) $(addsuffix .so,$(_GO_PLUGIN_PACKAGES))
_GO_BINARIES_WIN = $(addsuffix .exe,$(_GO_COMMAND_PACKAGES)) $(addsuffix .dll,$(_GO_PLUGIN_PACKAGES))

ifeq ($(GOHOSTOS),windows)
_GO_BINARIES_HOST = $(_GO_BINARIES_WIN)
else
_GO_BINARIES_HOST = $(_GO_BINARIES_NIX)
endif

# _GO_BUILD_PLATFORM_MATRIX_xxx is the cartesian product of all operating
# systems and architectures specified in GO_MATRIX_OS and GO_MATRIX_ARCH.
_GO_BUILD_PLATFORM_MATRIX_ALL  = $(foreach OS,$(GO_MATRIX_OS),$(foreach ARCH,$(GO_MATRIX_ARCH),$(OS)/$(ARCH)))
_GO_BUILD_PLATFORM_MATRIX_NIX  = $(filter-out windows/%,$(_GO_BUILD_PLATFORM_MATRIX_ALL))
_GO_BUILD_PLATFORM_MATRIX_WIN  = $(filter windows/%,$(_GO_BUILD_PLATFORM_MATRIX_ALL))
_GO_BUILD_PLATFORM_MATRIX_HOST = $(GOHOSTOS)/$(GOHOSTARCH)

# _GO_BUILD_MATRIX_xxx is the cartesian product of the platform matrix and the
# filenames of the binaries.
_GO_BUILD_MATRIX_NIX  = $(foreach P,$(_GO_BUILD_PLATFORM_MATRIX_NIX),$(addprefix $(P)/,$(_GO_BINARIES_NIX)))
_GO_BUILD_MATRIX_WIN  = $(foreach P,$(_GO_BUILD_PLATFORM_MATRIX_WIN),$(addprefix $(P)/,$(_GO_BINARIES_WIN)))
_GO_BUILD_MATRIX_HOST = $(foreach P,$(_GO_BUILD_PLATFORM_MATRIX_HOST),$(addprefix $(P)/,$(_GO_BINARIES_HOST)))

# _GO_DEBUG_TARGETS_xxx is the path to the binaries to produce for debug builds.
_GO_DEBUG_TARGETS_ALL    = $(addprefix artifacts/build/debug/,$(_GO_BUILD_MATRIX_NIX) $(_GO_BUILD_MATRIX_WIN))
_GO_DEBUG_TARGETS_HOST   = $(addprefix artifacts/build/debug/,$(_GO_BUILD_MATRIX_HOST))
.SECONDARY: $(_GO_DEBUG_TARGETS_ALL)

# _GO_DEBUG_TARGETS_xxx is the path to the binaries to produce for release builds.
_GO_RELEASE_TARGETS_ALL  = $(addprefix artifacts/build/release/,$(_GO_BUILD_MATRIX_NIX) $(_GO_BUILD_MATRIX_WIN))
_GO_RELEASE_TARGETS_HOST = $(addprefix artifacts/build/release/,$(_GO_BUILD_MATRIX_HOST))
.SECONDARY: $(_GO_RELEASE_TARGETS_HOST)

# Ensure that Linux release binaries are built before attempting to build a Docker image.
DOCKER_BUILD_REQ += $(addprefix artifacts/build/release/linux/amd64/,$(_GO_BINARIES_NIX))

ifneq ($(GO_BUILD_BEFORE_TEST),)
GO_TEST_REQ += $(_GO_DEBUG_TARGETS_HOST)
endif

################################################################################

# Treat any dependencies of the tests as secondary build targets so that they
# are not deleted after a successful test.
.SECONDARY: $(GO_TEST_REQ)

# test --- Executes all go tests in this module.
.PHONY: test
test:: $(GENERATED_FILES) $(GO_TEST_REQ)
	go test ./...

# coverage --- Produces an HTML coverage report.
.PHONY: coverage
coverage:: artifacts/coverage/index.html

# coverage-open --- Opens the HTML coverage report in a browser.
.PHONY: coverage-open
coverage-open:: artifacts/coverage/index.html
	open "$<"

# precommit --- Perform tasks that need to be executed before committing. Stacks
# with the "precommit" target form the common makefile.
.PHONY: precommit
precommit:: test artifacts/go/bin/go.mod
	go fmt ./...
	go mod tidy
	artifacts/go/bin/golangci-lint run --config artifacts/go/bin/.golangci.yml ./...

# ci --- Builds a machine-readable coverage report. Stacks with the "ci" target
# from the common makefile.
.PHONY: ci
ci:: artifacts/coverage/cover.out artifacts/go/bin/go.mod
	artifacts/go/bin/golangci-lint run --config artifacts/go/bin/.golangci.yml ./...

# _clean --- Clears the Go test cache. Invoked by the "clean" target from the
# common makefile before the makefiles themselves are removed.
.PHONY: _clean
_clean::
	go clean -testcache

# build --- Builds debug binaries suitable for execution on this machine. It
# does not require the current OS and architecture to appear in the build
# matrix.
.PHONY: build
build: $(_GO_DEBUG_TARGETS_HOST)

# debug --- Builds debug binaries files for all platforms specified in the build
# matrix.
.PHONY: debug
debug: $(_GO_DEBUG_TARGETS_ALL)

# release --- Builds release binaries files for all platforms specified in the
# build matrix.
.PHONY: release
release: $(_GO_RELEASE_TARGETS_ALL)

# archives --- Builds zip archives containing the release binaries and an
# additional files specified in GO_ARCHIVE_FILES.
archives: $(addprefix artifacts/archives/$(PROJECT_NAME)-$(GO_APP_VERSION)-,$(addsuffix .zip,$(subst /,-,$(_GO_BUILD_PLATFORM_MATRIX_ALL))))

################################################################################

artifacts/coverage/index.html: artifacts/coverage/cover.out
	go tool cover -html="$<" -o "$@"

.PHONY: artifacts/coverage/cover.out # always rebuild
artifacts/coverage/cover.out: $(GENERATED_FILES) $(GO_TEST_REQ)
	@mkdir -p $(@D)
	go test -covermode=count -coverprofile=$@ ./...
ifneq ($(strip $(GENERATED_FILES)),)
	grep --fixed-strings --invert-match $(foreach F,$(GENERATED_FILES),--regexp="$F") "$@" > "$@.tmp"
	mv "$@.tmp" "$@"
endif

artifacts/build/%: $(GO_SOURCE_FILES) $(GENERATED_FILES)
	$(eval PARTS := $(subst /, ,$*))
	$(eval BUILD := $(word 1,$(PARTS)))
	$(eval OS    := $(word 2,$(PARTS)))
	$(eval ARCH  := $(patsubst arm%,arm,$(word 3,$(PARTS))))
	$(eval GOARM := $(patsubst arm%,%,$(filter arm%,$(word 3,$(PARTS)))))
	$(eval BIN   := $(word 4,$(PARTS)))
	$(eval MODE  := $(if $(filter $(_GO_BUILDMODE_PLUGIN_PATTERNS),$(BIN)),plugin,default))
	$(eval PKG   := $(if $(findstring plugin,$(MODE)),$(_GO_PLUGIN_DIR),$(_GO_COMMAND_DIR))/$(basename $(BIN)))
	$(eval ARGS  := $(if $(findstring debug,$(BUILD)),$(GO_DEBUG_ARGS),-trimpath $(GO_RELEASE_ARGS)))

	CGO_ENABLED=$(CGO_ENABLED) GOOS="$(OS)" GOARCH="$(ARCH)" GOARM="$(GOARM)" go build -tags=$(BUILD) -buildmode=$(MODE) $(ARGS) -o "$@" "./$(PKG)"

artifacts/archives/$(PROJECT_NAME)-$(GO_APP_VERSION)-windows-%.zip: $(GO_ARCHIVE_FILES) $$(addprefix artifacts/build/release/windows/$$*/,$(_GO_BINARIES_WIN))
	@mkdir -p "$(@D)"
	@rm -f "$@"
	zip --recurse-paths --junk-paths "$@" -- $^

artifacts/archives/$(PROJECT_NAME)-$(GO_APP_VERSION)-%.zip: $(GO_ARCHIVE_FILES) $$(addprefix artifacts/build/release/$$(subst -,/,$$*)/,$(_GO_BINARIES_NIX))
	@mkdir -p "$(@D)"
	@rm -f "$@"
	zip --recurse-paths --junk-paths "$@" -- $^

artifacts/go/bin/go.mod:
	$(MF_ROOT)/pkg/go/v1/bin/install-golangci-lint "$(MF_PROJECT_ROOT)/$(@D)"
	cp -f $(MF_ROOT)/pkg/go/v1/bin/.golangci.yml "$(MF_PROJECT_ROOT)/$(@D)"
