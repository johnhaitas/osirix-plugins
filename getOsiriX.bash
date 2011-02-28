#!/bin/bash

OSIRIX_SVN=https://osirix.svn.sourceforge.net/svnroot/osirix/osirix
OSIRIX_REV=`cat osirix-revision.txt`

if [ -d "osirix" ]; then
	# Update OsiriX source
	svn up -r${OSIRIX_REV} osirix
else
	# Checkout OsiriX source
	svn co -r${OSIRIX_REV} ${OSIRIX_SVN}
	
	# Fresh checkout requires Unzip-Binary
	make Unzip-Binaries
fi
