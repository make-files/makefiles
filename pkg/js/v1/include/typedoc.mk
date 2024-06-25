# JS_TYPEDOC_REQ is a space separated list of prerequisites needed to run
# TypeDoc.
JS_TYPEDOC_REQ +=

################################################################################

# _JS_TYPEDOC_REQ is a space separated list of automatically detected
# prerequisites needed to run TypeDoc.
_JS_TYPEDOC_REQ += artifacts/link-dependencies.touch $(JS_TYPEDOC_CONFIG_FILE) $(JS_SOURCE_FILES) $(GENERATED_FILES)

################################################################################

# lint --- Check for syntax, configuration, code style and/or formatting issues.
.PHONY: lint
lint:: typedoc-check

# precommit --- Perform tasks that need to be executed before committing.
.PHONY: precommit
precommit:: typedoc-check

# ci --- Perform tasks that should be run as part of continuous integration.
.PHONY: ci
ci:: typedoc-check

################################################################################

# typedoc --- Generate TypeDoc documentation.
.PHONY: typedoc
typedoc: artifacts/docs/typedoc

# typedoc-open --- Open TypeDoc documentation.
.PHONY: typedoc-open
typedoc-open: artifacts/docs/typedoc
	$(MF_BROWSER) "$(<)/index.html"

# typedoc-check --- Check for TypeDoc documentation issues.
.PHONY: typedoc-check
typedoc-check: $(JS_TYPEDOC_REQ) $(_JS_TYPEDOC_REQ)
	$(JS_EXEC) typedoc \
		--options "$(JS_TYPEDOC_CONFIG_FILE)" \
		--emit none \
		--treatWarningsAsErrors

################################################################################

artifacts/docs/typedoc: $(JS_TYPEDOC_REQ) $(_JS_TYPEDOC_REQ)
	$(JS_EXEC) typedoc \
		--cleanOutputDir \
		--out "$@" \
		--options "$(JS_TYPEDOC_CONFIG_FILE)"
