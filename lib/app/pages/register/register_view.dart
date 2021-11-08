import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dwellu/app/pages/register/register_controller.dart';
import 'package:dwellu/data/repositories/data_authentication_repository.dart';



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
      appBar: AppBar(
        title: Text('Registration Form'),
      ),
      body: ControlledWidgetBuilder<RegisterController>(
        builder: (context, controller) {
          var _formKey = controller.registerFormKey;

          return Form(
            key: _formKey,
            child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 70.0),
                  child: TextFormField(
                    controller: controller.firstNameTextController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      hintText: 'Input your First Name',
                    ),
                    validator: (value) {
                      if (value.length < 1 || value == null)
                        return "Enter your first name";
                      else
                        return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 70.0),
                  child: TextFormField(
                    controller: controller.lastNameTextController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      hintText: 'Input your Last Name',
                    ),
                    validator: (value) {
                      if (value.length < 1 || value == null)
                        return "Enter your last name";
                      else
                        return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 70.0),
                  child: TextFormField(
                    controller: controller.emailTextController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Input your Email Address',
                    ),
                    validator: (value) {
                      Pattern emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = new RegExp(emailPattern);
                      if (!regex.hasMatch(value))
                        return 'Enter Valid Email';
                      else
                        return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 70.0),
                  child: TextFormField(
                    controller: controller.passwordTextController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Input your Password',
                    ),
                    validator: (value) {
                      if (value.length < 1 || value == null)
                        return "Enter your password";
                      else if (value.length < 5)
                        return "Password must be at least 5 characters";
                      else
                        return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(  
                      child: Text('Register', style: TextStyle(fontSize: 20.0)), 
                      onPressed: () {
                        print('register user');
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          controller.register();
                        }
                      },  
                    ),
                  ],
                ),
                
              ],
            ),
          );
        }
      ),
    );
  }
  
}