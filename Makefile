DEFAULT_BUILDCONFIGURATION=Development

BUILDCONFIGURATION?=$(DEFAULT_BUILDCONFIGURATION)

OSIRIX_SVN = https://osirix.svn.sourceforge.net/svnroot/osirix/osirix
OSIRIX_REV = $(shell cat osirix-revision.txt 2> /dev/null || echo not)

OSIRIX_STABLE_DIR = osirix-stable
OSIRIX_UNSTABLE_DIR = osirix-unstable

.PHONY: all Unzip-Binaries OsiriX-Stable OsiriX-Unstable OsiriX ViewTemplate TenTwenty StereotaxPoint clean

all: Unzip-Binaries OsiriX ViewTemplate TenTwenty StereotaxPoint

clean:
	xcodebuild -project ${OSIRIX_STABLE_DIR}/Osirix.xcodeproj -configuration ${BUILDCONFIGURATION} -alltargets clean
	xcodebuild -project ${OSIRIX_UNSTABLE_DIR}/Osirix.xcodeproj -configuration ${BUILDCONFIGURATION} -alltargets clean
	make -C ViewTemplate clean
	make -C TenTwenty clean
	make -C StereotaxPoint clean

Unzip-Binaries: 
	xcodebuild -project ${OSIRIX_STABLE_DIR}/Osirix.xcodeproj -configuration ${BUILDCONFIGURATION} -target "Unzip Binaries" build
	xcodebuild -project ${OSIRIX_UNSTABLE_DIR}/Osirix.xcodeproj -configuration ${BUILDCONFIGURATION} -target "Unzip Binaries" build

OsiriX-Stable:
	xcodebuild -project ${OSIRIX_STABLE_DIR}/Osirix.xcodeproj -parallelizeTargets -configuration ${BUILDCONFIGURATION} -target "OsiriX" build

OsiriX-Unstable:
	xcodebuild -project ${OSIRIX_UNSTABLE_DIR}/Osirix.xcodeproj -parallelizeTargets -configuration ${BUILDCONFIGURATION} -target "OsiriX" build

OsiriX:
	make Unzip-Binaries
	make OsiriX-Stable
	make OsiriX-Unstable

ViewTemplate:
	make -C ViewTemplate

TenTwenty:
	make -C TenTwenty

StereotaxPoint:
	make -C StereotaxPoint

Plugins: ViewTemplate TenTwenty StereotaxPoint

latest:
	svn up ${OSIRIX_UNSTABLE_DIR}
	make OsiriX-Unstable
