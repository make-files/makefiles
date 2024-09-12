ifndef _JS_PLAYWRIGHT_DEFINED
_JS_PLAYWRIGHT_DEFINED := true

################################################################################

# playwright-install --- Installs Playwright browsers and dependencies.
.PHONY: playwright-install
playwright-install: artifacts/playwright/install.touch

################################################################################

artifacts/playwright/install.touch: artifacts/link-dependencies.touch
	@mkdir -p "$(@D)"
	$(JS_EXEC) playwright install --with-deps
	@touch "$@"

################################################################################

endif
