import 'package:dazle/app/pages/find_match/find_match_controller.dart';
import 'package:dazle/app/widgets/custom_appbar.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:dazle/app/widgets/form_fields/custom_field_layout.dart';
import 'package:dazle/data/repositories/data_home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class FindMatchPage extends View {
  FindMatchPage({Key? key}) : super(key: key);

  @override
  _FindMatchPageState createState() => _FindMatchPageState();
}

class _FindMatchPageState
    extends ViewState<FindMatchPage, FindMatchController> {
  _FindMatchPageState() : super(FindMatchController(DataHomeRepository()));

  @override
  Widget get view {
    return Scaffold(
        key: globalKey,
        appBar: CustomAppBar(
          title: 'Property Match',
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: ControlledWidgetBuilder<FindMatchController>(
            builder: (context, controller) {
          final double screenHeight = MediaQuery.of(context).size.height;

          return Container(
            padding: EdgeInsets.only(
                top: screenHeight * 0.16, bottom: screenHeight * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image(
                          image: AssetImage('assets/house_searching.png')),
                    ),
                    CustomFieldLayout(
                      child: CustomText(
                        text:
                            "Find a match of your buyer's property preferences \n \n THIS FEATURE WILL BE COMING SOON!",
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                // Container(
                //   alignment: Alignment.bottomCenter,
                //   child: CustomButton(
                //     text: 'Find Match',
                //     expanded: true,
                //     onPressed: () {},
                //   ),
                // )
              ],
            ),
          );
        }));
  }
}
