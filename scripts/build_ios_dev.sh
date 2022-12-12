#!/bin/sh
NUMBER=$(curl -g https://us-central1-kahero-8dfde.cloudfunctions.net/getPOSVersion | python -c "import sys, json; print(json.load(sys.stdin)['pos'])")
NEW_BUILD_NUMBER=$(( $NUMBER ))
BUILD_NAME="2.0.$NEW_BUILD_NUMBER"
BUILD_ENV="dev"
BUILD_CHANGELOG="$FCI_BUILD_DIR/release_notes_en-US.txt"


sed -i '' "s/#{VERSION}/$BUILD_NAME.$BUILD_ENV/g" $FCI_BUILD_DIR/lib/app/utils/version.dart
sed -i '' "s/#{BUILD}/$BUILD_ENV/g" $FCI_BUILD_DIR/lib/app/utils/build.dart

python script/helpers/extract_git.py > $BUILD_CHANGELOG

cd $FCI_BUILD_DIR/ios
agvtool new-version -all 2.0.$NEW_BUILD_NUMBER
agvtool new-marketing-version 2.0.$NEW_BUILD_NUMBER
cp $FCI_BUILD_DIR/ios/Runner/GoogleService-staging.plist $FCI_BUILD_DIR/ios/Runner/GoogleService-Info.plist
cp $FCI_BUILD_DIR/ios/Runner/GoogleService-staging.plist $FCI_BUILD_DIR/ios/GoogleService-Info.plist
cat $FCI_BUILD_DIR/ios/Runner/GoogleService-Info.plist
cat $FCI_BUILD_DIR/ios/GoogleService-Info.plist