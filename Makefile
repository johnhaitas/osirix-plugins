
BUILDCONFIGURATION=Development

.PHONY: all Unzip-Binaries OsiriX ViewTemplate TenTwenty StereotaxPoint clean

Unzip-Binaries: 
	xcodebuild -project osirix/osirix/Osirix.xcodeproj -configuration ${BUILDCONFIGURATION} -target "Unzip Binaries" build

OsiriX:
	make Unzip-Binaries
	xcodebuild -project osirix/osirix/Osirix.xcodeproj -configuration ${BUILDCONFIGURATION} -target "OsiriX" build

ViewTemplate:
	xcodebuild -project ViewTemplate/ViewTemplate.xcodeproj -configuration ${BUILDCONFIGURATION} -target "ViewTemplate" build

TenTwenty:
	xcodebuild -project TenTwenty/TenTwenty.xcodeproj -configuration ${BUILDCONFIGURATION} -target "TenTwenty" build

StereotaxPoint:
	xcodebuild -project StereotaxPoint/StereotaxPoint.xcodeproj -configuration ${BUILDCONFIGURATION} -target "StereotaxPoint" build

clean:
	xcodebuild -project osirix/osirix/Osirix.xcodeproj -configuration ${BUILDCONFIGURATION} clean
	xcodebuild -project ViewTemplate/ViewTemplate.xcodeproj -configuration ${BUILDCONFIGURATION} clean
	xcodebuild -project TenTwenty/TenTwenty.xcodeproj -configuration ${BUILDCONFIGURATION} clean
	xcodebuild -project StereotaxPoint/StereotaxPoint.xcodeproj -configuration ${BUILDCONFIGURATION} clean
