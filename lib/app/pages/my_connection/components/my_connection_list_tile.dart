import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:flutter/material.dart';

class MyConnectionListTile extends StatelessWidget {
  final Function onPressed;


  MyConnectionListTile({
    this.onPressed
  });


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 8,
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
              text: 'Juan dela Cruz',
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: 'Licensed Real Estate Broker',
                  fontSize: 11,
                ),
                CustomText(
                  text: 'Connected yesterday',
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
                      onPressed();
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
