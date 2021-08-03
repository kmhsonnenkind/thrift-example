# Tool configuration
THRIFT := thrift

# In- and output paths
_CONFIG_MK_DIRECTORY := $(abspath $(dir $(lastword ${MAKEFILE_LIST})))
THRIFT_FILE := $(abspath ${_CONFIG_MK_DIRECTORY}/../../calculator.thrift )
