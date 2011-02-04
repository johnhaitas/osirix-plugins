#!/bin/bash

# List of plugins
PLUGINS=$(cat plugin-list.txt)

# Location of OsiriX headers
OSIRIX_SOURCE=${PWD}/osirix

# update OsiriX Headers for each plugin
for PLUGIN_NAME in ${PLUGINS}
do
	pushd "${PLUGIN_NAME}/OsiriX Headers"
	HEADERS=$(ls)
	for thisHeader in ${HEADERS}
	do
		if [ ${thisHeader} != "MPRHeaders.h" ]; then
			cp ${OSIRIX_SOURCE}/${thisHeader} ./
		fi
	done
	popd
done