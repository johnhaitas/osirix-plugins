DEFAULT_BUILDCONFIGURATION=Development

BUILDCONFIGURATION?=$(DEFAULT_BUILDCONFIGURATION)

.PHONY: all ViewTemplate clean latest

all: ViewTemplate

ViewTemplate:
	xcodebuild -project ViewTemplate.xcodeproj -configuration ${BUILDCONFIGURATION} -target "ViewTemplate" build

clean:
	xcodebuild -project ViewTemplate.xcodeproj -configuration ${BUILDCONFIGURATION} --alltargets clean
	rm -rf build

latest:
	svn up ./
	make ViewTemplate