DEFAULT_BUILDCONFIGURATION=Development

BUILDCONFIGURATION?=$(DEFAULT_BUILDCONFIGURATION)

.PHONY: all TenTwenty clean latest

all: TenTwenty

TenTwenty:
	xcodebuild -project TenTwenty.xcodeproj -configuration ${BUILDCONFIGURATION} -target "TenTwenty" build

clean:
	xcodebuild -project TenTwenty.xcodeproj -configuration ${BUILDCONFIGURATION} --alltargets clean
	rm -rf build

latest:
	svn up ./
	make TenTwenty
