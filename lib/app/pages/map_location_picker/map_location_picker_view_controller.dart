
import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocationPickerController extends Controller {
  final CameraPosition? initialCameraPosition;
  final bool viewOnly;

  MapLocationPickerController({this.initialCameraPosition, this.viewOnly = false})
    : propertyCameraPositionTarget = initialCameraPosition!=null ? LatLng(initialCameraPosition.target.latitude, initialCameraPosition.target.longitude) : null,
    markers = (initialCameraPosition!=null && viewOnly) ? {Marker(position: LatLng(initialCameraPosition.target.latitude, initialCameraPosition.target.longitude), markerId: MarkerId("property_position"))} : {};

  Completer<GoogleMapController> googleMapFuture = Completer();


  late LatLng? propertyCameraPositionTarget;
  double propertyPositionTargetIconSize = 50.0;

  Set<Marker> markers = <Marker>{};

  @override
  void initListeners() {
    // initPropertyCameraPosition();
  }

  initPropertyCameraPosition() async {
    if (initialCameraPosition!=null) {
      propertyCameraPositionTarget = LatLng(initialCameraPosition?.target.latitude ?? 8.482298546726664, initialCameraPosition?.target.longitude ?? 124.64927255100129);
      // refreshUI();
    }
  }

  onMapCreated(GoogleMapController controller) {
    googleMapFuture.complete(controller);
    // refreshUI();
  }

  moveMapCamera(LatLng position) async {
    final GoogleMapController controller = await googleMapFuture.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: position,
      tilt: 25.0,
      zoom: await controller.getZoomLevel()
    )));
  }

  changePropertyCameraPositionTarget(LatLng position) async {
    propertyCameraPositionTarget = LatLng(position.latitude, position.longitude);
  }

  changePropertyMarker(LatLng position) async {
    await moveMapCamera(LatLng(position.latitude, position.longitude));
    propertyCameraPositionTarget = LatLng(position.latitude, position.longitude);
    refreshUI();
  }
  
  goToCurrentLocation() async {
    Position? geolocatorPosition = await getGeolocatorCurrentLocation();
    if (geolocatorPosition!=null) await moveMapCamera(LatLng(geolocatorPosition.latitude, geolocatorPosition.longitude));
  }

  Future<Position?> getGeolocatorCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
      return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return null;
    } 

    return await Geolocator.getCurrentPosition();
  }

  @override
  void onDisposed() {
    super.onDisposed();
  }

}