import 'package:dazle/app/pages/notify_user/notify_user_controller.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/app/widgets/custom_form_layout.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_email_field.dart';
import 'package:dazle/app/widgets/form_fields/custom_text_field.dart';
import 'package:dazle/app/widgets/form_fields/title_field.dart';
import 'package:dazle/data/repositories/data_connection_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class NotifyUserPage extends View {
  NotifyUserPage({Key key}) : super(key: key);

  @override
  _NotifyUserPageState createState() => _NotifyUserPageState();
}


class _NotifyUserPageState extends ViewState<NotifyUserPage, NotifyUserController> {
  _NotifyUserPageState() : super(NotifyUserController(DataConnectionRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: CustomAppBar(
        title: 'Notify User',
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<NotifyUserController>(
        builder: (context, controller) {
          var _formKey = controller.notifyUserFormKey;

          return Center(
            child: SingleChildScrollView(
              child: CustomFormLayout(
                margin: EdgeInsets.only(left: 43.0, right: 43.0, bottom: 40.0),
                formKey: _formKey,
                child: Column(
                  children: [
                    TitleField(
                      title: 'Email Address'
                    ),
                    CustomEmailField(
                      controller: controller.emailTextController,
                      hintText: 'Email Address'
                    ),
                    TitleField(
                      title: 'Enter Mobile Number'
                    ),
                    CustomTextField(
                      controller: controller.mobileNumberTextController,
                      hintText: '+63',
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 20.0),
                    CustomButton(
                      text: 'Notify User',
                      expanded: true,
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          
                          controller.notifyUser();
                        }
                      }
                    )
                  ],
                )
              )
            ),
          );
        
        }
      )
    );
  }
}