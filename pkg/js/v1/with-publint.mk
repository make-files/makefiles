# JS_PUBLINT_REQ is a space separated list of prerequisites needed to run
# publint.
JS_PUBLINT_REQ +=

################################################################################

# _JS_PUBLINT_REQ is a space separated list of automatically detected
# prerequisites needed to run publint.
_JS_PUBLINT_REQ += artifacts/link-dependencies.touch

# If with-tsc.mk builds the project into artifacts/dist, check the built package.
_JS_PUBLINT_REQ += $$(_JS_TSC_DIST)

################################################################################

# publint --- Check for NPM package publishing issues using publint.
.PHONY: publint
publint: $(JS_PUBLINT_REQ) $(_JS_PUBLINT_REQ)
	$(JS_EXEC) publint run --strict

################################################################################

.PHONY: lint
lint:: publint

.PHONY: precommit
precommit:: publint

.PHONY: ci
ci:: publint
