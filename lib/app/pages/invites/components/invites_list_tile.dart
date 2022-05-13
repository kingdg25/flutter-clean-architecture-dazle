import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../utils/app.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/form_fields/custom_button.dart';
import '../../../widgets/loading/custom_shimmer_list_tile.dart';
import '../invites_controller.dart';

class InvitesListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    InvitesController controller =
        FlutterCleanArchitecture.getController<InvitesController>(context);

    // before display the data it'll check if there is an error
    // and if the data is still fetching
    if (controller.error) {
      return Center(
        child: CustomButton(
          onPressed: controller.refreshUi,
          text: "Failed to Load. try again",
        ),
      );
    }
    if (controller.isLoading == true) {
      return CustomShimmerListTile(isMyConnection: false);
    }
// #=============================================================
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // padding: EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: controller.invites.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            leading: Image.asset(
              'assets/icons/user.png',
              height: 40,
            ),
            title: CustomText(
              text: controller.invites[index].displayName,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            subtitle: CustomText(
              text:
                  '${controller.invites[index].totalConnection} connections on ${App.name}',
              fontSize: 11,
            ),
            trailing: Container(
              width: 80,
              child: CustomButton(
                text: 'Invite',
                fontSize: 12,
                borderRadius: 20,
                height: 32,
                onPressed: () {
                  controller.addConnection(controller.invites[index]);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
