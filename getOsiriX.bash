#!/bin/bash

osirixRev=`cat osirix-revision.txt`

echo "${osirixRev}"

if [ -d "osirix" ]; then
	# Update OsiriX source
	svn up osirix
else
	# Checkout OsiriX source
	make checkout
	
	# Fresh checkout requires Unzip-Binary
	make Unzip-Binaries
fi
