import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/property.dart';
import '../../../domain/entities/user.dart';
import '../../pages/edit_profile/edit_profile_view.dart';
import '../../utils/app.dart';
import '../custom_text.dart';
import '../form_fields/custom_button.dart';
import '../form_fields/custom_field_layout.dart';
import '../listing/listing_property_list_tile.dart';

class ProfileWidget extends StatelessWidget {
  final User user;
  final List<Property> listings;
  const ProfileWidget(this.user, this.listings, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
      child: Column(children: [
        Center(
          child: CachedNetworkImage(
            imageUrl: user.profilePicture.toString(),
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: 95,
              backgroundImage: imageProvider,
              backgroundColor: App.mainColor,
            ),
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color?>(Colors.indigo[900]),
                value: progress.progress,
              ),
            ),
            errorWidget: (context, url, error) => Center(
              child: Image.asset(
                'assets/user_profile.png',
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
        CustomText(
          text: user.displayName,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 5),
        CustomText(
          text: 'Real Estate ${user.position ?? ''}',
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 10),
        CustomFieldLayout(
          child: CustomText(
            text: user.aboutMe ?? '',
            fontSize: 11,
            color: App.hintColor,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
                text: 'Edit Profile',
                width: 120,
                borderRadius: 30,
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (buildContext) => EditProfilePage(
                        user: user,
                      ),
                    ),
                  );
                  // await controller.getCurrentUser();
                  // await controller.getUserToDisplay();
                }),
            // SizedBox(width: 8),
            // CustomButton(
            //     text: 'Share Profile',
            //     width: 120,
            //     borderRadius: 30,
            //     main: false,
            //     onPressed: () async {
            //       await Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (buildContext) => ProfilePage()));
            //     })
          ],
        ),
        SizedBox(height: 20),
        CustomFieldLayout(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  CustomText(
                    text: listings.isEmpty ? '' : '${listings.length}',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: 'LISTING',
                    fontSize: 10,
                    color: App.hintColor,
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
              SizedBox(
                height: 25,
                child: VerticalDivider(
                  color: App.hintColor,
                  thickness: 1,
                ),
              ),
              Column(
                children: [
                  CustomText(
                    text: '0',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: 'CONNECTIONS',
                    fontSize: 10,
                    color: App.hintColor,
                    fontWeight: FontWeight.w400,
                  )
                ],
              ),
              SizedBox(
                height: 25,
                child: VerticalDivider(
                  color: App.hintColor,
                  thickness: 1,
                ),
              ),
              Column(
                children: [
                  CustomText(
                    text: '0',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: 'FOLLOWING',
                    fontSize: 10,
                    color: App.hintColor,
                    fontWeight: FontWeight.w400,
                  )
                ],
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          child: ListingPropertyListTile(
            items: listings,
            height: 300.0,
            padding: EdgeInsets.symmetric(vertical: 10.0),
          ),
        )
      ]),
    );
  }
}
