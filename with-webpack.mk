# JS_WEBPACK_REQ is a space separated list of prerequisites needed to run
# Webpack.
JS_WEBPACK_REQ +=

################################################################################

# _JS_WEBPACK_REQ is a space separated list of automatically detected
# prerequisites needed to run Webpack.
_JS_WEBPACK_REQ += node_modules $(JS_WEBPACK_CONFIG_FILE) $(JS_SOURCE_FILES) $(_JS_REQ)

################################################################################

# webpack --- Run Webpack in "production" mode.
.PHONY: webpack
webpack: artifacts/webpack/build/production

# webpack-development --- Run Webpack in "development" mode.
.PHONY: webpack-development
webpack-development: artifacts/webpack/build/development

# webpack-analyze --- Analyze the Webpack bundle, and produce an HTML report.
.PHONY: webpack-analyze
webpack-analyze: artifacts/webpack/analyze/production.html

# webpack-analyze-open --- Opens the Webpack bundle analysis report in a
#                          browser.
.PHONY: webpack-analyze-open
webpack-analyze-open: artifacts/webpack/analyze/production.html
	open "$<"

################################################################################

artifacts/webpack/build/development: $(JS_WEBPACK_REQ) $(_JS_WEBPACK_REQ)
	rm -rf "$@"
	node_modules/.bin/webpack --mode development

artifacts/webpack/build/production: $(JS_WEBPACK_REQ) $(_JS_WEBPACK_REQ)
	rm -rf "$@"
	NODE_ENV=production node_modules/.bin/webpack --mode production

artifacts/webpack/build/production/.stats.json: $(JS_WEBPACK_REQ) $(_JS_WEBPACK_REQ)
	@mkdir -p "$(@D)"
	rm -f "$@"
	NODE_ENV=production node_modules/.bin/webpack --mode production --json > "$@"

artifacts/webpack/analyze/production.html: artifacts/webpack/build/production/.stats.json
	$(eval _WEBPACK_BUNDLE_ANALYZER  := $(if $(wildcard node_modules/.bin/webpack-bundle-analyzer),node_modules/.bin/webpack-bundle-analyzer,npx webpack-bundle-analyzer))
	$(_WEBPACK_BUNDLE_ANALYZER) --mode static --no-open --report "$@" "$<" artifacts/webpack/build/production
