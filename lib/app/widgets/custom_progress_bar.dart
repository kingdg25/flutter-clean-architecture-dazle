import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CustomProgressBar extends StatelessWidget {
  final String? text;
  final double progressValue;

  const CustomProgressBar({this.text = '', required this.progressValue});

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      // width: 140.0,
      lineHeight: 25.0,
      percent: progressValue,
      // linearGradientBackgroundColor: LinearGradient(
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //     colors: [
      //       Color.fromRGBO(224, 222, 222, 1),
      //       Color.fromRGBO(224, 222, 222, 1),
      //       Color.fromRGBO(224, 222, 222, .6),
      //       Color.fromRGBO(224, 222, 222, 1),
      //       Color.fromRGBO(224, 222, 222, 1),
      //       // Colors.white,
      //       // Color.fromRGBO(224, 222, 222, 1),
      //       // Color.fromRGBO(224, 222, 222, 1),
      //     ]),
      backgroundColor: Color.fromARGB(255, 175, 173, 173),
      progressColor: App.mainColor,
    );

    // LiquidLinearProgressIndicator(
    //   value: progressValue, // Defaults to 0.5.
    //   valueColor: AlwaysStoppedAnimation(
    //       App.mainColor), // Defaults to the current Theme's accentColor.
    //   backgroundColor:
    //       Colors.white, // Defaults to the current Theme's backgroundColor.
    //   borderColor: App.mainColor,
    //   borderWidth: 5.0,
    //   borderRadius: 12.0,
    //   direction: Axis
    //       .horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
    //   center: CustomText(
    //     text: text == '' ? 'Loading...' : text,
    //     fontSize: 16,
    //     fontWeight: FontWeight.w700,
    //     color: App.textColor,
    //   ),
    // );
    // ;
  }
}
