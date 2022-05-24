import 'package:flutter/material.dart';

import '../../../../domain/entities/property.dart';
import '../../../../domain/entities/user.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/profile/profile_info.dart';

class ProfileWidget extends StatelessWidget {
  final User? user;
  final List<Property>? listings;
  const ProfileWidget({Key? key, this.user, this.listings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My Profile",
      ),
      body: Container(
        child: SingleChildScrollView(
          child: ProfileInfo(
            user!,
            listings: listings!,
          ),
        ),
      ),
    );
  }
}
