import 'package:cached_network_image/cached_network_image.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/property_text_info.dart';
import 'package:dazle/domain/entities/message.dart';
import 'package:flutter/material.dart';

class MessagePropertyListTile extends StatelessWidget {
  final List<Message> items;

  MessagePropertyListTile({
    @required this.items
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300, minWidth: 250),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items?.length ?? 0,
        itemBuilder: (BuildContext context, int index){
          return Container(
            height: 93,
            decoration: BoxDecoration(
              border: Border.all(
                color: App.hintColor,
                width: 0.5
              ),
              borderRadius: BorderRadius.circular(5)
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: CachedNetworkImage(
                    imageUrl: items[index].property.coverPhoto,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover
                        ),
                      ),
                    ),
                    progressIndicatorBuilder: (context, url, progress) => Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo[900]),
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
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: '${items[index].property.amount} PHP',
                          fontWeight: FontWeight.w800,
                          overflow: TextOverflow.ellipsis,
                        ),
                        CustomText(
                          text: '${items[index].property.keywordsToString}',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        CustomText(
                          text: '${items[index].message}',
                          color: App.hintColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                        CustomText(
                          text: '${items[index].timeAgo}',
                          color: App.hintColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    )
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
                          text: '${items[index].property.totalBedRoom}',
                        ),
                        PropertyTextInfo(
                          asset: 'assets/icons/bath.png',
                          text: '${items[index].property.totalBathRoom}',
                        ),
                        PropertyTextInfo(
                          asset: 'assets/icons/car.png',
                          text: '${items[index].property.totalParkingSpace}',
                        ),
                        PropertyTextInfo(
                          asset: 'assets/icons/area.png',
                          text: '${items[index].property.totalArea}',
                        ) 
                      ],
                    )
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}