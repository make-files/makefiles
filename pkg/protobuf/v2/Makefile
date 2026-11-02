MF_LANGUAGES += proto

# PROTO_FILES is a space separated list of Protocol Buffers files.
PROTO_FILES += $(shell PATH="$(PATH)" git-find . -type f -name '*.proto' -not -regex '^_.*' -not -regex '.*\/_.*')

# PROTO_GRPC_FILES is the subset of PROTO_FILES that contain gRPC service
# definitions.
PROTO_GRPC_FILES ?= $(shell $(MF_ROOT)/pkg/protobuf/v2/bin/filter-grpc $(PROTO_FILES))

# PROTO_INCLUDE_PATHS is a space separated list of include paths to use when
# building the .proto files from this repository.
#
# NOTE: Please avoid adding the current directory (.) in this variable as it may
# cause a "type redefinition" error from the protobuf compiler. The absolute
# path to the current repository is already added to the list of include paths
# via the 'artifacts/protobuf/args/common' file.
PROTO_INCLUDE_PATHS ?=

# PROTOC_COMMAND is the path to the protoc command, if this is not specified
# the latest version of protoc is installed for the host operating system.
PROTOC_COMMAND ?= $(MF_PROJECT_ROOT)/artifacts/protobuf/bin/protoc

# _PROTO_EXEC_PLUGIN is the path to the script passed to protoc as each plugin.
# It runs the command in the PROTO_PLUGIN_COMMAND environment variable, which
# each recipe sets to the command that runs its plugin.
_PROTO_EXEC_PLUGIN := $(MF_ROOT)/pkg/protobuf/v2/bin/exec-protoc-plugin

# _PROTO_GEN_GO and _PROTO_GEN_GO_GRPC are the packages of the Go protoc
# plugins, which are run using "go tool", at the versions in go.mod.
_PROTO_GEN_GO := google.golang.org/protobuf/cmd/protoc-gen-go
_PROTO_GEN_GO_GRPC := google.golang.org/grpc/cmd/protoc-gen-go-grpc

# PROTO_JS_TARGET is the "target" option passed to protoc-gen-es. It is one or
# more of "ts", "js" and "dts", separated by "+". The default, "ts", generates
# TypeScript source files (_pb.ts) that are compiled along with the rest of the
# project. Use "js+dts" to generate JavaScript code and TypeScript declarations
# (_pb.js and _pb.d.ts) instead.
PROTO_JS_TARGET ?= ts

# PROTO_JS_OPT is a comma separated list of additional options passed to
# protoc-gen-es. By default, relative imports between generated files use a
# ".js" extension, which is required for ES modules in Node.js.
PROTO_JS_OPT ?= import_extension=js

# _PROTO_JS_SUFFIXES is the list of file name suffixes that protoc-gen-es
# generates for each .proto file, based on PROTO_JS_TARGET.
_PROTO_JS_SUFFIXES = $(foreach t,$(subst +, ,$(PROTO_JS_TARGET)),$(if $(filter ts,$t),_pb.ts)$(if $(filter js,$t),_pb.js)$(if $(filter dts,$t),_pb.d.ts))

################################################################################

$(MF_PROJECT_ROOT)/artifacts/protobuf/bin/protoc:
	$(MF_ROOT)/pkg/protobuf/v2/bin/install-protoc "$(MF_PROJECT_ROOT)/artifacts/protobuf"

artifacts/protobuf/args/common:
	@mkdir -p "$(@D)"
	@touch "$@"
ifneq ($(PROTO_INCLUDE_PATHS),)
	echo $(addprefix --proto_path=,$(PROTO_INCLUDE_PATHS)) >> "$@"
endif

# .clang-format --- Creates the default clang-format style used to format
# .proto files. It is intended to be committed to the project; it is
# authoritative and is overwritten by "regenerate"/"verify-generated" to keep
# it in sync with the canonical style, the same as any other generated file.
GENERATED_FILES += .clang-format
.clang-format:
	echo 'BasedOnStyle: Google' > "$@"
	echo 'AlignConsecutiveDeclarations: true' >> "$@"
	echo 'AlignConsecutiveAssignments: true' >> "$@"

# precommit --- Formats .proto files with clang-format. Stacks with the
# "precommit" target from the common makefile.
.PHONY: precommit
precommit:: .clang-format
	git-find . -name '*.proto' -exec clang-format --style=file --fallback-style=Google -i {} +

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

