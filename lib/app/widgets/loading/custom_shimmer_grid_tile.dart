import 'package:flutter/material.dart';

import '../custom_loading_format.dart';
import '../custom_text.dart';

class CustomShimmerGridTile extends StatelessWidget {
  const CustomShimmerGridTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: CustomText(
              text: "Real Estate Brokers you may know",
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 228,
                crossAxisCount: 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: CustomLoadingFormat(
                            radius: 11,
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 5, right: 5),
                        height: 228,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  child: CustomLoadingFormat(
                                    radius: 35,
                                    height: 70,
                                    width: 70,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 5, top: 5),
                                  child: CustomLoadingFormat(
                                    radius: 5,
                                    height: 14,
                                    width: double.infinity,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Center(
                                    child: CustomLoadingFormat(
                                      radius: 5,
                                      height: 12,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: CustomLoadingFormat(
                                height: 27,
                                width: 27,
                              ),
                              width: double.infinity,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
