# JS_ARETHETYPESWRONG_REQ is a space separated list of prerequisites needed to
# run "Are The Types Wrong?".
JS_ARETHETYPESWRONG_REQ +=

################################################################################

# _JS_ARETHETYPESWRONG_REQ is a space separated list of automatically detected
# prerequisites needed to run "Are The Types Wrong?".
_JS_ARETHETYPESWRONG_REQ += artifacts/link-dependencies.touch

# Build the package before checking it. JS_PACKAGE_REQ defaults to building the
# project into artifacts/dist, if with-tsc.mk is included. It's expanded when the
# prerequisites are needed, so it can be set before or after this file.
_JS_ARETHETYPESWRONG_REQ += $$(JS_PACKAGE_REQ)

################################################################################

# arethetypeswrong --- Check for TypeScript type issues using "Are The Types
#                      Wrong?".
.PHONY: arethetypeswrong
arethetypeswrong: $(JS_ARETHETYPESWRONG_REQ) $(_JS_ARETHETYPESWRONG_REQ)
	$(JS_EXEC) attw --pack

################################################################################

.PHONY: lint
lint:: arethetypeswrong

.PHONY: precommit
precommit:: arethetypeswrong

.PHONY: ci
ci:: arethetypeswrong
