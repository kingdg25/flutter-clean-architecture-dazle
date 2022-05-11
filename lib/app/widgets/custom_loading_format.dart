// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// import '../utils/app.dart';

// class CustomLoadingFormat extends StatelessWidget {
//   final double? height, width;
//   final EdgeInsetsGeometry? padding;
//   final EdgeInsetsGeometry? margin;
//   final double? radius;
//   const CustomLoadingFormat({
//     Key? key,
//     this.height,
//     this.width,
//     this.padding,
//     this.margin,
//     this.radius,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: App.mainColor,
//       highlightColor: Colors.white70,
//       direction: ShimmerDirection.ltr,
//       child: Container(
//         margin: margin,
//         padding: padding,
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           color: App.mainColor.withOpacity(0.3),
//           borderRadius: BorderRadius.all(
//             Radius.circular(radius!),
//           ),
//         ),
//       ),
//     );
//   }
// }
