# JS_TYPEDOC_REQ is a space separated list of prerequisites needed to run
# TypeDoc.
JS_TYPEDOC_REQ +=

################################################################################

# _JS_TYPEDOC_REQ is a space separated list of automatically detected
# prerequisites needed to run TypeDoc.
_JS_TYPEDOC_REQ += artifacts/link-dependencies.touch

################################################################################

# typedoc --- Generate TypeDoc documentation.
.PHONY: typedoc
typedoc: artifacts/docs/typedoc

# typedoc-open --- Open TypeDoc documentation.
.PHONY: typedoc-open
typedoc-open: artifacts/docs/typedoc
	$(MF_BROWSER) "$<"

################################################################################

artifacts/docs/typedoc: $(JS_TYPEDOC_REQ) $(_JS_TYPEDOC_REQ)
	$(JS_EXEC) typedoc \
		--cleanOutputDir \
		--out "$@" \
		--options "$(JS_TYPEDOC_CONFIG_FILE)"
