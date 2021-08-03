###############################################################################
# Build, test and documentation targets for Java thrift service
#
# By default offers same targets like other language bindings but also adds the
# possibility to postfix the targets using the ${JAVA_POSTFIX} parameter:
#   make -f java.mk test
#   JAVA_POSTFIX=-java make -f java.mk test-java
###############################################################################
.PHONY: generate-code${JAVA_POSTFIX} \
	build${JAVA_POSTFIX} \
	test${JAVA_POSTFIX} \
	check${JAVA_POSTFIX} \
	documentation${JAVA_POSTFIX} \
	clean${JAVA_POSTFIX} \
	server${JAVA_POSTFIX} \
	client${JAVA_POSTFIX}


# In- and output paths
_JAVA_MK_DIRECTORY := $(abspath $(dir $(lastword ${MAKEFILE_LIST})))
JAVA_SRC_DIR := $(abspath ${_JAVA_MK_DIRECTORY}/../../java/calculator)
JAVA_OUTPUT_DIR := $(abspath ${JAVA_SRC_DIR}/src/main/java)


# Tool configuration
include $(abspath ${_JAVA_MK_DIRECTORY}/config.mk)


# Generate code for Java implementation
generate-code${JAVA_POSTFIX}:	${THRIFT_FILE}
	${THRIFT} -r -gen java -out ${JAVA_OUTPUT_DIR} ${THRIFT_FILE}

# Build binaries
build${JAVA_POSTFIX}:	generate-code${JAVA_POSTFIX}
	${JAVA_SRC_DIR}/gradlew -p ${JAVA_SRC_DIR} build

# Run unittests
test${JAVA_POSTFIX}:	generate-code${JAVA_POSTFIX}
	${JAVA_SRC_DIR}/gradlew -p ${JAVA_SRC_DIR} test

# Runs tests and code analysis
check${JAVA_POSTFIX}:	test${JAVA_POSTFIX}
	${JAVA_SRC_DIR}/gradlew -p ${JAVA_SRC_DIR} check

# Build documentation
documentation${JAVA_POSTFIX}:	generate-code${JAVA_POSTFIX}
	${JAVA_SRC_DIR}/gradlew -p ${JAVA_SRC_DIR} javadoc

# Remove binaries and generated files
clean${JAVA_POSTFIX}:
	rm -rf ${JAVA_OUTPUT_DIR}/calculator/gen
	rm -rf ${JAVA_SRC_DIR}/build
	rm -rf ${JAVA_SRC_DIR}/.gradle
	rm -f ${JAVA_SRC_DIR}/.classpath
	rm -f ${JAVA_SRC_DIR}/.project

# Run thrift server
server${JAVA_POSTFIX}:	generate-code${JAVA_POSTFIX}
	${JAVA_SRC_DIR}/gradlew -p ${JAVA_SRC_DIR} runServer

# Run thrift client
client${JAVA_POSTFIX}:	generate-code${JAVA_POSTFIX}
	${JAVA_SRC_DIR}/gradlew -p ${JAVA_SRC_DIR} runClient
