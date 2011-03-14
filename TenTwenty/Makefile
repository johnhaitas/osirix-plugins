DEFAULT_BUILDCONFIGURATION=Development

BUILDCONFIGURATION?=$(DEFAULT_BUILDCONFIGURATION)

ARCHS = i386

.PHONY: all TenTwenty clean latest

all: TenTwenty

TenTwenty:
	xcodebuild -project TenTwenty.xcodeproj -configuration ${BUILDCONFIGURATION} -target "TenTwenty" build ARCHS=${ARCHS}

clean:
	xcodebuild -project TenTwenty.xcodeproj -configuration ${BUILDCONFIGURATION} -alltargets clean
	rm -rf build

latest:
	svn up ./
	make TenTwenty
