# Generate JavaScript code and TypeScript declarations from the .proto files
# using protoc-gen-es, the code generator for the protobuf-es runtime.
#
# The project must include a JS package manager makefile, such as
# pkg/js/v1/with-pnpm.mk, and depend on @bufbuild/protoc-gen-es and
# @bufbuild/protobuf. Import paths are resolved from "go list -m all", as they
# are for the Go code, so the project must also be a Go module.
#
# Any files in underscore-prefixed directory names are ignored, as per the Go
# convention of using underscores to exclude files and directories from the
# build.
GENERATED_FILES += $(foreach f,$(PROTO_FILES:.proto=_pb.js),$(if $(findstring /_,/$f),,$f))
GENERATED_FILES += $(foreach f,$(PROTO_FILES:.proto=_pb.d.ts),$(if $(findstring /_,/$f),,$f))

# PROTO_ES_OPT is a comma separated list of additional options passed to
# protoc-gen-es. The "target" option is always "js+dts".
#
# By default, relative imports between generated files use a ".js" extension,
# which is required for ES modules in Node.js.
PROTO_ES_OPT ?= import_extension=js

################################################################################

artifacts/protobuf/bin/protoc-gen-es: artifacts/link-dependencies.touch
	$(MF_ROOT)/pkg/protobuf/v2/bin/install-protoc-gen-es "$(MF_PROJECT_ROOT)/$@" "$(JS_EXEC)"

# protoc names its output files after the virtual import path of each .proto
# file (for example, github.com/foo/bar/dir/file_pb.js), so protoc-gen-es writes
# to a staging directory and the files are moved into place alongside the
# .proto file.
%_pb.js %_pb.d.ts: %.proto artifacts/protobuf/bin/protoc-gen-es artifacts/protobuf/bin/run-protoc artifacts/protobuf/args/es
	@mkdir -p artifacts/protobuf/es
	$(PROTO_PROTOC_PATH) $$(cat artifacts/protobuf/args/es) $(MF_PROJECT_ROOT)/$<
	mv "artifacts/protobuf/es/$$(go list -m | head -n 1)/$*_pb.js" "$*_pb.js"
	mv "artifacts/protobuf/es/$$(go list -m | head -n 1)/$*_pb.d.ts" "$*_pb.d.ts"
	$(MF_ROOT)/pkg/protobuf/v2/bin/revert-version-only-changes "$*_pb.js"
	$(MF_ROOT)/pkg/protobuf/v2/bin/revert-version-only-changes "$*_pb.d.ts"

artifacts/protobuf/args/es: artifacts/protobuf/args/go-common
	@mkdir -p "$(@D)"
	cp "$<" "$@"
	echo "--es_opt=target=js+dts" >> "$@"
ifneq ($(PROTO_ES_OPT),)
	echo "--es_opt=$(PROTO_ES_OPT)" >> "$@"
endif
	echo "--es_out=artifacts/protobuf/es" >> "$@"
