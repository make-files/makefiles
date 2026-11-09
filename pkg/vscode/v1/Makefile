# GENERATE_VSCODE_SETTINGS can be set to false so that the user can opt
# out of generating the VSCode settings file.
GENERATE_VSCODE_SETTINGS ?= true

# _VSCODE_SETTINGS_FILE is the VSCode workspace settings file that contains
# workspace-specific settings that override user-defined settings and their
# defaults.
# More about VSCODE workspace settings can be found at:
# https://code.visualstudio.com/docs/getstarted/settings#_workspace-settings
_VSCODE_SETTINGS_FILE = .vscode/settings.json

ifeq ($(GENERATE_VSCODE_SETTINGS),true)
GENERATED_FILES += $(_VSCODE_SETTINGS_FILE)
endif

# VSCODE_SETTINGS_REQ is a space separated list of prerequisites requred to
# generate the VSCode workspace settings file.
VSCODE_SETTINGS_REQ ?=

# VSCODE_SETTINGS_FILES is a space separated list of JSON files that contain
# settings to merge into the VSCode workspace settings file. Settings in later
# files take precedence. Other packages add to this list, for example to
# configure the editor to use the tools they run.
VSCODE_SETTINGS_FILES +=

$(_VSCODE_SETTINGS_FILE): $(VSCODE_SETTINGS_REQ) $$(VSCODE_SETTINGS_FILES)
	$(MF_ROOT)/pkg/vscode/v1/bin/generate-base-file "$@"
	$(if $(VSCODE_SETTINGS_FILES),$(MF_ROOT)/pkg/vscode/v1/bin/merge-settings "$@" $(VSCODE_SETTINGS_FILES))
