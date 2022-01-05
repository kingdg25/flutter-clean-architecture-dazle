import 'dart:typed_data';
import 'dart:convert' as convert;

import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/title_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';


class AppConstant{

  static showLoader(BuildContext context, bool show){
    try {
      show ? Loader.show(context) : 
      Future.delayed(Duration(milliseconds: 10), () {
        Loader.hide();
      });
    } catch (e) {
      print('show loader err $e');
    }
  }
  
  static statusDialog({
    BuildContext context,
    bool success = false,
    String title,
    String text,
    Function onPressed
  }){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          actionsPadding: EdgeInsets.all(20.0),
          title: CustomText(
            text: title ?? ( success ? 'Success!' : 'Failed!' ),
            fontSize: 18.0,
            textAlign: TextAlign.center,
          ),
          content: CustomText(
            text: text ?? ( success ? 'success' : 'failed' ),
            fontSize: 13.0,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            CustomButton(
              text: 'OK',
              expanded: true,
              borderRadius: 20.0,
              onPressed: (onPressed != null) ? onPressed : () {
                Navigator.pop(context);
              },
            )
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
      )
    )
  );

  static BoxShadow boxShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.25),
    blurRadius: 4,
    offset: Offset(0, 4), // changes position of shadow
  );

  static customTitleField({
    @required String title,
    EdgeInsets padding = const EdgeInsets.only(left: 18, top: 12)
  }) {
    return Container(
      padding: EdgeInsets.only(left: 18, top: 12),
      child: TitleField(
        title: title,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static loadAssets({
    @required BuildContext context,
    List<AssetEntity> selectedAssets,
    int maxAssets = 1
  }) async {
    List<AssetEntity> assets = List<AssetEntity>();

    try {
      var result = await PhotoManager.requestPermission();

      if (result) {
        final List<AssetEntity> pickAssets = await AssetPicker.pickAssets(
          context,
          maxAssets: maxAssets,
          requestType: RequestType.image,
          textDelegate: EnglishTextDelegate(),
          selectedAssets: selectedAssets
        );

        if( pickAssets != null ) {
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

  static initializeAssetImages({
    @required List<AssetEntity> images
  }) async {
    List files = [];

    await Future.forEach(images, (AssetEntity data) async {
      Uint8List bytes = await data.originBytes;
      String fileName = await data.titleAsync;
      String base64Image = convert.base64Encode(bytes);

      files.add({
        "name": fileName,
        "image": base64Image,
      });
    });

    return files;
  }

}