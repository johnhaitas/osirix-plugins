DEFAULT_BUILDCONFIGURATION=Development

BUILDCONFIGURATION?=$(DEFAULT_BUILDCONFIGURATION)

XCCONFIG = -xcconfig "Build Configuration/Development.xcconfig"

.PHONY: all StereotaxPoint clean latest

all: StereotaxPoint

StereotaxPoint:
	xcodebuild -project StereotaxPoint.xcodeproj -configuration ${BUILDCONFIGURATION} -target "StereotaxPoint" ${XCCONFIG} build

clean:
	xcodebuild -project StereotaxPoint.xcodeproj -configuration ${BUILDCONFIGURATION} -alltargets clean
	rm -rf build

latest:
	svn up ./
	make StereotaxPoint