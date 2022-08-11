import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazle/app/pages/edit_profile/edit_profile_view.dart';
import 'package:dazle/app/widgets/custom_progress_bar.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/property.dart';
import '../../../domain/entities/user.dart';
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
  double progressValue = .25;
  bool showProgressBar = false;

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

  void showHideProgressBar() {
    if (showProgressBar) {
      showProgressBar = false;
    } else {
      showProgressBar = true;
    }
    setState(() {});
  }

  void setProgressBarValue(double newProgressValue) {
    progressValue = newProgressValue;
    setState(() {});
  }

  String progressPercentage() {
    double initial = progressValue / 1;
    double percent = initial * 100;

    return '$percent';
  }

  bool get isCurrentUser => _currentUser!.id == widget.user.id;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _currentUser == null
            ? Container()
            : Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
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
                          backgroundImage:
                              AssetImage('assets/user_profile.png'),
                        ),
                      ),
                    ),
                    CustomText(
                      text: widget.user.displayName,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                            text: 'Edit Profile',
                            width: 120,
                            borderRadius: 10,
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (buildContext) => EditProfilePage(
                                    user: _currentUser,
                                  ),
                                ),
                              );
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
                    // SizedBox(height: 10),
                    isCurrentUser
                        ? Container()
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
                        page: 'Profile Page',
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        isCurrentUser: isCurrentUser,
                      ),
                    )
                  ],
                ),
              ),
        //  SafeArea(
        //       child: controller.showProgressBar == false
        //           ? Container()
        //           : Positioned(
        //               top: 0,
        //               left: 0,
        //               child: Container(
        //                 // color: Color.fromARGB(162, 154, 160, 166),
        //                 color: Colors.white,
        //                 width: MediaQuery.of(context).size.width,
        //                 height: MediaQuery.of(context).size.height,
        //                 // height: MediaQuery.of(context).size.height,
        //                 child: Center(
        //                   child: Column(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     crossAxisAlignment: CrossAxisAlignment.center,
        //                     children: [
        //                       Image(
        //                           image: AssetImage(
        //                               'assets/icons/dazle_icon.png')),
        //                       SizedBox(
        //                         height: 10,
        //                       ),
        //                       Container(
        //                         height: 50,
        //                         width:
        //                             MediaQuery.of(context).size.width * 0.70,
        //                         alignment: Alignment.center,
        //                         child: CustomProgressBar(
        //                           text:
        //                               'Generating PDF ${controller.progressPercentage()}%',
        //                           progressValue: controller.progressValue,
        //                         ),
        //                       ),
        //                       CustomText(
        //                         text: 'Generating PDF . . . .',
        //                         fontWeight: FontWeight.bold,
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             )),
      ],
    );
  }
}
