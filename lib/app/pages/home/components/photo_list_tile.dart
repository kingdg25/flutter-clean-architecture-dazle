import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/form_fields/custom_flat_button.dart';
import 'package:dazle/domain/entities/photo_tile.dart';
import 'package:flutter/material.dart';

class PhotoListTile extends StatelessWidget {
  final List<PhotoTile> items;
  final double height;
  final double width;

  PhotoListTile(
      {required this.items, this.height = 130.0, this.width = 250.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8, right: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      print('${items[index].photoURL.toString()}');
                    },
                    child: Container(
                      width: width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [AppConstant.boxShadow],
                      ),
                      child: CachedNetworkImage(
                        imageUrl: items[index].photoURL.toString(),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        progressIndicatorBuilder: (context, url, progress) =>
                            Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color?>(
                                Colors.indigo[900]),
                            value: progress.progress,
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/brooky_logo.png',
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                  (items[index].text != null && items[index].text!.isNotEmpty)
                      ? Positioned(
                          bottom: 5,
                          child: Container(
                            width: 100,
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromRGBO(240, 242, 247, 1.0)),
                            child: CustomFlatButton(
                              color: Colors.black,
                              onPressed: null,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              fontSize: 10,
                              text: items[index].text,
                            ),
                          ))
                      : Container()
                ],
              ));
        },
      ),
    );
  }
}
