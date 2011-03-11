#!/bin/bash

BUILD_CONFIG=Development

# Set useful directories
ROOT_DIR=${PWD}
PLUGINS_DIR="${HOME}/Library/Application Support/OsiriX/Plugins"

OSIRIX_STABLE_DIR=${ROOT_DIR}/osirix-stable
OSIRIX_UNSTABLE_DIR=${ROOT_DIR}/osirix-unstable

OSIRIX_STABLE_BUILD_DIR=${OSIRIX_STABLE_DIR}/build/OsiriX.build/${BUILD_CONFIG}
OSIRIX_UNSTABLE_BUILD_DIR=${OSIRIX_UNSTABLE_DIR}/build/OsiriX.build/${BUILD_CONFIG}

# List of plugins
PLUGINS=$(cat plugin-list.txt)

# Build OsiriX
make OsiriX

# Build and link plugins
for PLUGIN_NAME in ${PLUGINS}
do
	# Build Plugin
	make "${PLUGIN_NAME}"
	
	# Link build products to OsiriX plugins dir
	ln -Fs "${ROOT_DIR}/${PLUGIN_NAME}/build/${BUILD_CONFIG}/${PLUGIN_NAME}.osirixplugin" "${PLUGINS_DIR}"
	
	# Link debugging symbols in both stable and unstable build directories
	ln -Fs "${ROOT_DIR}/${PLUGIN_NAME}/build/${PLUGIN_NAME}.build/${BUILD_CONFIG}/${PLUGIN_NAME}.build" "${OSIRIX_STABLE_BUILD_DIR}"
	ln -Fs "${ROOT_DIR}/${PLUGIN_NAME}/build/${PLUGIN_NAME}.build/${BUILD_CONFIG}/${PLUGIN_NAME}.build" "${OSIRIX_UNSTABLE_BUILD_DIR}"
done