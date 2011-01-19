#!/bin/bash

BUILD_CONFIG=Development

# Set useful directories
ROOT_DIR=${PWD}
PLUGINS_DIR="${HOME}/Library/Application Support/OsiriX/Plugins"
OSIRIX_BUILD_DIR=${ROOT_DIR}/osirix/osirix/build/OsiriX.build/${BUILD_CONFIG}

# List of plugins
PLUGINS="ViewTemplate
TenTwenty
StereotaxPoint"


if [ -d "osirix" ]; then
	# Update OsiriX source
	svn up osirix
else
	# Checkout OsiriX source
	svn co https://osirix.svn.sourceforge.net/svnroot/osirix osirix
fi

# Build OsiriX
make OsiriX

# Build and link plugins
for PLUGIN_NAME in ${PLUGINS}
do
	# Build Plugin
	make "${PLUGIN_NAME}"
	
	# Link build products to OsiriX plugins dir
	ln -Fs "${ROOT_DIR}/${PLUGIN_NAME}/build/${BUILD_CONFIG}/${PLUGIN_NAME}.osirixplugin" "${PLUGINS_DIR}"
	
	# Link debugging symbols
	ln -Fs "${ROOT_DIR}/${PLUGIN_NAME}/build/${PLUGIN_NAME}.build" "${OSIRIX_BUILD_DIR}"
done
