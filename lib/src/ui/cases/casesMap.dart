import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geohash/geohash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tesina/src/models/caseModel.dart';
import 'package:tesina/src/provider/caseProvider.dart';
import 'package:tesina/src/ui/cases/caseCard.dart';
import 'package:tesina/src/ui/widgets/menu.dart';

class CasesMap extends StatefulWidget {
  @override
  _CasesMapState createState() => _CasesMapState();
}

class _CasesMapState extends State<CasesMap> with SingleTickerProviderStateMixin {
  GoogleMapController mapController;
  Set<Marker> markers = Set<Marker>();
  LatLng position = new LatLng(23.8524981, -103.1033665);
  LatLng technicianPosition;
  Position currentLocation;
  String lat, lng;
  LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 5);
  String _geoHash ;
  StreamSubscription _getPositionSubscription;
  bool loading;
  List<CaseModel> myCases;
  int indexCases;
  _getLocation() async {
    LatLng coordinates;

    currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      lat = (currentLocation.latitude).toString();
      lng = (currentLocation.longitude).toString();
      position = LatLng(currentLocation.latitude, currentLocation.longitude);
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 16))
      );
      coordinates = LatLng(position.latitude, position.longitude);
    });
    _getPositionSubscription = Geolocator().getPositionStream(locationOptions).listen((Position positions) {
      var newGeoHash = Geohash.encode(positions.latitude, positions.longitude)
          .substring(0, 8);
      if (newGeoHash != _geoHash) {
        setState(() {
          _geoHash = newGeoHash;
          lat = (positions.latitude).toString();
          lng = (positions.longitude).toString();
          position =
              LatLng(currentLocation.latitude, currentLocation.longitude);
        });
      }

      position = new LatLng(positions.latitude, positions.longitude);

      coordinates = LatLng(position.latitude, position.longitude);
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 16))
      );
      return coordinates;
    });

    return coordinates;
  }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  void initState() {
    loading = true;
    indexCases = 1;
    _getLocation();
    CaseProvider().getCases().then((value){
      myCases = value;
      fillMarkers();
      loading = false;
      setState(() {});
    });
    super.initState();
  }
  fillMarkers(){
    markers.clear();
    myCases.forEach((element) {
      setState(() {
        Marker resultMarker = Marker(
          markerId: MarkerId(element.id),
          onTap: (){
            showCaseInformation(element);
          },
          position: LatLng(double.tryParse(element.latitude),
              double.tryParse(element.longitude)),
        );
        markers.add(resultMarker);
      });

    });
  }
  showCaseInformation(CaseModel myCase){
    return showDialog(
      context: context,
      builder: (BuildContext context){
        return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CaseCard(
                myCase: myCase,
              ),
            ],
          );
      }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuWidget(),
      appBar: AppBar(
        title: Text("Mapa de casos"),
        centerTitle: true,
      ),
      body:
      GoogleMap(
      onMapCreated: _onMapCreated,
        trafficEnabled: false,
        mapType: MapType.normal,
        myLocationEnabled: true,
        tiltGesturesEnabled: false,
        markers: markers,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        mapToolbarEnabled: true,
        rotateGesturesEnabled: true,
        compassEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,

      initialCameraPosition: CameraPosition(
        target: position,
        zoom: 12.0,
      ),
    ),
    );
  }
  @override
  void dispose() {
    _getPositionSubscription?.cancel();
    super.dispose();
  }
}
