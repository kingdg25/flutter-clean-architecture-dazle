import 'package:dazle/app/pages/invites/invites_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class InvitesListTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    InvitesController controller = FlutterCleanArchitecture.getController<InvitesController>(context);

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // padding: EdgeInsets.symmetric(horizontal: 10.0),
      itemCount: controller.invites.length,
      itemBuilder: (BuildContext context, int index){
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: App.hintColor,
                width: 0.3,
              )
            )
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
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
              text: '${controller.invites[index].totalConnection} connections on ${App.name}',
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
