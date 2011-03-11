#!/bin/bash

# List of plugins
PLUGINS=$(cat plugin-list.txt)

# Location of *STABLE* OsiriX headers
OSIRIX_STABLE_SOURCE=${PWD}/osirix-stable

# update OsiriX Headers for each plugin
for PLUGIN_NAME in ${PLUGINS}
do
	pushd "${PLUGIN_NAME}/OsiriX Headers"
	for thisHeader in *.h
	do
		if [ ${thisHeader} != "MPRHeaders.h" ]; then
			cp ${OSIRIX_STABLE_SOURCE}/${thisHeader} ./
		fi
	done
	popd
done