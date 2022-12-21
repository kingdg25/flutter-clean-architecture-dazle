#!/usr/bin/env bash
VERSION=$(curl -g https://asia-east1-dazle-370306.cloudfunctions.net/getAppVersion?company=sample-document | python3 -c "import sys, json; print(json.load(sys.stdin)['dazleVersion'])")
BUILD_NUMBER=$(($VERSION))
BUILD_VERSION=$(( $BUILD_NUMBER + 900))
BUILD_NAME="11.0.$BUILD_NUMBER"
BUILD_ENV="prod"
BUILD_CHANGELOG_ANDROID="android/fastlane/metadata/android/en-US/changelogs/$BUILD_VERSION.txt"
BUILD_CHANGELOG_ANDROID_CURRENT="$CI_PROJECT_DIR/current.txt"
BUILD_CHANGELOG_IOS="ios/fastlane/metadata/en-US/release_notes.txt"

echo "================"
echo $BUILD_NUMBER
echo $BUILD_NAME
echo $BUILD_VERSION
echo $CI_PROJECT_DIR
echo $BUILD_CHANGELOG_ANDROID_CURRENT
echo "================"

fvm flutter channel stable
fvm flutter upgrade
yes | fvm use stable
fvm flutter clean
fvm flutter precache --ios
yes | fvm flutter doctor --android-licenses
fvm flutter pub get
fvm flutter analyze || exit 1
sed -i '' "s/#{VERSION}/$BUILD_NAME.$BUILD_ENV/g" $CI_PROJECT_DIR/lib/Api/version.dart



# ==========================
# Start Android Sripts
# ==========================

cd android
bundle config path $HOME/.gem/ruby
rm Gemfile.lock
bundle install
bundle update fastlane
bundle update
bundle exec fastlane update_plugins
yes | fvm flutter doctor --android-licenses
./gradlew clean assembleRelease
cd ..
fvm flutter build appbundle --build-name=$BUILD_NAME --build-number=$BUILD_VERSION --no-tree-shake-icons
python scripts/helpers/extract_git.py > $BUILD_CHANGELOG_ANDROID
python scripts/helpers/extract_git.py > $BUILD_CHANGELOG_ANDROID_CURRENT
CONTENT=`cat $BUILD_CHANGELOG_ANDROID`
python scripts/helpers/replace.py android/fastlane/Fastfile "#{NOTES}" "$CONTENT"
python scripts/helpers/replace.py android/fastlane/Fastfile "#{VERSION}" "$BUILD_NAME"
cp $BUILD_CHANGELOG_ANDROID_CURRENT $CI_PROJECT_DIR/en-US.txt
echo "====================================="
cat $BUILD_CHANGELOG_ANDROID
echo "====================================="
cat $BUILD_CHANGELOG_ANDROID_CURRENT
echo "====================================="
echo $BUILD_CHANGELOG_ANDROID_CURRENT
echo $BUILD_CHANGELOG_ANDROID
echo "====================================="
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
echo $CI_PROJECT_DIR/en-US.txt
cat $CI_PROJECT_DIR/en-US.txt
echo "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

cd android

bundle exec fastlane supply --aab ../build/app/outputs/bundle/release/app-release.aab --track production --skip_upload_metadata true --skip_upload_images true --skip_upload_screenshot true
# bundle exec fastlane app_gallery

# ==========================
# End Android Sripts
# ==========================



# ==========================
# Start iOS Sripts
# ==========================

# python scripts/helpers/extract_git.py > $BUILD_CHANGELOG_IOS
# echo "=========== IOS =================="
# cat $BUILD_CHANGELOG_IOS
# echo "====================================="
# cd ..
# sed -i '' "s/#{BUILD}/$BUILD_NAME/g" $CI_PROJECT_DIR/ios/fastlane/Fastfile
# cd ios
# rm Gemfile.lock
# bundle install
# bundle exec fastlane update_plugins

# bundle update fastlane
# bundle update

# bundle exec fastlane match appstore --readonly false --force
# bundle exec fastlane match adhoc --readonly false --force
# bundle exec fastlane match development --readonly false --force

# rm Podfile.lock
# pod install
# bundle exec fastlane production --verbose

# ==========================
# End iOS Sripts
# ==========================
