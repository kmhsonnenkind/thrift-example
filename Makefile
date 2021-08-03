###############################################################################
# Main entry file for building all language bindings for the thrift service
###############################################################################
.PHONY: all \
	generate-code \
	build \
	test \
	check \
	documentation \
	clean


# Load language bindings
CSHARP_POSTFIX=-csharp
include scripts/make/csharp.mk

JAVA_POSTFIX=-java
include scripts/make/java.mk

PY_POSTFIX=-py
include scripts/make/py.mk


# Default: Build all binaries
all:	build

# Generate code for all supported languages
generate-code:	generate-code-csharp generate-code-java generate-code-py

# Build all binaries
build:	build-csharp build-java generate-code-py

# Run all unittests
test:	test-csharp test-java test-py

# Run tests and additional code checks
check:	check-java check-py

# Build documentation for all languages
documentation:	documentation-java documentation-py

# Remove generated files and binaries
clean:	clean-csharp clean-java clean-py
