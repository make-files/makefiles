# CHANGELOG_TAG_PREFIX is the prefix added to the version number to form the
# name of the tag created by "make tag". Set it to an empty string to use the
# bare version number.
CHANGELOG_TAG_PREFIX ?= v

# _CHANGELOG_GITHUB_URL is the URL of the repository if it is hosted on GitHub,
# otherwise it is empty.
#
# It is defined with "=" (not ":="), so the $(shell) call is not run when the
# Makefile is parsed. Instead, it runs each time the variable is expanded. The
# variables below that default to it are defined with "?=", which also defers
# expansion, and they are only expanded by the "tag" and "CHANGELOG.md" recipes.
# This means git is only queried when one of those targets is built.
_CHANGELOG_GITHUB_URL = $(if $(findstring github.com,$(shell git config --get remote.origin.url)),https://github.com/$(GIT_SLUG))

# CHANGELOG_TAG_URL_PREFIX is the prefix of the URL used for each version's
# link reference in CHANGELOG.md. The tag name is appended to it. If the
# repository is hosted on GitHub, it defaults to the URL of the GitHub release.
# If it is empty, "make tag" fails.
CHANGELOG_TAG_URL_PREFIX ?= $(if $(_CHANGELOG_GITHUB_URL),$(_CHANGELOG_GITHUB_URL)/releases/tag/)

# CHANGELOG_UNRELEASED_URL is the URL used for the [Unreleased] link reference
# when CHANGELOG.md is generated. If the repository is hosted on GitHub, it
# defaults to the repository's URL. If it is empty, the link reference is
# omitted.
CHANGELOG_UNRELEASED_URL ?= $(_CHANGELOG_GITHUB_URL)

# CHANGELOG_VERSION is the version to release when running "make tag". When it
# is set, the [Unreleased] section of CHANGELOG.md is used as-is and no editor
# is opened, allowing "make tag" to run non-interactively.
CHANGELOG_VERSION ?=

################################################################################

# Move the [Unreleased] section of CHANGELOG.md under a new version heading,
# commit it, then create an annotated tag for the release. It does not push.
.PHONY: tag
tag: CHANGELOG.md
	CHANGELOG_TAG_PREFIX="$(CHANGELOG_TAG_PREFIX)" \
	CHANGELOG_TAG_URL_PREFIX="$(CHANGELOG_TAG_URL_PREFIX)" \
	CHANGELOG_VERSION="$(CHANGELOG_VERSION)" \
		$(MF_ROOT)/pkg/changelog/v2/bin/tag

################################################################################

# Create CHANGELOG.md if it does not exist.
CHANGELOG.md:
	$(MF_ROOT)/pkg/changelog/v2/bin/generate-changelog "$@" "$(CHANGELOG_UNRELEASED_URL)"
