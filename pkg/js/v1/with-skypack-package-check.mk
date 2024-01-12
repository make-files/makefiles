# JS_SKYPACK_PACKAGE_CHECK_REQ is a space separated list of prerequisites needed
# to run @skypack/package-check.
JS_SKYPACK_PACKAGE_CHECK_REQ +=

################################################################################

# _JS_SKYPACK_PACKAGE_CHECK_REQ is a space separated list of automatically
# detected prerequisites needed to run @skypack/package-check.
_JS_SKYPACK_PACKAGE_CHECK_REQ += artifacts/link-dependencies.touch

################################################################################

# skypack-package-check --- Check for NPM package publishing issues using
#                           @skypack/package-check.
.PHONY: skypack-package-check
skypack-package-check: $(JS_SKYPACK_PACKAGE_CHECK_REQ) $(_JS_SKYPACK_PACKAGE_CHECK_REQ)
	$(JS_EXEC) @skypack/package-check

################################################################################

.PHONY: lint
lint:: skypack-package-check

.PHONY: precommit
precommit:: skypack-package-check

.PHONY: ci
ci:: skypack-package-check
