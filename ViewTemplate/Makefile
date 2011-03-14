DEFAULT_BUILDCONFIGURATION=Development

BUILDCONFIGURATION?=$(DEFAULT_BUILDCONFIGURATION)

ARCHS = i386

.PHONY: all ViewTemplate clean latest

all: ViewTemplate

ViewTemplate:
	xcodebuild -project ViewTemplate.xcodeproj -configuration ${BUILDCONFIGURATION} -target "ViewTemplate" build ARCHS=${ARCHS}

clean:
	xcodebuild -project ViewTemplate.xcodeproj -configuration ${BUILDCONFIGURATION} -alltargets clean
	rm -rf build

latest:
	svn up ./
	make ViewTemplate