import 'package:dazle/app/pages/home/home_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/app/widgets/form_fields/custom_icon_button.dart';
import 'package:dazle/data/repositories/data_todo_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';



class WelcomePage extends View {
  static const String id = 'welcome_page';
  
  WelcomePage({ Key key }) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ViewState<WelcomePage, HomeController> {
  _WelcomeScreenState() : super(HomeController(DataTodoRepository()));

  @override
  Widget get view {
    
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<HomeController>(
        builder: (context, controller) {

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).orientation == Orientation.landscape ? 80.0 : 20.0,
                bottom: 40.0,
                left: 40.0,
                right: 40.0
              ),
              child: Container(
                constraints: BoxConstraints(maxWidth: 300, minWidth: 250),
                child: Column(
                  children: [
                    Container(
                      child: Image(
                        image: AssetImage('assets/welcome.png')
                      ),
                    ),
                    CustomText(
                      text: 'Welcome to ${App.name}',
                      fontSize: 28.0,
                      fontWeight: FontWeight.w600,
                      textAlign: TextAlign.center,
                    ),
                    CustomText(
                      text: "You’re ${controller.user.firstName}'s connection!",
                      fontSize: 20.0,
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      child: Image(
                        image: AssetImage('assets/profile.png'),
                        width: 180,
                        height: 180,
                      ),
                    ),
                    CustomText(
                      text: controller.user.displayName,
                      fontSize: 22.0,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30.0),
                    CustomFieldLayout(
                      child: CustomIconButton(
                        onPressed: () {
                          controller.isNewUser();
                        }
                      )
                    )
                  ]
                )
              )
            ),
          );
        
        }
      )
    );
  }
}