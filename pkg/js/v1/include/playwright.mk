ifndef _JS_PLAYWRIGHT_DEFINED
_JS_PLAYWRIGHT_DEFINED := true

# JS_PLAYWRIGHT_BROWSERS is a space separated list of the browsers to install,
# such as "chromium". If it's empty, Playwright installs every browser it
# supports. Installing only the browsers the tests use is much faster, because
# each browser needs its own system dependencies.
JS_PLAYWRIGHT_BROWSERS ?=

################################################################################

# playwright-install --- Installs Playwright browsers and dependencies.
.PHONY: playwright-install
playwright-install: artifacts/playwright/install.touch

################################################################################

artifacts/playwright/install.touch: artifacts/link-dependencies.touch
	@mkdir -p "$(@D)"
	$(JS_EXEC) playwright install --with-deps $(JS_PLAYWRIGHT_BROWSERS)
	@touch "$@"

################################################################################

endif
