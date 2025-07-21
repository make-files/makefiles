# JS_VITE_PORT is the port number that the Vite application should listen on.
JS_VITE_PORT ?= 3000

# JS_VITE_REQ is a space separated list of prerequisites needed to run Vite.
JS_VITE_REQ +=

################################################################################

# _JS_VITE_REQ is a space separated list of automatically detected prerequisites
# needed to run Vite.
_JS_VITE_REQ += artifacts/link-dependencies.touch $(JS_VITE_CONFIG_FILE) $(JS_SOURCE_FILES) $(GENERATED_FILES)

################################################################################

# vite-build --- Compile the Vite application for production deployment.
.PHONY: vite-build
vite-build: artifacts/vite/dist/index.html

# vite-dev --- Start the Vite application in development mode.
.PHONY: vite-dev
vite-dev: artifacts/link-dependencies.touch
	NODE_ENV=development $(JS_EXEC) vite dev --port $(JS_VITE_PORT)

# vite-preview --- Preview the production build of the Vite application.
.PHONY: vite-preview
vite-preview: artifacts/vite/dist/index.html
	$(JS_EXEC) vite preview --port $(JS_VITE_PORT)

################################################################################

artifacts/vite/dist/index.html: $(JS_VITE_REQ) $(_JS_VITE_REQ)
	@rm -rf "$@"
	$(JS_EXEC) vite build
