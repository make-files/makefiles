# PRETTIER_CONFIG_FILE is the path to any existing Prettier configuration file.
PRETTIER_CONFIG_FILE ?= $(shell PATH="$(PATH)" find-first-matching-file .prettierrc .prettierrc.* prettier.config.*)

# PRETTIER_REQ is a space separated list of prerequisites needed to run
# Prettier.
PRETTIER_REQ +=

################################################################################

# If PRETTIER_CONFIG_FILE is not set, default to .prettierrc.json
ifeq ($(PRETTIER_CONFIG_FILE),)
PRETTIER_CONFIG_FILE := .prettierrc.json
endif

# _PRETTIER_REQ is a space separated list of automatically detected
# prerequisites needed to run Prettier.
_PRETTIER_REQ += $(PRETTIER_CONFIG_FILE)

# _PRETTIER_ARGS is a space separated list of arguments to pass to Prettier.
_PRETTIER_ARGS := --config "$(PRETTIER_CONFIG_FILE)"

################################################################################

# Add fix mode to lint target
.PHONY: lint
lint:: prettier

# Add fix mode to precommit target
.PHONY: precommit
precommit:: prettier

# Add check mode to ci target
.PHONY: ci
ci:: prettier-check

################################################################################

# prettier --- Automatically fix code style and formatting issues.
.PHONY: prettier
prettier: $(PRETTIER_REQ) $(_PRETTIER_REQ)
	prettier $(_PRETTIER_ARGS) --write "$(MF_PROJECT_ROOT)"

# prettier-check --- Check for code style and formatting issues.
.PHONY: prettier-check
prettier-check: $(PRETTIER_REQ) $(_PRETTIER_REQ)
	prettier $(_PRETTIER_ARGS) --check "$(MF_PROJECT_ROOT)"

################################################################################

.prettierrc.json:
	echo '{}' > "$@"
