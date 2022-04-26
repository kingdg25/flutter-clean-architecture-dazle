import 'package:flutter/material.dart';

import '../../../domain/entities/property.dart';
import 'listing_property_list_tile_details.dart';

class ListingPropertyListTile extends StatelessWidget {
  final List<Property>? items;
  final double height;
  final double width;
  final EdgeInsetsGeometry padding;
  final bool isCurrentUser;

  ListingPropertyListTile(
      {required this.items,
      this.height = 255.0,
      this.width = 322.0,
      this.isCurrentUser = true,
      this.padding = const EdgeInsets.all(0.0)});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return isCurrentUser
            ? ListingPropertyListTileDetails(
                items: items,
                index: index,
                padding: padding,
              )
            : items![index].viewType == "public"
                ? ListingPropertyListTileDetails(
                    items: items,
                    index: index,
                    padding: padding,
                  )
                : Container();
      },
    );
  }
}
