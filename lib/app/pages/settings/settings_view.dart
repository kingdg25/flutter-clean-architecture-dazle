import 'package:dazle/app/pages/settings/components/settings_list_tile.dart';
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
      body: ControlledWidgetBuilder<SettingsController>(
        builder: (context, controller) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                SettingsListTile(
                  text: 'Help Center',
                  onTap: () {},
                ),
                SettingsListTile(
                  text: 'Privacy Policy',
                  onTap: () {},
                ),
                SettingsListTile(
                  text: 'Accessibility',
                  onTap: () {},
                ),
                SettingsListTile(
                  text: 'User Agreement',
                  onTap: () {},
                ),
                SettingsListTile(
                  text: 'End User License Agreement',
                  onTap: () {},
                ),
                SizedBox(height: 40),
                Container(
                  alignment: Alignment.center,
                  child: CustomButton(
                    text: 'Sign Out',
                    expanded: true,
                    backgroudColor: Color.fromRGBO(229, 229, 229, 1.0),
                    textColor: App.textColor,
                    onPressed: () {
                      controller.signOut();
                    }
                  ),
                )
              ]
            )
          );
        }
      )
    );
  }
}