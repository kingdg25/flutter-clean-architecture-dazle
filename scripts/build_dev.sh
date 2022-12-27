#!/usr/bin/env bash
VERSION=$(curl -g https://asia-east1-dazle-370306.cloudfunctions.net/getAppVersion?company=sample-document | python3 -c "import sys, json; print(json.load(sys.stdin)['dazleVersion'])")
BUILD_NUMBER=$(( $VERSION ))
BUILD_VERSION=$(( $BUILD_NUMBER + 900))
BUILD_NAME="2.0.$BUILD_NUMBER"
BUILD_ENV="dev"
echo "================"
echo $BUILD_NUMBER
echo $BUILD_NAME
echo $BUILD_VERSION
echo $CI_PROJECT_DIR
echo "================"


fvm flutter channel stable
fvm flutter upgrade
yes | fvm use stable
fvm flutter clean
fvm flutter precache --ios
fvm flutter doctor
fvm flutter pub get
yes | fvm flutter doctor --android-licenses
fvm flutter analyze || exit 1
sed -i '' "s/#{VERSION}/$BUILD_NAME.$BUILD_ENV/g" $CI_PROJECT_DIR/lib/version.dart
cd android
rm Gemfile.lock
# ./gradlew clean assembleRelease
fvm flutter build appbundle --build-name=$BUILD_NAME --build-number=$BUILD_VERSION --no-tree-shake-icons
bundle exec fastlane supply --aab ../build/app/outputs/bundle/release/app-release.aab --track internal 

# cd ..
# python scripts/helpers/replace.py ios/fastlane/Fastfile "#{BUILD}" "$BUILD_NAME"
# cd $CI_PROJECT_DIR/ios/
# rm Gemfile.lock
# bundle install
# bundle update fastlane
# bundle update
# rm Podfile.lock
# pod install
# fastlane staging --verbose
curl https://asia-east1-dazle-370306.cloudfunctions.net/incrementAppVersion?company=sample-document