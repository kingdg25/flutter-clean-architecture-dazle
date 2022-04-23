import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../utils/app.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/form_fields/custom_button.dart';
import '../../agent_profile/agent_profile_view.dart';
import '../connection_controller.dart';

class ConnectionsGridTile extends StatelessWidget {
  const ConnectionsGridTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectionController controller =
        FlutterCleanArchitecture.getController<ConnectionController>(context);
    // before display the data it'll check if there is an error
    // and if the data is still fetching
    if (controller.error) {
      return Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: CustomButton(
            onPressed: controller.refreshUi,
            text: "Failed to Load. try again",
          ),
        ),
      );
    }
    if (controller.isLoading == true) {
      return Center(
        heightFactor: 5,
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(App.mainColor),
              ),
              CustomText(text: "Loading"),
            ],
          ),
        ),
      );
    }
// #=============================================================

    // can customize to specific widget inorder to use in other matters - a
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: CustomText(
            text: "Real Estate Brokers you may know",
            fontWeight: FontWeight.w500,
          )),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.connections.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 228,
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return Card(
                elevation: 7,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (buildContext) => AgentProfilePage(
                                controller.connections[index].id,
                                controller
                                    .connections[index].connectionsFullName)));
                  },
                  splashColor: App.mainColor,
                  child: Stack(
                    children: [
                      //** reserve for the future updates
                      // Positioned(
                      //   right: 0,
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       print("ok");
                      //     },
                      //     child: Container(
                      //       margin: EdgeInsets.all(5),
                      //       child: CircleAvatar(
                      //         radius: 11.0,
                      //         backgroundColor: Colors.black54,
                      //         child: Icon(
                      //           Icons.close,
                      //           color: Colors.white,
                      //           size: 18,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 5, right: 5),
                        height: 228,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: controller
                                      .connections[index].photoURL
                                      .toString(),
                                  imageBuilder: (context, imageProvider) =>
                                      CircleAvatar(
                                    backgroundColor: App.mainColor,
                                    radius: 35,
                                    backgroundImage: imageProvider,
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation<Color?>(
                                              App.mainColor),
                                      value: progress.progress,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) {
                                    return CircleAvatar(
                                      radius: 35,
                                      backgroundImage: AssetImage(
                                        'assets/user_profile.png',
                                      ),
                                    );
                                  },
                                ),
                                FittedBox(
                                  child: Text(
                                    controller
                                        .connections[index].connectionsFullName,
                                    style: App.textStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                                controller.connections[index].aboutMe != null
                                    ? Container(
                                        padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: Text(
                                          controller.connections[index].aboutMe
                                              .toString(),
                                          maxLines: 3,
                                          style: TextStyle(
                                              color: App.hintColor,
                                              fontSize: 13),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              child: CustomButton(
                                text: 'Connect',
                                main: false,
                                fontSize: 10,
                                borderRadius: 20,
                                height: 27,
                                onPressed: () {
                                  print('test');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            scrollDirection: Axis.vertical,
          ),
        ],
      ),
    );
  }
}
