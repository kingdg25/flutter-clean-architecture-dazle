import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../pages/profile/profile_controller.dart';
import '../../utils/app.dart';
import '../custom_text.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(
      {Key? key,
      required this.icon,
      required this.title,
      this.tapHandler,
      required this.color,
      this.colorIcon = Colors.white})
      : super(key: key);

  final IconData icon;
  final String title;
  final Function? tapHandler;
  final Color color;
  final Color? colorIcon;

  @override
  Widget build(BuildContext context) {
    ProfileController controller =
        FlutterCleanArchitecture.getController<ProfileController>(context);
    return InkWell(
      onTap: () => tapHandler!(),
      child: Container(
        padding: EdgeInsets.all(
          controller.getProportionateScreenWidth(8.0),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              color: App.mainColor.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(
                controller.getProportionateScreenWidth(4.0),
              ),
              decoration: ShapeDecoration(
                color: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    controller.getProportionateScreenWidth(8.0),
                  ),
                ),
              ),
              child: Container(
                height: 18,
                child: Icon(
                  icon,
                  size: 18,
                  color: colorIcon,
                ),
              ),
            ),
            SizedBox(
              width: controller.getProportionateScreenWidth(8.0),
            ),
            Expanded(
              child: CustomText(
                text: title,
                fontSize: 14,
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}
