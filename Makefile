DEFAULT_BUILDCONFIGURATION=Development

BUILDCONFIGURATION?=$(DEFAULT_BUILDCONFIGURATION)

OSIRIX_SVN = https://osirix.svn.sourceforge.net/svnroot/osirix/osirix
OSIRIX_REV = $(shell cat osirix-revision.txt 2> /dev/null || echo not)

.PHONY: all Unzip-Binaries OsiriX ViewTemplate TenTwenty StereotaxPoint clean

all: Unzip-Binaries OsiriX ViewTemplate TenTwenty StereotaxPoint

clean:
	xcodebuild -project osirix/Osirix.xcodeproj -configuration ${BUILDCONFIGURATION} -alltargets clean
	make -C ViewTemplate clean
	make -C TenTwenty clean
	make -C StereotaxPoint clean
	rm -rf osirix/osirix/build

checkout:
	svn co -r${OSIRIX_REV} $(OSIRIX_SVN) 

Unzip-Binaries: 
	xcodebuild -project osirix/Osirix.xcodeproj -configuration ${BUILDCONFIGURATION} -target "Unzip Binaries" build

OsiriX:
	xcodebuild -project osirix/Osirix.xcodeproj -parallelizeTargets -configuration ${BUILDCONFIGURATION} -target "OsiriX" build

ViewTemplate:
	make -C ViewTemplate

TenTwenty:
	make -C TenTwenty

StereotaxPoint:
	make -C StereotaxPoint

Plugins: ViewTemplate TenTwenty StereotaxPoint

