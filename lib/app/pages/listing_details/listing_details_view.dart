import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dazle/app/pages/create_listing/create_listing_view.dart';
import 'package:dazle/app/pages/listing_details/components/listing_details_container_box.dart';
import 'package:dazle/app/pages/listing_details/components/listing_details_icon_button.dart';
import 'package:dazle/app/pages/listing_details/listing_details_controller.dart';
import 'package:dazle/app/utils/app.dart';
import 'package:dazle/app/utils/app_constant.dart';
import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/data/repositories/data_listing_repository.dart';
import 'package:dazle/domain/entities/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:dazle/app/pages/download_list/download_list_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ListingDetailsPage extends View {
  ListingDetailsPage({Key? key, required this.listingId}) : super(key: key);

  // final Property property;
  final String? listingId;

  @override
  _ListingDetailsPageState createState() => _ListingDetailsPageState(listingId);
}

class _ListingDetailsPageState
    extends ViewState<ListingDetailsPage, ListingDetailsController> {
  _ListingDetailsPageState(listingId)
      : super(ListingDetailsController(
            dataListingRepo: DataListingRepository(), listingId: listingId));
  CarouselController carouselController = CarouselController();

  @override
  Widget get view {
    return Scaffold(
        key: globalKey,
        backgroundColor: Colors.white,
        body: ControlledWidgetBuilder<ListingDetailsController>(
            builder: (context, controller) {
          Property? selectedListing = controller.selectedListing;
          Map<dynamic, dynamic>? coordinates = selectedListing?.coordinates;
          var latitude;
          var longitude;

          if (coordinates != null) {
            latitude = coordinates["Latitude"];
            longitude = coordinates["Longitude"];
          }

          print(
              'inside listing details view:  ${selectedListing?.coordinates}');
          print('printing latitude $latitude');

          if (selectedListing == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: <Widget>[
                  controller.currentUser?.id == selectedListing.createdBy
                      ? ListingDetailsIconButton(
                          iconData: Icons.edit,
                          tooltip: "Edit Property",
                          onPressed: () async {
                            AppConstant.showLoader(context, true);
                            AppConstant.showToast(
                                msg: "Getting locaton details please wait...",
                                timeInSecForIosWeb: 3);
                            Navigator.pop(context);
                            final popThisPage = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (buildContext) => CreateListingPage(
                                    property: selectedListing,
                                  ),
                                ));
                            await controller.getListingToDisplay();
                          },
                        )
                      : Container(),
                  ListingDetailsIconButton(
                    iconData: Icons.share,
                    tooltip: "Download/Share",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (buildContext) => DownloadListPage(
                              property: selectedListing,
                            ),
                          ));
                    },
                  ),
                  controller.currentUser?.id == selectedListing.createdBy
                      ? ListingDetailsIconButton(
                          iconData: Icons.delete,
                          tooltip: "Delete this property",
                          onPressed: () {
                            AppConstant.deleteDialog(
                                context: context,
                                title: 'Confim',
                                text:
                                    'Are you sure you want to delete this listing?',
                                onConfirm: () async {
                                  Navigator.pop(context);
                                  AppConstant.showLoader(context, true);
                                  await controller.deleteListing(
                                      listingId: controller.listingId);
                                  AppConstant.showLoader(context, false);
                                  Navigator.pop(context);
                                });
                          },
                        )
                      : Container(),
                  // ListingDetailsIconButton(
                  //   iconData: Icons.bookmark_border,
                  //   tooltip: "Bookmark this property",
                  //   onPressed: () {},
                  // ),
                  // true
                  //     ? Container()
                  //     : ListingDetailsIconButton(
                  //         iconData: Icons.open_in_new_outlined,
                  //         tooltip: "bookmark",
                  //         onPressed: () {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                 builder: (buildContext) => DownloadListPage(
                  //                   property: selectedListing,
                  //                 ),
                  //               ));
                  //         },
                  //       )
                ],
                leading: ListingDetailsIconButton(
                  margin: EdgeInsets.only(left: 8),
                  iconData: Icons.arrow_back_ios_rounded,
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                leadingWidth: 51,
                backgroundColor: Colors.white,
                expandedHeight: 271,
                flexibleSpace: FlexibleSpaceBar(
                    background: CarouselSlider.builder(
                        itemCount: selectedListing.photos?.length ?? 0,
                        options: CarouselOptions(
                          aspectRatio: 1,
                          viewportFraction: 1.0,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                          // onPageChanged: callbackFunction,
                        ),
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            GestureDetector(
                              onTap: () {
                                print(selectedListing.photos![itemIndex]);
                              },
                              child: CachedNetworkImage(
                                imageUrl: selectedListing.photos![itemIndex]
                                    .toString(),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color?>(
                                        Colors.indigo[900]),
                                    value: progress.progress,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/brooky_logo.png',
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ))),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      CustomText(
                        text: selectedListing.title == null
                            ? '(No Listing Title)'
                            : selectedListing.title,
                        fontWeight: FontWeight.w900,
                        fontSize: 23,
                      ),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                              text: "${selectedListing.formatPrice}",
                              style: App.textStyle(
                                  fontSize: 20, fontWeight: FontWeight.w800)),
                          TextSpan(
                              text: selectedListing.timePeriod == null ||
                                      selectedListing.timePeriod == ''
                                  ? ''
                                  : "/${selectedListing.timePeriod}",
                              style: App.textStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700)),
                        ]),
                      ),
                      CustomText(
                        text: selectedListing.completeAddress,
                        color: App.hintColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 20),
                      ListingDetailsContainerBox(
                        asset: 'assets/icons/bed.png',
                        text: '${selectedListing.totalBedRoom} Bedroom(s)',
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Flexible(
                            child: ListingDetailsContainerBox(
                              asset: 'assets/icons/bath.png',
                              text:
                                  '${selectedListing.totalBathRoom} Bathroom(s)',
                            ),
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: ListingDetailsContainerBox(
                              asset: 'assets/icons/area.png',
                              text:
                                  '${selectedListing.totalArea?.toStringAsFixed(0)} sqm',
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Flexible(
                            child: ListingDetailsContainerBox(
                              asset: 'assets/icons/car.png',
                              text:
                                  '${selectedListing.totalParkingSpace} parking spot(s)',
                            ),
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: selectedListing.isYourProperty == null ||
                                    selectedListing.isYourProperty == ''
                                ? Container()
                                : ListingDetailsContainerBox(
                                    asset: 'assets/icons/furnished.png',
                                    text: '${selectedListing.isYourProperty}',
                                  ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Divider(
                        color: App.hintColor,
                        height: 1.5,
                      ),
                      SizedBox(height: 20),
                      CustomText(
                        text: 'Location',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 40,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(168, 238, 252, 1.0)),
                              child: Image.asset(
                                'assets/icons/location.png',
                              ),
                            ),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: '${selectedListing.street ?? ""}',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                                CustomText(
                                  text: '${selectedListing.city}',
                                  color: App.hintColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      latitude != null
                          ? Container(
                              // padding: EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      // "https://maps.googleapis.com/maps/api/staticmap?center=8.482298546726664,%20124.64927255100129&zoom=19&size=400x400&key=AIzaSyCSacvsau8vEncNbORdwU0buakm7Mx2rbE",
                                      "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,%20$longitude&zoom=16&size=400x400&markers=color:0x33D49D|$latitude,$longitude&key=AIzaSyCSacvsau8vEncNbORdwU0buakm7Mx2rbE&maptype=hybrid",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      // borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  height: 200.0,
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation<Color?>(
                                              Colors.indigo[900]),
                                      value: progress.progress,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    'assets/brooky_logo.png',
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                onTap: () async {
                                  // CameraPosition initialCamPos = CameraPosition(
                                  //     target: LatLng(controller.latitude!,
                                  //         controller.longitude!),
                                  //     tilt: 25.0,
                                  //     zoom: 19.151926040649414);
                                  // LatLng mapCoordinates = await Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (buildContext) =>
                                  //             MapLocationPicker(
                                  //               initialCameraPosition: initialCamPos,
                                  //             )));
                                },
                              ),
                            )
                          : Text('No Map Location provided.'),
                      SizedBox(height: 20),
                      Divider(
                        color: App.hintColor,
                        height: 1.5,
                      ),
                      SizedBox(height: 20),
                      CustomText(
                        text: 'Features and Amenities',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: 8),
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: selectedListing.amenities?.length ?? 0,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? 3
                                    : 2,
                            childAspectRatio: 5),
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: App.hintColor,
                              ),
                              SizedBox(width: 8),
                              CustomText(
                                text: selectedListing.amenities![index],
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      CustomText(
                        text: 'Description',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      SizedBox(height: 10),
                      CustomText(
                        text: "${selectedListing.description}",
                        color: App.hintColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 20),
                    ],
                  )
                ]),
              )
            ],
          );
        }));
  }
}
