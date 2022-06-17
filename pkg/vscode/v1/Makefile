# GENERATE_VSCODE_SETTINGS can be set to false so that the user can opt
# out of generating the VSCode settings file.
GENERATE_VSCODE_SETTINGS ?= true

# _VSCODE_SETTINGS_FILE is the VSCode workspace settings file that contains
# workspace-specific settings that override user-defined settings and their
# defaults.
# More about VSCODE workspace settings can be found at:
# https://code.visualstudio.com/docs/getstarted/settings#_workspace-settings
_VSCODE_SETTINGS_FILE = $(MF_PROJECT_ROOT)/.vscode/settings.json

ifeq ($(GENERATE_VSCODE_SETTINGS),true)
GENERATED_FILES += $(_VSCODE_SETTINGS_FILE)
endif

# VSCODE_SETTINGS_REQ is a space separated list of prerequisites requred to
# generate the VSCode workspace settings file.
VSCODE_SETTINGS_REQ ?=

ifneq ($(filter proto,$(MF_LANGUAGES)),)
VSCODE_SETTINGS_REQ += $(MF_PROJECT_ROOT)/artifacts/protobuf/args/common

ifneq ($(filter go,$(MF_LANGUAGES)),)
VSCODE_SETTINGS_REQ += $(MF_PROJECT_ROOT)/artifacts/protobuf/args/go
endif

endif

RUN_PROTOC_SCRIPT = $(MF_PROJECT_ROOT)/artifacts/protobuf/bin/run-protoc

$(_VSCODE_SETTINGS_FILE): $(VSCODE_SETTINGS_REQ)
	$(MF_ROOT)/pkg/vscode/v1/bin/generate-base-file "$@"
ifneq ($(filter proto,$(MF_LANGUAGES)),)
	$(MF_ROOT)/pkg/vscode/v1/bin/merge-vscode-proto3-settings "$@" "$(RUN_PROTOC_SCRIPT)" $^
endif
