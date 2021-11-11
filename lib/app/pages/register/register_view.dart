import 'package:dwellu/app/utils/dwellu.dart';
import 'package:dwellu/app/widgets/form%20fields/custom_field_layout.dart';
import 'package:dwellu/app/widgets/form%20fields/custom_icon_button.dart';
import 'package:dwellu/app/widgets/form%20fields/custom_select_field.dart';
import 'package:dwellu/app/widgets/form%20fields/custom_text_field.dart';
import 'package:dwellu/app/widgets/form%20fields/title_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dwellu/app/pages/register/register_controller.dart';
import 'package:dwellu/data/repositories/data_authentication_repository.dart';
import 'package:dwellu/app/widgets/custom_appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';



class RegisterPage extends View {
  static const String id = 'register_page';

  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}


class _RegisterPageState extends ViewState<RegisterPage, RegisterController> {
  _RegisterPageState() : super(RegisterController(DataAuthenticationRepository()));

  @override
  Widget get view {
    return Scaffold(
      key: globalKey,
      appBar: CustomAppBar(
        title: 'Create an Account',
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ControlledWidgetBuilder<RegisterController>(
        builder: (context, controller) {
          Size size = MediaQuery.of(context).size;

          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 50.0),
            child: Column(
              children: [
                SizedBox(
                  height: size.height,
                  child: Stack(
                    overflow: Overflow.visible,
                    children: [
                      Container(
                        height: size.height * 0.33,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: FractionalOffset.bottomCenter,
                                  end: FractionalOffset.topCenter,
                                  colors: [Dwellu.appMainColor, Color.fromRGBO(229, 250, 243, 0.9)]
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30.0),
                                  bottomRight: Radius.circular(30.0)
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 200,
                                height: 200,
                                child: SvgPicture.asset('assets/create_account.svg')
                              )
                            ),
                          ]
                        ),
                      ),
                      Positioned(
                        top: size.height * 0.31,
                        left: 0,
                        right: 0,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 40.0),  
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 5,
                                color: Color.fromRGBO(0, 0, 0, 0.25)
                              )
                            ]
                          ),
                          child: Form(
                            child: Column(
                              children: [
                                TitleField(
                                  title: 'Enter Full Name'
                                ),
                                CustomFieldLayout(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: CustomTextField(
                                          hintText: 'First Name',
                                        ),
                                      ),
                                      SizedBox(width: 8.0),
                                      Flexible(
                                        child: CustomTextField(
                                          hintText: 'Last Name',
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                                TitleField(
                                  title: 'Enter Mobile Number'
                                ),
                                CustomTextField(
                                  hintText: '+63',
                                ),
                                TitleField(
                                  title: 'I am a'
                                ),
                                CustomSelectField(
                                  isRequired: true, 
                                  value: null,
                                  items: ['Real Estate Broker', 'Real Estate Salesperson'],
                                  onChanged: (val) {
                                    print(val);
                                  },
                                ),
                                TitleField(
                                  title: 'Enter your License #'
                                ),
                                CustomTextField(
                                  hintText: 'Enter your License #',
                                ),
                                SizedBox(height: 20.0),
                                CustomIconButton(
                                  iconData: Icons.arrow_right_alt,
                                  onPressed: () {},
                                )
                              ],
                            ),
                          ),
                        )
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
      )
    );
  }
  
}