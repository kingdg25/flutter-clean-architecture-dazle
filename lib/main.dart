// import 'package:device_preview/device_preview.dart';
import 'package:dazle/app/pages/login/login_view.dart';
import 'package:dazle/app/pages/main/main_view.dart';
import 'package:dazle/app/pages/register/register_view.dart';
import 'package:dazle/app/pages/welcome/welcome_page.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:month_year_picker/month_year_picker.dart';

import 'app/pages/chat/chat_view.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

/// For Testing different screen devices
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(
//     DevicePreview(
//       enabled: true,
//       builder: (context) => MyApp(),
//     ),
//   );
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterCleanArchitecture.debugModeOn();
    AppConstant.mixPanelInit();

    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      builder: EasyLoading.init(),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.id,
      routes: {
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        WelcomePage.id: (context) => WelcomePage(),
        MainPage.id: (context) => MainPage(),
        ChatPage.id: (context) => ChatPage(),
      },
      // locale: DevicePreview.of(context).locale, // <--- /!\ Add the locale
      // builder: DevicePreview.appBuilder, // <--- /!\ Add the builder
    );
  }
}
