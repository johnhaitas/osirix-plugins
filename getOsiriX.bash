#!/bin/bash

OSIRIX_SVN=https://osirix.svn.sourceforge.net/svnroot/osirix/osirix
OSIRIX_STABLE_REV=`cat osirix-revision.txt`

OSIRIX_STABLE_DIR=osirix-stable
OSIRIX_UNSTABLE_DIR=osirix-unstable

if [ -d "${OSIRIX_STABLE_DIR}" ]; then
	# Update OsiriX source
	svn up -r${OSIRIX_STABLE_REV} ${OSIRIX_STABLE_DIR}
else
	# Checkout OsiriX source
	svn co -r${OSIRIX_STABLE_REV} ${OSIRIX_SVN} ${OSIRIX_STABLE_DIR}
fi

if [ -d "osirix-unstable" ]; then
	# update OsiriX unstable source
	svn up ${OSIRIX_UNSTABLE_DIR}
else
	# Checkout OsiriX unstable source
	svn co ${OSIRIX_SVN} ${OSIRIX_UNSTABLE_DIR}
fi	
