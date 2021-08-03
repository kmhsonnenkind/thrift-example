###############################################################################
# Build, test and documentation targets for C# thrift service
#
# By default offers same targets like other language bindings but also adds the
# possibility to postfix the targets using the ${CSHARP_POSTFIX} parameter:
#   make -f csharp.mk test
#   CSHARP_POSTIFX=-csharp make -f csharp.mk test-csharp
###############################################################################
.PHONY: generate-code${CSHARP_POSTFIX} \
	build${CSHARP_POSTFIX} \
	test${CSHARP_POSTFIX} \
	clean${CSHARP_POSTFIX} \
	server${CSHARP_POSTFIX} \
	client${CSHARP_POSTFIX}


# In- and output paths
_CSHARP_MK_DIRECTORY := $(abspath $(dir $(lastword ${MAKEFILE_LIST})))
CSHARP_SRC_DIR := $(abspath ${_CSHARP_MK_DIRECTORY}/../../csharp/Calculator)


# Tool configuration
DOTNET = dotnet
include $(abspath ${_CSHARP_MK_DIRECTORY}/config.mk)


# Generate code for C# implementation
generate-code${CSHARP_POSTFIX}:	${THRIFT_FILE}
	mkdir -p ${CSHARP_SRC_DIR}
	${THRIFT} -r -gen netstd -out ${CSHARP_SRC_DIR} ${THRIFT_FILE}

# Build binaries
build${CSHARP_POSTFIX}:	generate-code${CSHARP_POSTFIX}
	${DOTNET} build ${CSHARP_SRC_DIR}/Calculator.sln

# Run unittests
test${CSHARP_POSTFIX}:	generate-code${CSHARP_POSTFIX}
	${DOTNET} test ${CSHARP_SRC_DIR}/Calculator.sln

# Remove binaries and generated files
clean${CSHARP_POSTFIX}:
	rm -f ${CSHARP_SRC_DIR}/Calculator/CalculatorService.cs
	rm -f ${CSHARP_SRC_DIR}/Calculator/DivideByZeroException.cs
	rm -rf ${CSHARP_SRC_DIR}/Calculator/bin
	rm -rf ${CSHARP_SRC_DIR}/Calculator/obj
	rm -rf ${CSHARP_SRC_DIR}/Client/bin
	rm -rf ${CSHARP_SRC_DIR}/Client/obj
	rm -rf ${CSHARP_SRC_DIR}/Server/bin
	rm -rf ${CSHARP_SRC_DIR}/Server/obj
	rm -rf ${CSHARP_SRC_DIR}/Server.Tests/bin
	rm -rf ${CSHARP_SRC_DIR}/Server.Tests/obj

# Run thrift server
server${CSHARP_POSTFIX}:	generate-code${CSHARP_POSTFIX}
	${DOTNET} run --project csharp/Calculator/Server

# Run thrift client
client${CSHARP_POSTFIX}:	generate-code${CSHARP_POSTFIX}
	${DOTNET} run --project csharp/Calculator/Client
