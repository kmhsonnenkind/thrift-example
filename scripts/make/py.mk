###############################################################################
# Build, test and documentation targets for Python thrift service
#
# By default offers same targets like other language bindings but also adds the
# possibility to postfix the targets using the ${PY_POSTFIX} parameter:
#   make -f py.mk test
#   PY_POSTFIX=-py make -f py.mk test-py
###############################################################################
.PHONY: generate-code${PY_POSTFIX} \
	test${PY_POSTFIX} \
	check${PY_POSTFIX} \
	documentation${PY_POSTFIX} \
	clean${PY_POSTFIX} \
	server${PY_POSTFIX} \
	client${PY_POSTFIX}


# In- and output paths
_PY_MK_DIRECTORY := $(abspath $(dir $(lastword ${MAKEFILE_LIST})))
PY_SRC_DIR := $(abspath ${_PY_MK_DIRECTORY}/../../python)
PY_OUTPUT_DIR := $(abspath ${PY_SRC_DIR}/calculator/gen)


# Tool configuration
PYTHON := python
include $(abspath ${_PY_MK_DIRECTORY}/config.mk)


# Generate code for Python implementation
generate-code${PY_POSTFIX}:	${THRIFT_FILE}
	mkdir -p ${PY_OUTPUT_DIR}
	${THRIFT} -r -gen py -out ${PY_OUTPUT_DIR} ${THRIFT_FILE}

# Run unittests
test${PY_POSTFIX}:	generate-code${PY_POSTFIX}
	cd ${PY_SRC_DIR}; \
	${PYTHON} setup.py pytest

# Run tests and code analysis
check${PY_POSTFIX}:	test${PY_POSTFIX} generate-code${PY_POSTFIX}
	cd ${PY_SRC_DIR}; \
	${PYTHON} -m pycodestyle calculator
	cd ${PY_SRC_DIR}; \
	${PYTHON} -m flake8 calculator
	cd ${PY_SRC_DIR}; \
	${PYTHON} -m mypy calculator
	cd ${PY_SRC_DIR}; \
	${PYTHON} -m pylint calculator

# Build documentation
documentation${PY_POSTFIX}:	generate-code${PY_POSTFIX}
	cd ${PY_SRC_DIR}; \
	${PYTHON} setup.py build_sphinx

# Remove binaries and cache files
clean${PY_POSTFIX}:
	rm -rf ${PY_OUTPUT_DIR}
	rm -rf ${PY_SRC_DIR}/calculator/__pycache__
	rm -rf ${PY_SRC_DIR}/calculator.egg-info
	rm -rf ${PY_SRC_DIR}/.eggs
	rm -rf ${PY_SRC_DIR}/.pytest_cache
	rm -rf ${PY_SRC_DIR}/tests/__pycache__
	rm -rf ${PY_SRC_DIR}/build
	rm -rf ${PY_SRC_DIR}/.mypy_cache

# Run thrift server
server${PY_POSTFIX}:	generate-code${PY_POSTFIX}
	PYTHONPATH=${PY_SRC_DIR}:${PYTHONPATH} \
	${PYTHON} ${PY_SRC_DIR}/calculator/server.py

# Run thrift client
client${PY_POSTFIX}:	generate-code${PY_POSTFIX}
	PYTHONPATH=${PY_SRC_DIR}:${PYTHONPATH} \
	${PYTHON} ${PY_SRC_DIR}/calculator/client.py
