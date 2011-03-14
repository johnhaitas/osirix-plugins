DEFAULT_BUILDCONFIGURATION=Development

BUILDCONFIGURATION?=$(DEFAULT_BUILDCONFIGURATION)

XCCONFIG = -xcconfig "Build Configuration/Development.xcconfig"

.PHONY: all ViewTemplate clean latest

all: ViewTemplate

ViewTemplate:
	xcodebuild -project ViewTemplate.xcodeproj -configuration ${BUILDCONFIGURATION} -target "ViewTemplate" ${XCCONFIG} build

clean:
	xcodebuild -project ViewTemplate.xcodeproj -configuration ${BUILDCONFIGURATION} -alltargets clean
	rm -rf build

latest:
	svn up ./
	make ViewTemplate