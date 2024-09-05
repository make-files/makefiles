artifacts/vitest/browser/public:: artifacts/vitest/browser/public/mockServiceWorker.js

artifacts/vitest/browser/public/mockServiceWorker.js: artifacts/link-dependencies.touch
	@mkdir -p "$(@D)"
	$(JS_EXEC) msw init --no-save "$(@D)"
