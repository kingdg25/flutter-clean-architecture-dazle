import 'package:dazle/app/pages/profile/profile_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/data/repositories/data_profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class ProfilePage extends View {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}


class _ProfilePageState extends ViewState<ProfilePage, ProfileController> {
  _ProfilePageState() : super(ProfileController(DataProfileRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: CustomText(
          text: 'Profile',
          fontSize: 18,
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
                print("Hello");
              }
            ),
          ),
          ControlledWidgetBuilder<ProfileController>(
            builder: (context, controller) {
              return Container(
                padding: EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: Icon(Icons.logout, color: Colors.black),
                  onPressed: () {
                    print("Logout");
                    controller.userLogout();
                  }
                ),
              );
            }
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Text('profile page'),
      ),
    );
  }
}