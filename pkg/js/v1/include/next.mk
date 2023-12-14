# JS_NEXT_PORT is the port number that the Next.js application should listen on.
JS_NEXT_PORT ?= 3000

# JS_NEXT_REQ is a space separated list of prerequisites needed to run Next.js.
JS_NEXT_REQ +=

################################################################################

# _JS_NEXT_REQ is a space separated list of automatically detected prerequisites
# needed to run Next.js.
_JS_NEXT_REQ += artifacts/link-dependencies.touch $(JS_NEXT_CONFIG_FILE) $(JS_SOURCE_FILES) $(GENERATED_FILES)

################################################################################

# next-analyze --- Analyze the Next.js application client bundle.
.PHONY: next-analyze
next-analyze: artifacts/next/dist/analyze/client.html

# next-analyze-open --- Analyze the Next.js application client bundle, and open
#                       the results in a browser.
.PHONY: next-analyze-open
next-analyze-open: artifacts/next/dist/analyze/client.html
	$(MF_BROWSER) "$<"

# next-build --- Compile the Next.js application for production deployment.
.PHONY: next-build
next-build: artifacts/next/dist/BUILD_ID

# next-dev --- Start the Next.js application in development mode.
.PHONY: next-dev
next-dev: artifacts/link-dependencies.touch
	NODE_ENV=development $(JS_EXEC) next dev --port $(JS_NEXT_PORT)

################################################################################

artifacts/next/dist/BUILD_ID: $(JS_NEXT_REQ) $(_JS_NEXT_REQ)
	@rm -rf "$@"
	$(JS_EXEC) next build

artifacts/next/dist/analyze/client.html: $(JS_NEXT_REQ) $(_JS_NEXT_REQ)
	ANALYZE=true $(JS_EXEC) next build
