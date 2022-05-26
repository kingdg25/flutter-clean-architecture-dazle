import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/app.dart';

class CustomImage extends StatelessWidget {
  final String imageUrl;
  final String assetImage;
  final bool? isProfilePicture;
  const CustomImage(
      {Key? key,
      required this.assetImage,
      required this.imageUrl,
      this.isProfilePicture = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: isProfilePicture == true ? 95 : 40,
        backgroundImage: imageProvider,
        backgroundColor: App.mainColor,
      ),
      progressIndicatorBuilder: (context, url, progress) => Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color?>(App.mainColor),
          value: progress.progress,
        ),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        backgroundColor: App.mainColor,
        radius: isProfilePicture == true ? 95 : 40,
        backgroundImage: AssetImage(assetImage),
      ),
    );
  }
}
