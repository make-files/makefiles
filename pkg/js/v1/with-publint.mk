# JS_PUBLINT_REQ is a space separated list of prerequisites needed to run
# publint.
JS_PUBLINT_REQ +=

################################################################################

# _JS_PUBLINT_REQ is a space separated list of automatically detected
# prerequisites needed to run publint.
_JS_PUBLINT_REQ += artifacts/link-dependencies.touch

# Build the package before checking it. JS_PACKAGE_REQ defaults to building the
# project into artifacts/dist, if with-tsc.mk is included. It's expanded when the
# prerequisites are needed, so it can be set before or after this file.
_JS_PUBLINT_REQ += $$(JS_PACKAGE_REQ)

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
