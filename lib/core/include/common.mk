# Remove "Old-Fashioned Suffix Rules".
# See https://www.gnu.org/software/make/manual/html_node/Suffix-Rules.html
.SUFFIXES:

# Remove all "built-in" rules.
# See https://www.gnu.org/software/make/manual/html_node/Catalogue-of-Rules.html
MAKEFLAGS += --no-builtin-rules

export MF_PROJECT_ROOT := $(realpath $(dir $(word 1,$(MAKEFILE_LIST))))
export MF_ROOT := $(MF_PROJECT_ROOT)/.makefiles
export PATH := $(MF_ROOT)/lib/core/bin:$(PATH)

# MF_OS is the name of the operating system.
# MF_BROWSER is the command to run to open the default browser.
_UNAME_S = $(shell uname -s)
ifeq ($(_UNAME_S),Darwin)
export MF_OS = macos
export MF_BROWSER = open
else ifeq ($(_UNAME_S),Linux)
export MF_OS = linux
export MF_BROWSER = xdg-open
else
export MF_OS = unknown
export MF_BROWSER = echo Open in browser:
endif

# MF_CI is the name of any detected continuous integration system. If no CI
# system is detected, MF_CI will be empty.
export MF_CI ?= $(shell PATH="$(PATH)" ci-system-name)

# MF_NON_INTERACTIVE will be non-empty when make is not running under an
# interactive shell.
ifeq ($(MF_CI),)
export MF_NON_INTERACTIVE ?= $(shell [ -t 0 ] || echo true)
else
export MF_NON_INTERACTIVE ?= true
endif

# Run tests by default unless the project's main Makefile has already defined a
# default goal.
ifeq ($(.DEFAULT_GOAL),)
.DEFAULT_GOAL := test
endif

.SECONDEXPANSION:

# PROJECT_NAME is a short name for the project. It defaults to the name of the
# directory that the project is in.
PROJECT_NAME ?= $(notdir $(MF_PROJECT_ROOT))

# GENERATED_FILES is a space separated list of files that are generated by
# the Makefile and are intended to be committed to the repository.
GENERATED_FILES +=

# CI_VERIFY_GENERATED_FILES, if non-empty, causes the "ci" target to check that
# the files in GENERATED_FILES are up-to-date.
CI_VERIFY_GENERATED_FILES ?=

# _CI_VERIFY_GENERATED_FILES_ALWAYS is a subset of GENERATED_FILES that should
# always be verified by the "ci" target, even if CI_VERIFY_GENERATED_FILES is
# empty.
_CI_VERIFY_GENERATED_FILES_ALWAYS +=

# CLEAN_EXCLUSIONS is a space separated list of gitignore patterns to exclude
# from being removed by "make clean".
CLEAN_EXCLUSIONS +=

# GIT_HEAD_HASH_FULL is the full-length hash of the HEAD commit.
#
# GIT_HEAD_HASH is the abbreviated hash of the HEAD commit. The exact length may
# vary based on Git configuration and repo size.
#
# GIT_HEAD_BRANCH is the name of the current branch. It is empty if the HEAD is
# detached (that is, no specific branch is checked out).
#
# GIT_HEAD_TAG is the name of the current tag. It is empty if the HEAD is not
# detached, or if the HEAD is not a tag (either annotated, or un-annotated). If
# the HEAD commit is referred to by multiple tags there is no guarantee which
# tag name will be used.
#
# GIT_HEAD_COMMITTISH is the "best" representation of the HEAD commit. If HEAD
# is a branch or tag, this will be the branch or tag name. Otherwise it will be
# the commit hash.
#
# GIT_HEAD_SEMVER is a semver representation of the HEAD commit. If GIT_HEAD_TAG
# is a valid semver version (with an optional leading 'v') then GIT_HEAD_SEMVER
# is that semver version (with the leading 'v' stripped, if present). Otherwise,
# GIT_HEAD_SEMVER is a pre-release version formed from the commit hash, such as
# "0.0.0-167aea9".
#
# GIT_HEAD_SEMVER_MAJOR is the major version component of GIT_HEAD_SEMVER.
# GIT_HEAD_SEMVER_MINOR is the minor version component of GIT_HEAD_SEMVER.
# GIT_HEAD_SEMVER_PATCH is the patch version component of GIT_HEAD_SEMVER.
# GIT_HEAD_SEMVER_PRERELEASE is the pre-release component of GIT_HEAD_SEMVER.
# GIT_HEAD_SEMVER_METADATA is the build meta-data component of GIT_HEAD_SEMVER.
# GIT_HEAD_SEMVER_IS_FROM_TAG is "true" if GIT_HEAD_SEMVER is identical to GIT_HEAD_TAG.
# GIT_HEAD_SEMVER_IS_STABLE is "true" if GIT_HEAD_SEMVER is a stable version.
$(shell PATH="$(PATH)" generate-git-include > "$(MF_ROOT)/lib/core/include/git.mk")
include $(MF_ROOT)/lib/core/include/git.mk

