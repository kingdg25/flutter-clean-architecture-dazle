
import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocationPickerController extends Controller {
  final CameraPosition? initialCameraPosition;

  MapLocationPickerController({this.initialCameraPosition});

  Completer<GoogleMapController> googleMapFuture = Completer();


  late LatLng? propertyCameraPosition;

  @override
  void initListeners() {
    initPropertyCameraPosition();
  }

  initPropertyCameraPosition() async {
    // if (initialCameraPosition!=null) {
      propertyCameraPosition = LatLng(initialCameraPosition?.target.latitude ?? 8.482298546726664, initialCameraPosition?.target.longitude ?? 124.64927255100129);
      refreshUI();
    // }
  }

  onMapCreated(GoogleMapController controller) {
    googleMapFuture.complete(controller);
    // refreshUI();
  }

  changePropertyMarker(LatLng position) async {
    final GoogleMapController controller = await googleMapFuture.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(position.latitude, position.longitude),
      tilt: 25.0,
      zoom: 19.151926040649414
    )));
    propertyCameraPosition = LatLng(position.latitude, position.longitude);
    refreshUI();
  }

  @override
  void onDisposed() {
    super.onDisposed();
  }

}