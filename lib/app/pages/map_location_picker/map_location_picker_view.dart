


import 'package:dazle/app/widgets/custom_text.dart';
import 'package:dazle/app/widgets/form_fields/custom_button.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../utils/app.dart';
import './map_location_picker_view_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MapLocationPicker extends View {
  final CameraPosition? initialCameraPosition;
  final bool viewOnly;

  MapLocationPicker({this.initialCameraPosition, this.viewOnly = false});

  @override
  _MapLocationPickerState createState() => _MapLocationPickerState(initialCameraPosition: initialCameraPosition, viewOnly: this.viewOnly);
  
}

class _MapLocationPickerState extends ViewState<MapLocationPicker, MapLocationPickerController> {
  _MapLocationPickerState({CameraPosition? initialCameraPosition, bool viewOnly = false})
    : super(MapLocationPickerController(initialCameraPosition: initialCameraPosition, viewOnly: viewOnly));


  @override
  Widget get view {
    return ControlledWidgetBuilder<MapLocationPickerController>(
      builder: (context, controller) {
        print("controller.propertyCameraPosition");
        print(controller.propertyCameraPositionTarget?.latitude);
        print(controller.propertyCameraPositionTarget?.longitude);
        return Scaffold(
          key: globalKey,
          appBar: AppBar(
            title: CustomText(text: "Property Map Location", fontWeight: FontWeight.bold),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            actions: [
              true ? Container() : Container(
                padding: EdgeInsets.only(right: 10.0),
                child: IconButton(
                    icon: Icon(Icons.location_searching, color: App.mainColor),
                    iconSize: 30,
                    onPressed: () {
                      controller.goToCurrentLocation();
                    }),
              ),
              Container(
                padding: EdgeInsets.only(right: 10.0),
                child: IconButton(
                    icon: Icon(Icons.search, color: Colors.blue),
                    iconSize: 30,
                    onPressed: () {
                      controller.inputPlace();
                    }),
              )
            ],
          ),
          body: Stack(
            children: [
              Stack(
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
                    markers: controller.markers
                    // controller.propertyCameraPositionTarget!=null ? {
                    //   Marker(position: controller.propertyCameraPositionTarget as LatLng, markerId: MarkerId("property_position"))
                    // } : {}
                    ,
                    onCameraMove: (CameraPosition cameraPosition) {
                      if (!widget.viewOnly) {print("UPDATETIN ONCAMERAOs");controller.changePropertyCameraPositionTarget(LatLng(cameraPosition.target.latitude, cameraPosition.target.longitude));}
                    },
                    onTap: (LatLng target) {
                      if (!widget.viewOnly) {print("UPDATETIN ONTAP");controller.changePropertyMarker(target);}
                    },
                  ),
                  !widget.viewOnly ? Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: controller.propertyPositionTargetIconSize * 0.80),
                      child: Icon(
                        Icons.location_on,
                        color: Colors.blue[300],
                        size: controller.propertyPositionTargetIconSize,
                      ),
                    ),
                  ) : Container()
                ]
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: CustomButton(
                    text: "Confirm Location",
                    onPressed: (){
                      Navigator.pop(context, controller.propertyCameraPositionTarget);
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