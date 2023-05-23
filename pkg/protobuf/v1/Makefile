# PROTO_FILES is a space separated list of Protocol Buffers files.
PROTO_FILES += $(shell PATH="$(PATH)" git-find . -name '*.proto' -not -regex '^_.*' -not -regex '.*\/_.*')

# PROTO_INCLUDE_PATHS is a space separate list of include paths to use when
# building the .proto files from this repository.
#
# NOTE: Please avoid adding the current directory (.) in this variable as it may
# cause a "type redefinition" error from the protobuf compiler. The absolute
# path to the current repository is already added to the list of include paths
# via the 'artifacts/protobuf/go.proto_paths' file.
PROTO_INCLUDE_PATHS ?=

# PROTOC_COMMAND is the path to the protoc command, if this is not specified
# the latest version of protoc is installed for the host operating system.
PROTOC_COMMAND ?= $(MF_PROJECT_ROOT)/artifacts/protobuf/bin/protoc

################################################################################

# This Makefile provides the recipes used to build each language's source files
# from the .proto files, but it does NOT automatically add these source files to
# the GENERATED_FILES list. This is the responsibility of each language-specific
# Makefile; otherwise any project that included the protobuf Makefile would
# attempt to build source files for every supported language.

# This recipe below includes each Golang module available through `go list -m
# all` command as an import path for the protoc compiler.
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
# include paths via the 'artifacts/protobuf/go.proto_paths' file.
#
#
# It is also critical to supply absolute paths to the .proto files when running
# the recipe below so that protoc can detect those files as part of this module
# (it uses a simple string prefix comparison). This works because the path to
# this module in the 'artifacts/protobuf/go.proto_paths' file is absolute.
#
# The --go_opt=module=... parameter strips the absolute module path prefix off
# the name of the generated files, ensuring they are placed relative to the root
# of the repository.
#
# For more information follow this link:
# https://developers.google.com/protocol-buffers/docs/reference/go-generated#invocation
#
# NOTE: The $$(cat ...) syntax can NOT be swapped to $$(< ...). For reasons
# unknown this syntax does NOT work under Travis CI.
%.pb.go: %.proto $(PROTOC_COMMAND) artifacts/protobuf/bin/protoc-gen-go artifacts/protobuf/go.proto_paths
	PATH="$(MF_PROJECT_ROOT)/artifacts/protobuf/bin:$$PATH" $(PROTOC_COMMAND) \
		--proto_path="$(dir $(PROTOC_COMMAND))../include" \
		--go_out=plugins=grpc:. \
		--go_opt=module=$$(go list -m) \
		$$(cat artifacts/protobuf/go.proto_paths) \
		$(addprefix --proto_path=,$(PROTO_INCLUDE_PATHS)) \
		"$(MF_PROJECT_ROOT)/$(@D)"/*.proto

$(MF_PROJECT_ROOT)/artifacts/protobuf/bin/protoc:
	$(MF_ROOT)/pkg/protobuf/v1/bin/install-protoc "$(MF_PROJECT_ROOT)/artifacts/protobuf"

artifacts/protobuf/bin/protoc-gen-go: go.mod
	$(MF_ROOT)/pkg/protobuf/v1/bin/install-protoc-gen-go "$(MF_PROJECT_ROOT)/$(@D)"

artifacts/protobuf/go.proto_paths: go.mod
	go mod download all
	mkdir -p $(@D)
	go list -f "--proto_path={{if .Dir}}{{ .Path }}={{ .Dir }}{{end}}" -m all > $@