%.pb.go: %.proto $(PROTOC_COMMAND) artifacts/protobuf/args/go | artifacts/go/tools/$(_PROTO_GEN_GO).touch
	PROTO_PLUGIN_COMMAND="go tool $(_PROTO_GEN_GO)" $(PROTOC_COMMAND) $$(cat artifacts/protobuf/args/go) --plugin protoc-gen-go=$(_PROTO_EXEC_PLUGIN) $(MF_PROJECT_ROOT)/$<
	$(MF_ROOT)/pkg/protobuf/v2/bin/revert-version-only-changes $@

%_grpc.pb.go: %.proto $(PROTOC_COMMAND) artifacts/protobuf/args/go-grpc | artifacts/go/tools/$(_PROTO_GEN_GO_GRPC).touch
	PROTO_PLUGIN_COMMAND="go tool $(_PROTO_GEN_GO_GRPC)" $(PROTOC_COMMAND) $$(cat artifacts/protobuf/args/go-grpc) --plugin protoc-gen-go-grpc=$(_PROTO_EXEC_PLUGIN) $(MF_PROJECT_ROOT)/$<
	$(MF_ROOT)/pkg/protobuf/v2/bin/revert-version-only-changes $@

artifacts/protobuf/args/go-common: artifacts/protobuf/args/common go.mod
	go mod download all
	@mkdir -p "$(@D)"
	cp "$<" "$@"
	$(MF_ROOT)/pkg/protobuf/v2/bin/generate-go-include-paths | tee "$@"

artifacts/protobuf/args/go: artifacts/protobuf/args/go-common
	@mkdir -p "$(@D)"
	cp "$<" "$@"
	echo "--go_opt=module=$$(go list -m | head -n 1)" >> "$@"
	echo "--go_out=:." >> "$@"

artifacts/protobuf/args/go-grpc: artifacts/protobuf/args/go-common
	@mkdir -p "$(@D)"
	cp "$<" "$@"
	echo "--go-grpc_opt=module=$$(go list -m | head -n 1)" >> "$@"
	echo "--go-grpc_out=." >> "$@"
	echo "--go-grpc_opt=require_unimplemented_servers=false" >> "$@"

# JS ###########################################################################

# The recipes below generate TypeScript or JavaScript code using protoc-gen-es,
# the code generator for the protobuf-es runtime. The project must depend on
# the @bufbuild/protoc-gen-es package.
#
# protoc runs the project's locally installed protoc-gen-es plugin via
# $(JS_EXEC), regardless of the package manager.
#
# Import paths are resolved from "go list -m all" in the same way as for Go, so
# the project must also be a Go module.
#
# protoc names the output files after the virtual import path of each .proto
# file (for example, github.com/foo/bar/dir/file_pb.js), so the plugin writes
# to a staging directory and the files are moved alongside the .proto file.

$(addprefix %,$(_PROTO_JS_SUFFIXES)): %.proto artifacts/link-dependencies.touch $(PROTOC_COMMAND) artifacts/protobuf/args/js
	@mkdir -p artifacts/protobuf/js
	PROTO_PLUGIN_COMMAND="$(JS_EXEC) protoc-gen-es" $(PROTOC_COMMAND) $$(cat artifacts/protobuf/args/js) --plugin protoc-gen-es=$(_PROTO_EXEC_PLUGIN) $(MF_PROJECT_ROOT)/$<
	for suffix in $(_PROTO_JS_SUFFIXES); do \
		mv "artifacts/protobuf/js/$$(go list -m | head -n 1)/$*$$suffix" "$*$$suffix" || exit 1; \
		$(MF_ROOT)/pkg/protobuf/v2/bin/revert-version-only-changes "$*$$suffix" || exit 1; \
	done

artifacts/protobuf/args/js: artifacts/protobuf/args/go-common
	@mkdir -p "$(@D)"
	cp "$<" "$@"
	echo "--es_opt=target=$(PROTO_JS_TARGET)" >> "$@"
ifneq ($(PROTO_JS_OPT),)
	echo "--es_opt=$(PROTO_JS_OPT)" >> "$@"
endif
	echo "--es_out=artifacts/protobuf/js" >> "$@"
