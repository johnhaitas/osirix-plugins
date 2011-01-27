#!/bin/bash

# set_build_number.sh
# TenTwenty
#
# Created by John Haitas on 1/27/11.
# Copyright 2011 Vanderbilt University. All rights reserved.


PROJECTMAIN=$(pwd)
PROJECT_NAME=$(basename "${PROJECTMAIN}")
lastBuildTxtFile="${CONFIGURATION_TEMP_DIR}/lastBuild.txt"

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
   
# get the subversion revision  
svnVersion=$(svnversion . | perl -p -e "s/([\d]*:)([\d+[M|S]*).*/\$2/")

# load and parse last build information
if [ -f ${lastBuildTxtFile} ]
then
	lastBuild=$(/bin/cat ${lastBuildTxtFile})
	IFS='.' 
	set ${lastBuild}
	previousSvnVersion=${1}
	previousBuildNumber=${2}
else
	previousSvnVersion=-1
fi

# construct a new build number  
IFS='.'  
set $buildVersion

MAJOR_VERSION="${1}.${2}.${3}"
   
if [ ${previousSvnVersion} != ${svnVersion} ]  
then
	buildNumber=0  
else
	buildNumber=$(($previousBuildNumber + 1))  
fi  
   
buildNewVersion="${MAJOR_VERSION}.${svnVersion}.${buildNumber}"  
echo -e "Version number: ${buildNewVersion}"
   
# write it back to the plist  
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${buildNewVersion}" "${buildPlist}"

# write the svn revision of this build to an unversioned file
echo "${svnVersion}.${buildNumber}" > "${lastBuildTxtFile}"