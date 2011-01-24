DEFAULT_BUILDCONFIGURATION=Development

BUILDCONFIGURATION?=$(DEFAULT_BUILDCONFIGURATION)

.PHONY: all StereotaxPoint clean latest

all: StereotaxPoint

StereotaxPoint:
	xcodebuild -project StereotaxPoint.xcodeproj -configuration ${BUILDCONFIGURATION} -target "StereotaxPoint" build

clean:
	xcodebuild -project StereotaxPoint.xcodeproj -configuration ${BUILDCONFIGURATION} clean
	rm -rf build

latest:
	svn up ./
	make StereotaxPoint