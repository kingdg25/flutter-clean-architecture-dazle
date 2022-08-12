import 'package:dazle/app/pages/home/home_view.dart';
import 'package:dazle/app/pages/listing/listing_view.dart';
import 'package:dazle/app/pages/profile/profile_view.dart';
import 'package:dazle/app/widgets/custom_progress_bar.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:dazle/app/pages/main/main_controller.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../find_match/find_match_view.dart';

class MainPage extends View {
  MainPage({this.backCurrentIndex = "HomePage", Key? key}) : super(key: key);

  String? backCurrentIndex;

  static const String id = 'main_page';

  @override
  _MainPageState createState() => _MainPageState(backCurrentIndex);
}

class _MainPageState extends ViewState<MainPage, MainController> {
  _MainPageState(backCurrentIndex)
      : super(MainController(backCurrentIndex: backCurrentIndex));

  @override
  // TODO: implement view
  Widget get view {
    return ControlledWidgetBuilder<MainController>(
      builder: (context, controller) {
        List<Map<String, dynamic>> navs = controller.navs;
        int? currentIndex = controller.currentIndex;
        return Stack(
          children: [
            Scaffold(
              // body: _navs[_currentIndex][_navs[_currentIndex].keys.first],
              body: navs[currentIndex][navs[currentIndex].keys.first],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Color.fromRGBO(51, 212, 157, 1),
                unselectedLabelStyle: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.normal, height: 1.5),
                selectedLabelStyle: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.normal, height: 1.5),
                currentIndex: currentIndex,
                onTap: (index) {
                  setState(() {
                    controller.currentIndex = index;
                  });
                  print(index);
                },
                items: [
                  for (int indexPage = 0;
                      indexPage < navs.length;
                      indexPage++) ...[
                    ...(navs[indexPage]['items'] as List<Map<String, String>>)
                        .map(
                          (item) => BottomNavigationBarItem(
                            activeIcon: CustomPaint(
                                // painter: TrianglePainter(),
                                child: Container(
                                    child: Image.asset(item['asset']!,
                                        height: 22))),
                            icon: Image.asset(item['icon']!, height: 22),
                            label: item['label'],
                          ),
                        )
                        .toList()
                  ]
                ],
              ),
            ),
            controller.showProgressBar == false
                ? Container()
                : Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      // color: Color.fromARGB(162, 154, 160, 166),
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      // height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                                image:
                                    AssetImage('assets/icons/dazle_icon.png')),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width * 0.70,
                              alignment: Alignment.center,
                              child: CustomProgressBar(
                                text:
                                    'Generating PDF ${controller.progressPercentage()}%',
                                progressValue: controller.progressValue,
                              ),
                            ),
                            CustomText(
                              text: 'Generating PDF . . . .',
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
