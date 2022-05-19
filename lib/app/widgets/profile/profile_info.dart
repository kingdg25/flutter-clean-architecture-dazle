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

class ProfileInfo extends StatefulWidget {
  final User user;
  final List<Property>? listings;
  ProfileInfo(this.user, {this.listings, Key? key}) : super(key: key);

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  User? _currentUser;
  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  getCurrentUser() async {
    User user = await App.getUser();
    _currentUser = user;
    setState(() {});
  }

  bool get isCurrentUser => _currentUser!.id == widget.user.id;

  @override
  Widget build(BuildContext context) {
    return _currentUser == null
        ? Container()
        : Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
            child: Column(
              children: [
                Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.user.profilePicture.toString(),
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 95,
                      backgroundImage: imageProvider,
                      backgroundColor: App.mainColor,
                    ),
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color?>(App.mainColor),
                        value: progress.progress,
                      ),
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: App.mainColor,
                      radius: 95,
                      backgroundImage: AssetImage('assets/user_profile.png'),
                    ),
                  ),
                ),
                CustomText(
                  text: widget.user.displayName,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 5),
                CustomText(
                  text: 'Real Estate ${widget.user.position ?? ''}',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 10),
                CustomFieldLayout(
                  child: CustomText(
                    text: widget.user.aboutMe ?? '',
                    fontSize: 11,
                    color: App.hintColor,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                isCurrentUser
                    ? CustomButton(
                        text: 'Edit Profile',
                        width: 120,
                        borderRadius: 30,
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (buildContext) => EditProfilePage(
                                user: widget.user,
                              ),
                            ),
                          );
                        })
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                              text: 'Connect',
                              width: 120,
                              borderRadius: 30,
                              onPressed: () async {}),
                          SizedBox(width: 8),
                          CustomButton(
                              text: 'Message',
                              width: 120,
                              borderRadius: 30,
                              main: false,
                              onPressed: () async {})
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
                            text: widget.listings!.isEmpty
                                ? '0'
                                : '${widget.listings!.where((element) {
                                    if (isCurrentUser) return true;
                                    return (element.viewType == 'public');
                                  }).length}',
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
                    items: widget.listings,
                    height: 300.0,
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    isCurrentUser: isCurrentUser,
                  ),
                )
              ],
            ),
          );
  }
}
