# Build JavaScript code and TypeScript declarations from protocol buffers
# definitions using protoc-gen-es.
#
# The recipes are provided by pkg/protobuf/v2/Makefile, which must also be
# included. See that file for requirements.
#
# Any files in underscore-prefixed directory names are ignored, as per the Go
# convention of using underscores to exclude files and directories from the
# build.
GENERATED_FILES += $(foreach f,$(PROTO_FILES:.proto=_pb.js),$(if $(findstring /_,/$f),,$f))
GENERATED_FILES += $(foreach f,$(PROTO_FILES:.proto=_pb.d.ts),$(if $(findstring /_,/$f),,$f))
