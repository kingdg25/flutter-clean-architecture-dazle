import 'package:flutter/material.dart';

import '../custom_loading_format.dart';

class CustomShimmerListTile extends StatelessWidget {
  final bool? isMyConnection;
  const CustomShimmerListTile({this.isMyConnection = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 8,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 17.0,
                    vertical: isMyConnection == true ? 18.0 : 24),
                child: CustomLoadingFormat(
                  width: 40,
                  height: 40,
                  radius: 50,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: CustomLoadingFormat(
                      width: 100,
                      height: 15,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: CustomLoadingFormat(
                      width: 70,
                      height: 12,
                    ),
                  ),
                  if (isMyConnection == true) SizedBox(height: 8),
                  if (isMyConnection == true)
                    Container(
                      child: CustomLoadingFormat(
                        width: 50,
                        height: 8,
                      ),
                    ),
                ],
              ),
              Spacer(),
              Container(
                margin: isMyConnection == true
                    ? EdgeInsets.only(right: 20)
                    : EdgeInsets.only(right: 5),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 15),
                      child: CustomLoadingFormat(
                        width: isMyConnection == true ? 90 : 80,
                        height: 32,
                      ),
                    ),
                    if (isMyConnection == true)
                      Container(
                        child: Center(
                          child: CustomLoadingFormat(
                            width: 20,
                            height: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
