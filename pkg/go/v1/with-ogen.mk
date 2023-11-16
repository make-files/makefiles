GO_OPENAPI_FILES += $(shell PATH="$(PATH)" git-find . -name 'openapi.yml' -not -regex '^_.*' -not -regex '.*\/_.*')
GENERATED_FILES += $(foreach f,$(GO_OPENAPI_FILES:.yml=.ogen.go),$(if $(findstring /_,/$f),,$f))

artifacts/go/bin/ogen: go.mod
	@mkdir -p "$(@D)"
	GOBIN=$(MF_PROJECT_ROOT)/artifacts/go/bin go install -v github.com/ogen-go/ogen/cmd/ogen

%.ogen.go: %.yml artifacts/go/bin/ogen
	$(eval PACKAGE := $(notdir $(@D)))

	artifacts/go/bin/ogen \
		-target $(@D) \
		-package $(PACKAGE) \
		-clean \
		-config $(MF_ROOT)/pkg/go/v1/ogen.yml \
		$<

	@echo "// This file is used by the makefiles as a stand-in for the complete" > $@
	@echo "// set of files generated by ogen, which is not known ahead of time." >> $@
	@echo "" >> $@
	@echo "package $(PACKAGE)" >> $@
