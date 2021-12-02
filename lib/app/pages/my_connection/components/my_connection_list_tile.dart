import 'package:dazle/app/pages/my_connection/my_connection_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MyConnectionListTile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    MyConnectionController controller = FlutterCleanArchitecture.getController<MyConnectionController>(context);

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.myConnection.length,
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
              text: controller.myConnection[index].displayName,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: controller.myConnection[index].position,
                  fontSize: 11,
                ),
                CustomText(
                  text: controller.myConnection[index].dateConnected,
                  fontSize: 11,
                  color: App.hintColor,
                )
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 90,
                  child: CustomButton(
                    text: 'Message',
                    main: false,
                    fontSize: 12,
                    borderRadius: 20,
                    height: 32,
                    onPressed: () {
                      print('on pressed data ${controller.myConnection[index].displayName}');
                    },
                  ),
                ),
                SizedBox(width: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child : Material(
                    child : InkWell(
                      child : Padding(
                        padding : const EdgeInsets.all(5),
                        child : Icon(
                          Icons.more_horiz,
                        ),
                      ),
                      onTap : () {},
                    ),
                  ),
                )
              ],
            )
          ),
        );
      },
    );
  }
}
