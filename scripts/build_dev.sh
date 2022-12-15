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
./gradlew clean assembleRelease
fvm flutter build appbundle --build-name=$BUILD_NAME --build-number=$BUILD_VERSION --no-tree-shake-icons
# bundle exec fastlane supply --aab ../build/app/outputs/bundle/release/app-release.aab --track internal
# python script/helpers/replace.py ios/fastlane/Fastfile "#{BUILD}" "$BUILD_NAME"
# cd $CI_PROJECT_DIR/ios/
# rm Gemfile.lock
# bundle install
# bundle update fastlane
# bundle update
# rm Podfile.lock
# pod install
# cp $CI_PROJECT_DIR/ios/GoogleService-staging.plist $CI_PROJECT_DIR/ios/GoogleService-Info.plist
# cp $CI_PROJECT_DIR/ios/Runner/GoogleService-staging.plist $CI_PROJECT_DIR/ios/Runner/GoogleService-Info.plist
# cp $CI_PROJECT_DIR/ios/Runner/GoogleService-staging.plist $CI_PROJECT_DIR/ios/GoogleService-Info.plist
# fastlane staging --verbose
# cd $CI_PROJECT_DIR
# python $CI_PROJECT_DIR/script/helpers/upload_release_dev.py $BUILD_NAME && python $CI_PROJECT_DIR/script/helpers/upload_release_dev_ios.py $BUILD_NAME && curl https://us-central1-kahero-8dfde.cloudfunctions.net/setPOSVersion
     # curl https://asia-east1-pc-api-6370064079833342368-769.cloudfunctions.net/incrementAppVersion?school=sample-school