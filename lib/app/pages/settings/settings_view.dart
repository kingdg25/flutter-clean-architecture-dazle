import 'package:dazle/app/pages/settings/settings_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/data/repositories/data_settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class SettingsPage extends View {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}


class _SettingsPageState extends ViewState<SettingsPage, SettingsController> {
  _SettingsPageState() : super(SettingsController(DataSettingsRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: CustomAppBar(
        title: 'Settings',
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
          child: Column(
            children: [
              SizedBox(height: 40),
              Container(
                alignment: Alignment.center,
                child: CustomButton(
                  text: 'Sign Out',
                  expanded: true,
                  backgroudColor: Color.fromRGBO(229, 229, 229, 1.0),
                  textColor: App.textColor,
                  onPressed: () {}
                ),
              )
            ]
          )
        )
      )
    );
  }
}