GENERATED_FILES += $(foreach f,$(PROTO_FILES:.proto=_primo.pb.go),$(if $(findstring /_,/$f),,$f))

%_primo.pb.go: %.proto artifacts/protobuf/args/common artifacts/protobuf/args/go-primo
	protoc \
		$$(cat artifacts/protobuf/args/common artifacts/protobuf/args/go-primo) \
		$(MF_PROJECT_ROOT)/$(@D)/*.proto

artifacts/protobuf/args/go-primo: go.mod
	go mod download all
	@mkdir -p "$(@D)"
	echo "--go-primo_opt=module=$$(go list -m)" >> "$@"
	echo "--go-primo_out=." >> "$@"
	$(MF_ROOT)/pkg/protobuf/v3/bin/generate-include-paths >> "$@"
