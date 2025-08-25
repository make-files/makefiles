GENERATED_FILES += $(foreach f,$(PROTO_FILES:.proto=_primo.pb.go),$(if $(findstring /_,/$f),,$f))

artifacts/protobuf/bin/protoc-gen-go-primo: go.mod
	$(MF_ROOT)/pkg/protobuf/v2/bin/install-protoc-gen-go-primo "$(MF_PROJECT_ROOT)/$(@D)"

%_primo.pb.go: %.proto artifacts/protobuf/bin/protoc-gen-go-primo artifacts/protobuf/bin/run-protoc artifacts/protobuf/args/go-primo
	$(PROTO_PROTOC_PATH) $$(cat artifacts/protobuf/args/go-primo) $(MF_PROJECT_ROOT)/$<
	$(MF_ROOT)/pkg/protobuf/v2/bin/revert-version-only-changes $@

artifacts/protobuf/args/go-primo: artifacts/protobuf/args/go-common
	@mkdir -p "$(@D)"
	cp "$<" "$@"
	echo "--plugin protoc-gen-go-primo=artifacts/protobuf/bin/protoc-gen-go-primo" >> "$@"
	echo "--go-primo_opt=module=$$(go list -m | head -n 1)" >> "$@"
	echo "--go-primo_out=." >> "$@"
