DEFAULT_BUILDCONFIGURATION=Development

BUILDCONFIGURATION?=$(DEFAULT_BUILDCONFIGURATION)

OSIRIX_SVN = https://osirix.svn.sourceforge.net/svnroot/osirix/osirix

ifdef REV
REVISION = -r$(REV)
endif

.PHONY: all Unzip-Binaries OsiriX ViewTemplate TenTwenty StereotaxPoint clean

all: Unzip-Binaries OsiriX ViewTemplate TenTwenty StereotaxPoint

clean:
	xcodebuild -project osirix/Osirix.xcodeproj -configuration ${BUILDCONFIGURATION} -alltargets clean
	make -C ViewTemplate clean
	make -C TenTwenty clean
	make -C StereotaxPoint clean
	rm -rf osirix/osirix/build

checkout:
	svn co $(OSIRIX_SVN) $(REVISION)

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

Plugins:
	make -C ViewTemplate latest
	make -C TenTwenty latest
	make -C StereotaxPoint latest

latest:
	svn up osirix
	make OsiriX
	make Plugins
