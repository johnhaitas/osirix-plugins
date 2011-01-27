#!/bin/bash

# unset_build_number.sh
# TenTwenty
#
# Created by John Haitas on 1/27/11.
# Copyright 2011 Vanderbilt University. All rights reserved.

PROJECTMAIN=$(pwd)
PROJECT_NAME=$(basename "${PROJECTMAIN}")
   
# find the plist file
if [ -f "${PROJECTMAIN}/Info.plist" ]
then
	buildPlist="${PROJECTMAIN}/Info.plist"
else
	echo -e "Can't find the plist: ${PROJECT_NAME}/Info.plist"
	exit 1
fi

# try and get the build version from the plist
buildVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${buildPlist}" 2>/dev/null)
if [ "${buildVersion}" = "" ]
then
	echo -e "\"${buildPlist}\" does not contain key: \"CFBundleVersion\""
	exit 1
fi

# construct a new build number
IFS='.'
set $buildVersion

MAJOR_VERSION="${1}.${2}.${3}"
   
buildNewVersion="${MAJOR_VERSION}.svnRev.buildNum"
   
# write it back to the plist
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${buildNewVersion}" "${buildPlist}"