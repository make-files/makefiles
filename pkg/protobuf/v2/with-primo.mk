GENERATED_FILES += $(foreach f,$(PROTO_FILES:.proto=_primo.pb.go),$(if $(findstring /_,/$f),,$f))

GO_TOOLS += github.com/dogmatiq/primo/cmd/protoc-gen-go-primo

%_primo.pb.go: %.proto $(PROTOC_COMMAND) artifacts/protobuf/args/go-primo | artifacts/go/tools.touch
	PROTO_PLUGIN_COMMAND="go tool github.com/dogmatiq/primo/cmd/protoc-gen-go-primo" $(PROTOC_COMMAND) $$(cat artifacts/protobuf/args/go-primo) --plugin protoc-gen-go-primo=$(_PROTO_EXEC_PLUGIN) $(MF_PROJECT_ROOT)/$<
	$(MF_ROOT)/pkg/protobuf/v2/bin/revert-version-only-changes $@

artifacts/protobuf/args/go-primo: artifacts/protobuf/args/go-common
	@mkdir -p "$(@D)"
	cp "$<" "$@"
	echo "--go-primo_opt=module=$$(go list -m | head -n 1)" >> "$@"
	echo "--go-primo_out=." >> "$@"
