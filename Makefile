# PROTO_FILES is a space separated list of Protocol Buffers files.
PROTO_FILES += $(shell PATH="$(PATH)" git-find '*.proto')

# PROTO_INCLUDE_PATHS is a space separate list of include paths to use when
# building the .proto files from this repository.
PROTO_INCLUDE_PATHS += .

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
%.pb.go: %.proto artifacts/protobuf/bin/protoc-gen-go
	go mod download -x all

	PATH="$(MF_PROJECT_ROOT)/artifacts/protobuf/bin:$$PATH" protoc \
		--go_out=paths=source_relative,plugins=grpc:. \
		$(addprefix --proto_path=,$(shell go list -f "{{if .Dir}}{{ .Path }}={{ .Dir }}{{end}}" -m all | tr '\n' ' ')) \
		$(addprefix --proto_path=,$(PROTO_INCLUDE_PATHS)) \
		$(@D)/*.proto

artifacts/protobuf/bin/protoc-gen-go: go.mod
	$(MF_ROOT)/pkg/protobuf/v1/bin/install-protoc-gen-go "$(MF_PROJECT_ROOT)/$(@D)"
