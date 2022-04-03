


import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './map_location_picker_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MapLocationPicker extends View {
  final CameraPosition? initialCameraPosition;

  MapLocationPicker({this.initialCameraPosition});

  @override
  _MapLocationPickerState createState() => _MapLocationPickerState(initialCameraPosition: initialCameraPosition);
  
}

class _MapLocationPickerState extends ViewState<MapLocationPicker, MapLocationPickerController> {
  _MapLocationPickerState({CameraPosition? initialCameraPosition})
    : super(MapLocationPickerController(initialCameraPosition: initialCameraPosition));


  @override
  Widget get view {
    return ControlledWidgetBuilder<MapLocationPickerController>(
      builder: (context, controller) {
        print("controller.propertyCameraPosition");
        print(controller.propertyCameraPosition?.latitude);
        print(controller.propertyCameraPosition?.longitude);
        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.hybrid,
                myLocationEnabled: true,
                initialCameraPosition: widget.initialCameraPosition ?? CameraPosition(
                  // bearing: 192.8334901395799,
                  target: LatLng(8.482298546726664, 124.64927255100129),
                  tilt: 25.0,
                  zoom: 19.151926040649414),
                onMapCreated: (GoogleMapController googleMapController) => controller.onMapCreated(googleMapController),
                markers: controller.propertyCameraPosition!=null ? {
                  Marker(position: controller.propertyCameraPosition as LatLng, markerId: MarkerId("property_position"))
                } : {},
                onCameraMove: (CameraPosition cameraPosition) {
                  // controller.changePropertyMarker(LatLng(cameraPosition.target.latitude, cameraPosition.target.longitude));
                },
                onTap: (LatLng target) {
                  controller.changePropertyMarker(target);
                },
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: CustomButton(
                    text: "Confirm Location",
                    onPressed: (){
                      Navigator.pop(context, controller.propertyCameraPosition);
                    },
                    backgroudColor: Color(0xFF0D47A1)
                  )
                )
              )
            ]
          ),
        );
      }
    );

  }

}