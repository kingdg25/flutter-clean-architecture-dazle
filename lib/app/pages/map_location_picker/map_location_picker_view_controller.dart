
import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
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
  GoogleMapsPlaces googleMapPlaces = GoogleMapsPlaces(apiKey: "AIzaSyCSacvsau8vEncNbORdwU0buakm7Mx2rbE");

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
    // controller.animateCamera(CameraUpdate.newCameraPosition(
    //   CameraPosition(target: position,
    //   tilt: 25.0,
    //   zoom: await controller.getZoomLevel()
    // )));
    controller.animateCamera(CameraUpdate.newLatLng(position));
  }

  changePropertyCameraPositionTarget(LatLng position) async {
    propertyCameraPositionTarget = LatLng(position.latitude, position.longitude);
  }

  changePropertyMarker(LatLng position) async {
    await moveMapCamera(LatLng(position.latitude, position.longitude));
    propertyCameraPositionTarget = LatLng(position.latitude, position.longitude);
    refreshUI();
  }
  
  Future<PlacesDetailsResponse> getDetailsByPlaceId(String placeId) async {
    return await googleMapPlaces.getDetailsByPlaceId(placeId);
  }

  Future<PlacesSearchResponse> searchNearbyWithRadius(Location location, num radius) async {
    return await googleMapPlaces.searchNearbyWithRadius(location, radius);
  }
  
  inputPlace() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: getContext(),
      apiKey: "AIzaSyCSacvsau8vEncNbORdwU0buakm7Mx2rbE",
      mode: Mode.overlay, // Mode.fullscreen
      // language: "ph",
      types: [],
      strictbounds: false,
      onError: (PlacesAutocompleteResponse autoCompleteResponse) async {
        print(autoCompleteResponse.errorMessage);
      },
      location: propertyCameraPositionTarget!=null ? Location(lat: propertyCameraPositionTarget!.latitude, lng: propertyCameraPositionTarget!.longitude) : null,
      components: [
        // new Component(Component.country, "ph")
      ]
    );
    
    if (p!=null) {
      PlacesDetailsResponse placeDetailsResponse = await getDetailsByPlaceId(p.placeId ?? "");
      Geometry? geometry = placeDetailsResponse.result.geometry;
      if (geometry!=null) {
        final latLng = LatLng(geometry.location.lat, geometry.location.lng);
        PlacesSearchResponse placesSearchResponse = await searchNearbyWithRadius(Location(lat: latLng.latitude, lng: latLng.longitude), 100.0);
        print("WEWAEEAWEAWE");
        // print(placesSearchResponse.results[0].formattedAddress);
        // print(placesSearchResponse.results[0].toJson());
        // placesSearchResponse.results.forEach((PlacesSearchResult val) {
        //   print(val.toJson());
        // });
        print(placesSearchResponse.results);
        changePropertyCameraPositionTarget(latLng);
        moveMapCamera(latLng);
      }
    }
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