# CHANGELOG_TAG_URL_PREFIX is the prefix to the URL that is appended to your CHANGELOG.md release.
ifndef CHANGELOG_TAG_URL_PREFIX
$(error "CHANGELOG_TAG_URL_PREFIX must be defined in the project's Makefile.")
endif

# _CHANGELOG_TAG_EDITOR_CMD is the path to the tag-editor command.
_CHANGELOG_TAG_EDITOR_CMD := $(MF_ROOT)/pkg/changelog/v1/bin/tag-editor

################################################################################

.PHONY: tag
tag: CHANGELOG.md
	GIT_HEAD_SEMVER=$(GIT_HEAD_SEMVER) \
	CHANGELOG_TAG_URL_PREFIX=$(CHANGELOG_TAG_URL_PREFIX) \
		$(_CHANGELOG_TAG_EDITOR_CMD)

################################################################################

#Create CHANGELOG.md from template if it does not exist.
CHANGELOG.md:
	cp $(MF_ROOT)/pkg/changelog/v1/CHANGELOG.md $@
