#!/bin/sh
mkdir -p output/ios
mkdir -p output/osx
(cd build3 && ./premake4_osx xcode4)
(cd build3/xcode4 && xcodebuild -sdk iphonesimulator ARCHS='$(ARCHS_STANDARD)' \
    -project BulletCollision.xcodeproj -configuration "Release Native 64-bit" \
    VALID_ARCHS='i386 x86_64' STANDARD_C_PLUS_PLUS_LIBRARY_TYPE='dynamic' clean build)
(cd build3/xcode4 && xcodebuild -sdk iphoneos ARCHS='$(ARCHS_STANDARD)' \
    -project BulletCollision.xcodeproj -configuration "Release Native 32-bit" \
    VALID_ARCHS='armv7 arm64' STANDARD_C_PLUS_PLUS_LIBRARY_TYPE='dynamic' clean build)
(cd build3/xcode4 && xcodebuild -sdk iphonesimulator ARCHS='$(ARCHS_STANDARD)' \
    -project LinearMath.xcodeproj -configuration "Release Native 64-bit" \
    VALID_ARCHS='i386 x86_64' STANDARD_C_PLUS_PLUS_LIBRARY_TYPE='dynamic' clean build)
(cd build3/xcode4 && xcodebuild -sdk iphoneos ARCHS='$(ARCHS_STANDARD)' \
    -project LinearMath.xcodeproj -configuration "Release Native 32-bit" \
    VALID_ARCHS='armv7 arm64' STANDARD_C_PLUS_PLUS_LIBRARY_TYPE='dynamic' clean build)
(cd build3/xcode4 && xcodebuild -sdk iphonesimulator ARCHS='$(ARCHS_STANDARD)' \
    -project BulletDynamics.xcodeproj -configuration "Release Native 64-bit" \
    VALID_ARCHS='i386 x86_64' STANDARD_C_PLUS_PLUS_LIBRARY_TYPE='dynamic' clean build)
(cd build3/xcode4 && xcodebuild -sdk iphoneos ARCHS='$(ARCHS_STANDARD)' \
    -project BulletDynamics.xcodeproj -configuration "Release Native 32-bit" \
    VALID_ARCHS='armv7 arm64' STANDARD_C_PLUS_PLUS_LIBRARY_TYPE='dynamic' clean build)

lipo -create lib/libBulletCollision_xcode4.a lib/libBulletCollision_xcode4_x64_release.a -o output/ios/libBulletCollision.a
lipo -create lib/libLinearMath_xcode4_x64_release.a lib/libLinearMath_xcode4.a -o output/ios/libLinearMath.a
lipo -create lib/libBulletDynamics_xcode4_x64_release.a lib/libBulletDynamics_xcode4.a -o output/ios/libBulletDynamics.a

(cd build3/xcode4 && xcodebuild -sdk macosx ARCHS='$(ARCHS_STANDARD)' \
    -project BulletCollision.xcodeproj -configuration "Release Native 64-bit" \
    VALID_ARCHS='i386 x86_64' STANDARD_C_PLUS_PLUS_LIBRARY_TYPE='dynamic' clean build)
(cd build3/xcode4 && xcodebuild -sdk macosx ARCHS='$(ARCHS_STANDARD)' \
    -project LinearMath.xcodeproj -configuration "Release Native 64-bit" \
    VALID_ARCHS='i386 x86_64' STANDARD_C_PLUS_PLUS_LIBRARY_TYPE='dynamic' clean build)
(cd build3/xcode4 && xcodebuild -sdk macosx ARCHS='$(ARCHS_STANDARD)' \
    -project BulletDynamics.xcodeproj -configuration "Release Native 64-bit" \
    VALID_ARCHS='i386 x86_64' STANDARD_C_PLUS_PLUS_LIBRARY_TYPE='dynamic' clean build)
cp lib/libBulletCollision_xcode4_x64_release.a output/osx/libBulletCollision.a
cp lib/libLinearMath_xcode4_x64_release.a output/osx/libLinearMath.a
cp lib/libBulletDynamics_xcode4_x64_release.a output/osx/libBulletDynamics.a

rsync -av --include="*/" --include="*.h" --exclude="*" src output/.
mv output/src output/include
zip -r libBulletAll.zip output
