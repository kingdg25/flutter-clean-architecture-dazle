import 'package:dazle/app/pages/profile/profile_controller.dart';
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
      body: Center(
        child: Text('profile page'),
      ),
    );
  }
}