# JS_ARETHETYPESWRONG_REQ is a space separated list of prerequisites needed to
# run "Are The Types Wrong?".
JS_ARETHETYPESWRONG_REQ +=

################################################################################

# _JS_ARETHETYPESWRONG_REQ is a space separated list of automatically detected
# prerequisites needed to run "Are The Types Wrong?".
_JS_ARETHETYPESWRONG_REQ += artifacts/link-dependencies.touch

################################################################################

# arethetypeswrong --- Check for TypeScript type issues using "Are The Types
#                      Wrong?".
.PHONY: arethetypeswrong
arethetypeswrong: $(JS_ARETHETYPESWRONG_REQ) $(_JS_ARETHETYPESWRONG_REQ)
	$(JS_EXEC) @arethetypeswrong/cli --pack

################################################################################

.PHONY: lint
lint:: arethetypeswrong

.PHONY: precommit
precommit:: arethetypeswrong

.PHONY: ci
ci:: arethetypeswrong
