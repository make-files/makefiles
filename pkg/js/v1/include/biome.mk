# JS_BIOME_REQ is a space separated list of prerequisites needed to run Biome.
JS_BIOME_REQ +=

################################################################################

# _JS_BIOME_REQ is a space separated list of automatically detected
# prerequisites needed to run Biome.
_JS_BIOME_REQ += artifacts/link-dependencies.touch

# _JS_BIOME_ARGS is a space separated list of arguments to pass to Biome.
_JS_BIOME_ARGS := --config-path "$(JS_BIOME_CONFIG_FILE)"

# Merge Biome's editor settings into the VSCode workspace settings file, if
# the project uses the vscode package.
VSCODE_SETTINGS_MERGE_FILES += $(MF_ROOT)/pkg/js/v1/etc/vscode-settings.biome.json

################################################################################

# lint --- Check for syntax, configuration, code style and/or formatting issues.
.PHONY: lint
lint:: biome

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: biome

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: biome-check

################################################################################

# biome --- Check for code style, formatting and lint issues using Biome,
#           fixing automatically where it is safe to do so.
.PHONY: biome
biome: $(JS_BIOME_REQ) $(_JS_BIOME_REQ)
	$(JS_EXEC) biome check $(_JS_BIOME_ARGS) --write "$(MF_PROJECT_ROOT)"

# biome-check --- Same as the biome target, but issues that could automatically
#                 be fixed will instead cause this target to fail.
.PHONY: biome-check
biome-check: $(JS_BIOME_REQ) $(_JS_BIOME_REQ)
	$(JS_EXEC) biome ci $(_JS_BIOME_ARGS) "$(MF_PROJECT_ROOT)"
