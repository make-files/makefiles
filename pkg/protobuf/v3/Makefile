MF_LANGUAGES += proto

# PROTO_FILES is a space separated list of Protocol Buffers files.
PROTO_FILES += $(shell PATH="$(PATH)" git-find . -type f -name '*.proto' -not -regex '^_.*' -not -regex '.*\/_.*')

# PROTO_GRPC_FILES is the subset of PROTO_FILES that contain gRPC service
# definitions.
PROTO_GRPC_FILES ?= $(shell $(MF_ROOT)/pkg/protobuf/v3/bin/filter-grpc $(PROTO_FILES))

# PROTO_INCLUDE_PATHS is a space separated list of include paths to use when
# building the .proto files from this repository.
#
# NOTE: Please avoid adding the current directory (.) in this variable as it may
# cause a "type redefinition" error from the protobuf compiler. The absolute
# path to the current repository is already added to the list of include paths
# via the 'artifacts/protobuf/args/common' file.
PROTO_INCLUDE_PATHS ?=

# PROTO_SWIFT_OUT is the relative path to the directory into which generated
# Swift files are placed.
PROTO_SWIFT_OUT ?= .

################################################################################

artifacts/protobuf/args/common:
	@mkdir -p "$(@D)"
	echo $(addprefix --proto_path=,$(PROTO_INCLUDE_PATHS)) > "$@"

# This Makefile provides the recipes used to build each language's source files
# from the .proto files, but it does NOT automatically add these source files to
# the GENERATED_FILES list. This is the responsibility of each language-specific
# Makefile; otherwise any project that included the protobuf Makefile would
# attempt to build source files for every supported language.
#
# NOTE: The $$(cat ...) syntax can NOT be swapped to $$(< ...). For reasons
# unknown this syntax does NOT work under Travis CI.

# GO ###########################################################################

# The recipes below includes each Go module available through `go list -m all`
# command as an import path for the protoc compiler.
#
# The path of the module is used as a virtual path to make the import in the
# .proto file look more natural. For example, with the module's path
# 'github.com/foo/bar' and the proto file 'dir/file.proto' in that module, the
# import statement becomes `import "github.com/foo/bar/dir/file.proto";` in the
# target .proto file.
#
# Please note that relative import paths are strongly discouraged as they
# require adding the current directory (.) to protoc's include path via a
# --proto_path parameter. This may cause "type redefinition" errors during
# protobuf file compilation because the same file is reachable via different
# paths.
#
# The absolute path to the current repository is already added to the list of
# include paths via the 'artifacts/protobuf/args/go' file.
#
# It is also critical to supply absolute paths to the .proto files when running
# the recipe below so that protoc can detect those files as part of this module
# (it uses a simple string prefix comparison). This works because the path to
# this module in the 'artifacts/protobuf/args/go' file is absolute.
#
# The --go_opt=module=... parameter strips the absolute module path prefix off
# the name of the generated files, ensuring they are placed relative to the root
# of the repository.
#
# For more information follow this link:
# https://developers.google.com/protocol-buffers/docs/reference/go-generated#invocation

%.pb.go: %.proto artifacts/protobuf/args/common artifacts/protobuf/args/go
	protoc \
		$$(cat artifacts/protobuf/args/common artifacts/protobuf/args/go) \
		$(MF_PROJECT_ROOT)/$(@D)/*.proto

%_grpc.pb.go: %.proto artifacts/protobuf/args/common artifacts/protobuf/args/go-grpc
	protoc \
		$$(cat artifacts/protobuf/args/common artifacts/protobuf/args/go-grpc) \
		$(MF_PROJECT_ROOT)/$(@D)/*.proto

artifacts/protobuf/args/go: go.mod
	go mod download all
	@mkdir -p "$(@D)"
	echo "--go_opt=module=$$(go list -m)" > "$@"
	echo "--go_out=:." >> "$@"
	$(MF_ROOT)/pkg/protobuf/v3/bin/generate-include-paths >> "$@"

artifacts/protobuf/args/go-grpc: go.mod
	go mod download all
	@mkdir -p "$(@D)"
	echo "--go-grpc_opt=module=$$(go list -m)" > "$@"
	echo "--go-grpc_out=." >> "$@"
	echo "--go-grpc_opt=require_unimplemented_servers=false" >> "$@"
	$(MF_ROOT)/pkg/protobuf/v3/bin/generate-include-paths >> "$@"

# SWIFT ########################################################################

$(PROTO_SWIFT_OUT)/%.pb.swift: %.proto artifacts/protobuf/args/common artifacts/protobuf/args/swift
	@mkdir -p "$(PROTO_SWIFT_OUT)"
	protoc \
		$$(cat artifacts/protobuf/args/common artifacts/protobuf/args/swift) \
		$(MF_PROJECT_ROOT)/$(dir $<)*.proto

$(PROTO_SWIFT_OUT)/%.grpc.swift: %.proto artifacts/protobuf/args/common artifacts/protobuf/args/swift-grpc
	@mkdir -p "$(PROTO_SWIFT_OUT)"
	protoc \
		$$(cat artifacts/protobuf/args/common artifacts/protobuf/args/swift-grpc) \
		$(MF_PROJECT_ROOT)/$(dir $<)*.proto

artifacts/protobuf/args/swift:
	@mkdir -p "$(@D)"
	echo "--proto_path=$(MF_PROJECT_ROOT)" > "$@"
	echo "--swift_opt=Visibility=Public" >> "$@"
	echo "--swift_out=$(PROTO_SWIFT_OUT)" >> "$@"

artifacts/protobuf/args/swift-grpc:
	@mkdir -p "$(@D)"
	echo "--proto_path=$(MF_PROJECT_ROOT)" > "$@"
	echo "--grpc-swift_opt=Visibility=Public" >> "$@"
	echo "--grpc-swift_out=$(PROTO_SWIFT_OUT)" >> "$@"
