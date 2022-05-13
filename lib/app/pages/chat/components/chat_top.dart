import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../utils/app.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/property_text_info.dart';
import '../chat_controller.dart';

class ChatTop extends StatelessWidget {
  const ChatTop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ControlledWidgetBuilder<ChatController>(
      builder: (context, controller) {
        final arguments = (ModalRoute.of(context)?.settings.arguments ??
            <String, dynamic>{}) as Map;
        return Container(
          height: 93,
          margin: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            border: Border.all(color: App.hintColor, width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: CachedNetworkImage(
                    imageUrl: arguments['msgData'].property!.coverPhoto!,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5)),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color?>(Colors.indigo[900]),
                        value: progress.progress,
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Image.asset(
                        'assets/brooky_logo.png',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: '${arguments['msgData'].property!.price} PHP',
                        fontWeight: FontWeight.w800,
                        overflow: TextOverflow.ellipsis,
                      ),
                      CustomText(
                        text:
                            '${arguments['msgData'].property!.keywordsToString}',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      CustomText(
                        text: '${arguments['msgData'].message}',
                        color: App.hintColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                    padding: EdgeInsets.all(8),
                    child: Wrap(
                      runSpacing: 5,
                      spacing: 5,
                      children: [
                        PropertyTextInfo(
                          asset: 'assets/icons/bed.png',
                          text:
                              '${arguments['msgData'].property!.totalBedRoom}',
                        ),
                        PropertyTextInfo(
                          asset: 'assets/icons/bath.png',
                          text:
                              '${arguments['msgData'].property!.totalBathRoom}',
                        ),
                        PropertyTextInfo(
                          asset: 'assets/icons/car.png',
                          text:
                              '${arguments['msgData'].property!.totalParkingSpace}',
                        ),
                        PropertyTextInfo(
                          asset: 'assets/icons/area.png',
                          text: '${arguments['msgData'].property!.totalArea}',
                        )
                      ],
                    )),
              ),
            ],
          ),
        );
      },
    );
  }
}
