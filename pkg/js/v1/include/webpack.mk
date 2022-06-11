# JS_WEBPACK_BUILD_NAME can be changed in order to support parameterized builds.
# The name should be safe to use in a path, and represent all of the build
# parameters that can change the Webpack output.
JS_WEBPACK_BUILD_NAME ?=

# JS_WEBPACK_REQ is a space separated list of prerequisites needed to run
# Webpack.
JS_WEBPACK_REQ +=

################################################################################

# _JS_WEBPACK_BUILD_PATH_SEGMENT is an additional path segment to use in all
# Webpack-build-related targets to support parameterized builds.
ifeq ($(JS_WEBPACK_BUILD_NAME),)
_JS_WEBPACK_BUILD_PATH_SEGMENT=
else
_JS_WEBPACK_BUILD_PATH_SEGMENT=/named/$(JS_WEBPACK_BUILD_NAME)
endif

# _JS_WEBPACK_REQ is a space separated list of automatically detected
# prerequisites needed to run Webpack.
_JS_WEBPACK_REQ += artifacts/link-dependencies.touch $(JS_WEBPACK_CONFIG_FILE) $(JS_SOURCE_FILES) $(GENERATED_FILES)

################################################################################

# webpack --- Run Webpack in "production" mode.
.PHONY: webpack
webpack: artifacts/webpack/build$(_JS_WEBPACK_BUILD_PATH_SEGMENT)/production

# webpack-development --- Run Webpack in "development" mode.
.PHONY: webpack-development
webpack-development: artifacts/webpack/build$(_JS_WEBPACK_BUILD_PATH_SEGMENT)/development

# webpack-analyze --- Analyze the Webpack bundle, and produce an HTML report.
.PHONY: webpack-analyze
webpack-analyze: artifacts/webpack/analyze$(_JS_WEBPACK_BUILD_PATH_SEGMENT)/production.html

# webpack-analyze-open --- Opens the Webpack bundle analysis report in a
#                          browser.
.PHONY: webpack-analyze-open
webpack-analyze-open: artifacts/webpack/analyze$(_JS_WEBPACK_BUILD_PATH_SEGMENT)/production.html
	open "$<"

################################################################################

artifacts/webpack/build$(_JS_WEBPACK_BUILD_PATH_SEGMENT)/development: $(JS_WEBPACK_REQ) $(_JS_WEBPACK_REQ)
	@rm -rf "$@"
	$(call _js_node_exec,webpack) --mode development

artifacts/webpack/build$(_JS_WEBPACK_BUILD_PATH_SEGMENT)/production: $(JS_WEBPACK_REQ) $(_JS_WEBPACK_REQ)
	@rm -rf "$@"
	NODE_ENV=production $(call _js_node_exec,webpack) --mode production

artifacts/webpack/build$(_JS_WEBPACK_BUILD_PATH_SEGMENT)/production/.stats.json: $(JS_WEBPACK_REQ) $(_JS_WEBPACK_REQ)
	@mkdir -p "$(@D)"
	@rm -f "$@"
	NODE_ENV=production $(call _js_node_exec,webpack) --mode production --json > "$@"

artifacts/webpack/analyze$(_JS_WEBPACK_BUILD_PATH_SEGMENT)/production.html: artifacts/webpack/build$(_JS_WEBPACK_BUILD_PATH_SEGMENT)/production/.stats.json
	$(eval _WEBPACK_BUNDLE_ANALYZER  := $(if $(wildcard $(call _js_node_exec,webpack)-bundle-analyzer),$(call _js_node_exec,webpack)-bundle-analyzer,npx webpack-bundle-analyzer))
	$(_WEBPACK_BUNDLE_ANALYZER) --mode static --no-open --report "$@" "$<" artifacts/webpack/build$(_JS_WEBPACK_BUILD_PATH_SEGMENT)/production
