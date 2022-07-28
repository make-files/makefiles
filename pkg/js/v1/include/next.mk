# JS_NEXT_PORT is the port number that the Next.js application should listen on.
JS_NEXT_PORT ?= 3000

# JS_NEXT_REQ is a space separated list of prerequisites needed to run Next.js.
JS_NEXT_REQ +=

################################################################################

# _JS_NEXT_REQ is a space separated list of automatically detected prerequisites
# needed to run Next.js.
_JS_NEXT_REQ += artifacts/link-dependencies.touch $(JS_NEXT_CONFIG_FILE) $(JS_SOURCE_FILES) $(GENERATED_FILES)

################################################################################

# next-build --- Compile the Next.js application for production deployment.
.PHONY: next-build
next-build: artifacts/next/dist/BUILD_ID

# next-dev --- Start the Next.js application in development mode.
.PHONY: next-dev
next-dev: artifacts/link-dependencies.touch
	$(JS_EXEC) next dev --port $(JS_NEXT_PORT)

################################################################################

artifacts/next/dist/BUILD_ID: $(JS_NEXT_REQ) $(_JS_NEXT_REQ)
	@rm -rf "$@"
	$(JS_EXEC) next build
