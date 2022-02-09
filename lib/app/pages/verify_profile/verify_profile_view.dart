import 'dart:io';

import 'package:dazle/domain/entities/user.dart';
import 'package:image_picker/image_picker.dart';

import 'verify_profile_controller.dart';
import 'package:dazle/app/pages/settings/settings_view.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_richtext.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/app/widgets/listing/listing_property_list_tile.dart';
import 'package:dazle/data/repositories/data_profile_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'components/verify_profile_widgets.dart';
import 'package:dotted_border/dotted_border.dart';

class VerifyProfilePage extends View {
  final String userPosition;

  VerifyProfilePage({@required this.userPosition});

  @override
  _VerifyProfilePageState createState() => _VerifyProfilePageState();
}

class _VerifyProfilePageState
    extends ViewState<VerifyProfilePage, VerifyProfileController> {
  _VerifyProfilePageState()
      : super(VerifyProfileController(DataProfileRepository()));

  List<String> _salesPersonRequirements = [
    'PRC Salesperson ID',
    'PRC salesperson application form copy',
    'PRC Accreditations Certificate',
    'Certification from Realty company or Broker'
  ];
  List<String> _brokerRequirements = ['PRC Real Estate Broker’s ID'];

  File _image;
  final picker = ImagePicker();

  /// Take a photo
  Future takePicture() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  /// Upload from device
  Future uploadFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: CustomText(
          text: 'Verify your Profile',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
                icon: Icon(
                  Icons.more_horiz_sharp,
                  color: App.textColor,
                ),
                iconSize: 30,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (buildContext) => SettingsPage()));
                }),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<VerifyProfileController>(
        builder: (context, controller) {
          return SingleChildScrollView(
            child: Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(51, 212, 157, 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(20.0),
                    child: CustomText(
                      text:
                          'If you want to verify your account, you need to choose and upload one document from the given requirements.',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(height: 22.0),
                  CustomText(
                    text: 'Choose 1 ID/Certificate',
                    textAlign: TextAlign.left,
                    fontSize: 12.0,
                    color: App.hintColor,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 22.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: VerifyProfileWidgets().requirementsGenerator(
                        widget.userPosition == 'Broker'
                            ? _brokerRequirements
                            : _salesPersonRequirements),
                  ),
                  SizedBox(height: 33.0),
                  Center(
                    child: DottedBorder(
                      color: App.hintColor,
                      strokeWidth: 1,
                      dashPattern: [6, 3, 6, 3],
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Image(
                              image: _image == null
                                  ? AssetImage('assets/upload_1.png')
                                  : FileImage(_image),
                              width: _image == null ? 77 : 150,
                              // height: 200,
                            ),
                            SizedBox(height: 14.0),
                            CustomText(
                              text:
                                  'How do you wish to upload your ID/Certificate',
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: App.hintColor,
                            ),
                            SizedBox(height: 14.0),
                            CustomButton(
                                text: 'Take a picture',
                                width: 224,
                                borderRadius: 30,
                                onPressed: () async {
                                  takePicture();
                                }),
                            SizedBox(height: 12.0),
                            CustomText(
                              text: 'OR',
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: App.hintColor,
                            ),
                            SizedBox(height: 12.0),
                            CustomButton(
                                text: 'Upload from this device',
                                width: 224,
                                borderRadius: 30,
                                onPressed: () async {
                                  uploadFromGallery();
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  CustomButton(
                      text: 'Submit',
                      expanded: true,
                      onPressed: () {
                        controller.attachement = _image;
                        print(controller.attachement);
                        controller.createRequestVerificaiton();
                      }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
