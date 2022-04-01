import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert' as convert;
import 'package:dazle/data/constants.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/title_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AppConstant {
  static showLoader(BuildContext context, bool show) {
    try {
      show
          ? Loader.show(context)
          : Future.delayed(Duration(milliseconds: 10), () {
              Loader.hide();
            });
    } catch (e) {
      print('show loader err $e');
    }
  }

  static Future statusDialog(
      {required BuildContext context,
      bool success = false,
      String? title,
      String? text,
      Function? onPressed}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          actionsPadding: EdgeInsets.all(20.0),
          title: CustomText(
            text: title ?? (success ? 'Success!' : 'Failed!'),
            fontSize: 18.0,
            textAlign: TextAlign.center,
          ),
          content: CustomText(
            text: text ?? (success ? 'success' : 'failed'),
            fontSize: 13.0,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            CustomButton(
              text: 'OK',
              expanded: true,
              borderRadius: 20.0,
              onPressed: (onPressed != null)
                  ? onPressed
                  : () {
                      Navigator.pop(context);
                    },
            )
          ],
        );
      },
    );
  }

  static Future deleteDialog(
      {required BuildContext context,
      required String title,
      required String text,
      required Function onConfirm}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          actionsPadding: EdgeInsets.all(20.0),
          title: CustomText(
            text: title,
            fontSize: 18.0,
            textAlign: TextAlign.center,
          ),
          content: CustomText(
            text: text,
            fontSize: 13.0,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            CustomButton(
              text: 'Confirm',
              expanded: true,
              borderRadius: 20.0,
              onPressed: onConfirm,
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              text: 'Cancel',
              main: false,
              expanded: true,
              borderRadius: 20.0,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static Decoration bottomBorder = BoxDecoration(
      border: Border(
          bottom: BorderSide(
    color: App.hintColor,
    width: 0.3,
  )));

  static BoxShadow boxShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.25),
    blurRadius: 4,
    offset: Offset(0, 4), // changes position of shadow
  );

  static customTitleField(
      {required String title,
      EdgeInsets padding = const EdgeInsets.only(left: 18, top: 12)}) {
    return Container(
      padding: EdgeInsets.only(left: 18, top: 12),
      child: TitleField(
        title: title,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static loadAssets(
      {required BuildContext context,
      List<AssetEntity>? selectedAssets,
      int maxAssets = 1}) async {
    List<AssetEntity> assets = <AssetEntity>[];

    try {
      var result = await PhotoManager.requestPermission();

      if (result) {
        final List<AssetEntity>? pickAssets = await AssetPicker.pickAssets(
            context,
            maxAssets: maxAssets,
            requestType: RequestType.image,
            textDelegate: EnglishTextDelegate(),
            selectedAssets: selectedAssets);

        if (pickAssets != null) {
          assets = pickAssets;
        }
      } else {
        // fail
        /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
      }
    } catch (e) {
      print('loadAssets error $e');
    }

    return assets;
  }

  static initializeAssetImages({required List<AssetEntity> images}) async {
    List files = [];

    await Future.forEach(images, (AssetEntity data) async {
      Uint8List? bytes = await (data.originBytes);
      String fileName = await data.titleAsync;
      String base64Image = convert.base64Encode(bytes as List<int>);

      files.add({
        "name": fileName,
        "image": base64Image,
      });
    });

    return files;
  }

  Future<String?> getFileUrl({required File attachment}) async {
    String? imageUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Uint8List imageBytes = await attachment.readAsBytes();
    String base64Asset = convert.base64Encode(imageBytes);
    String fileName = basename(attachment.path);

    _checkFileSize(base64: base64Asset, fileName: fileName);

    //* Image Compress
    Uint8List compressedImageBytes =
        await AppConstant().compressImage(attachment);
    String compressedBase64Asset = convert.base64Encode(compressedImageBytes);
    print('Printing Compressed File size:');
    print(compressedImageBytes.length / 1000000);

    var response = await http.post(
        Uri.parse("${Constants.siteURL}/api/s3/upload-file-from-base64"),
        body: convert.jsonEncode(
            {"filename": fileName, "base64": compressedBase64Asset}),
        headers: {
          'Authorization': 'Bearer ${prefs.getString("accessToken")}',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });
    var jsonResponse = await convert.jsonDecode(response.body);

    if (response.statusCode == 200) {
      imageUrl = jsonResponse['data']['file_url'];
    } else {
      throw {
        "error": true,
        "error_type": "server_error",
        "status": "Request Verificaiton not created."
      };
    }

    return imageUrl;
  }

  void _checkFileSize({required String base64, String? fileName}) {
    Uint8List bytes = convert.base64Decode(base64);
    double sizeInMB = bytes.length / 1000000;
    double maxFileSize = 10.0;

    print('Max file size: $maxFileSize mb');
    if (sizeInMB > maxFileSize) {
      throw {
        "error": false,
        "error_type": "filesize_error",
        "status":
            "File size must not exceed ${maxFileSize}mb. A file $fileName has a size of ${sizeInMB.toStringAsFixed(2)} MB."
      };
    }
  }

  Future<Uint8List> compressImage(File file) async {
    var compressedResult = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 90,
    );
    print(file.lengthSync());
    print(compressedResult!.length);
    return compressedResult;
  }
}