# SEMVER_DEV_BUILD is the semantic version "build" component to use in dev
# versions.
SEMVER_DEV_BUILD ?= $(GIT_HEAD_HASH)

# SEMVER is the semantic version as defined by https://semver.org/.
ifeq ($(GIT_HEAD_SEMVER_IS_FROM_TAG),true)
SEMVER ?= $(GIT_HEAD_SEMVER)
else
SEMVER ?= 0.0.0+$(SEMVER_DEV_BUILD)
endif

# Include any Makefiles that are provided by the currently installed libraries.
include $(MF_ROOT)/lib/core/include/lib.mk

# makefiles --- Installs makefiles.dev. Useful to run before make -j in order to
# avoid concurrency issues while installing.
.PHONY: makefiles
makefiles:
	@echo Powered by https://makefiles.dev/

# clean --- Removes all generated and ignored files. Individual language
# Makefiles should also remove any build artifacts that aren't already ignored
# by defining a _clean target.
#
# The use of recursive make ensures that clean-ignored is done after everything
# else, as this will remove the makefiles themselves.
.PHONY: clean _clean
_clean::
clean:
	@$(MAKE) --no-print-directory _clean
	@$(MAKE) --no-print-directory clean-generated
	@$(MAKE) --no-print-directory clean-ignored

# clean-generated --- Removes all files in the GENERATED_FILES list.
.PHONY: clean-generated
clean-generated::
	rm -f -- $(GENERATED_FILES)

# clean-ignored --- Removes all files ignored by .gitignore files within the
# repository. It does not remove any files that are ignored due to rules in
# global ignore configurations.
.PHONY: clean-ignored
clean-ignored::
	$(eval _EXCLUSION_ARGS := $(foreach EXCLUSION,$(CLEAN_EXCLUSIONS),--exclude "!$(EXCLUSION)"))
	git -c core.excludesfile= clean -dX --force $(_EXCLUSION_ARGS)

# generate --- Builds any out-of-date files in the GENERATED_FILES list.
.PHONY: generate
generate:: $$(GENERATED_FILES)

# regenerate --- Removes and regenerates all files in the GENERATED_FILES list.
.PHONY: regenerate
regenerate::
	@$(MAKE) --no-print-directory clean-generated
	@$(MAKE) --no-print-directory generate

# try-regenerate --- Removes and regenerates all files in the GENERATED_FILES
# list, but restores them if the generation fails.
.PHONY: try-regenerate
try-regenerate::
	@$(MAKE) --no-print-directory regenerate || (echo 'Regenerate failed, restoring files...'; git restore $(shell git ls-files $(GENERATED_FILES)))

# verify-generated --- Removes and regenerates all files in the GENERATED_FILES
# list and checks for differences to the committed files. The target fails if
# differences are detected.
.PHONY: verify-generated
verify-generated:
	@PATH="$(PATH)" verify-generated-files $(GENERATED_FILES)

# test --- Executes all tests.
# Individual language Makefiles are expected to add additional recipies for this
# target.
.PHONY: test
test::

# benchmark --- Execute all benchmarks.
# Individual language Makefiles are expected to add additional recipies for this
# target.
.PHONY: test
benchmark::

# lint --- Check for syntax, configuration, code style and/or formatting issues.
# Individual language Makefiles are expected to add additional recipies for this
# target.
.PHONY: lint
lint::

# precommit --- Perform tasks that need to be executed before committing.
# Individual language Makefiles are expected to add additional recipies for this
# target.
.PHONY: precommit
precommit:: $$(GENERATED_FILES)

# ci --- Perform tasks that need to be executed within a continuous integration
# environment. Individual language Makefiles are expected to add additional
# recipies for this target.
.PHONY: ci
ci::
ifneq ($(CI_VERIFY_GENERATED_FILES),)
	@PATH="$(PATH)" verify-generated-files $(GENERATED_FILES)
else
	@PATH="$(PATH)" verify-generated-files $(_CI_VERIFY_GENERATED_FILES_ALWAYS)
endif
