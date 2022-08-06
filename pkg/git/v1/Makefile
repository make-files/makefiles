
# TAG_EDITOR_CMD is the path to the tag-editor command.
TAG_EDITOR_CMD := $(MF_ROOT)/pkg/git/v1/tag-editor

# TAG_VERSION_CMD is the path to the tag-version command.
TAG_VERSION_CMD := $(MF_ROOT)/pkg/git/v1/tag-version

# v is the tag version number. If supplied as a command line argument,
# the editor will be skipped and the tag will be created with the existing
# contents of the [unreleased] header in the CHANGELOG.md file.
v ?= false

################################################################################

.PHONY: tag
tag:
ifeq ($(v), false)
	$(TAG_EDITOR_CMD)
else
	$(TAG_VERSION_CMD) $(v)
endif

################################################################################
