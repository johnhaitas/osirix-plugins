DEFAULT_BUILDCONFIGURATION=Development

BUILDCONFIGURATION?=$(DEFAULT_BUILDCONFIGURATION)

ARCHS = i386

.PHONY: all StereotaxPoint clean latest

all: StereotaxPoint

StereotaxPoint:
	xcodebuild -project StereotaxPoint.xcodeproj -configuration ${BUILDCONFIGURATION} -target "StereotaxPoint" build ARCHS=${ARCHS}

clean:
	xcodebuild -project StereotaxPoint.xcodeproj -configuration ${BUILDCONFIGURATION} -alltargets clean
	rm -rf build

latest:
	svn up ./
	make StereotaxPoint