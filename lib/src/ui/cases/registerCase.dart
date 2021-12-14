import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geohash/geohash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesina/src/models/caseModel.dart';
import 'package:tesina/src/provider/caseProvider.dart';
import 'package:tesina/src/ui/widgets/loadingAlertDismissible.dart';
import 'package:tesina/src/ui/widgets/menu.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'casesMap.dart';

class RegisterCase extends StatefulWidget {
  @override
  _RegisterCaseState createState() => _RegisterCaseState();
}

class _RegisterCaseState extends State<RegisterCase> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateFieldController;
  TextEditingController descriptionFieldController;
  TextEditingController caseTypeFieldController;
  TextEditingController nameFieldController;
  TextEditingController addressFieldController;
  String _image;
  bool showPassword;
  GoogleMapController mapController;
  Set<Marker> markers = Set<Marker>();
  LatLng position = new LatLng(23.8524981, -103.1033665), markerPosition;
  Position currentLocation;
  LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 5);
  String _geoHash ;
  BitmapDescriptor technicianIcon;
  StreamSubscription _getPositionSubscription;
  Uint8List fileImage;
  BuildContext loadingContext;
  CaseModel myCase;
  int caseType;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    dateFieldController = new TextEditingController();
    dateFieldController.clear();
    addressFieldController = new TextEditingController();
    addressFieldController.clear();
    descriptionFieldController = new TextEditingController();
    descriptionFieldController.clear();
    caseTypeFieldController = new TextEditingController();
    caseTypeFieldController.clear();
    nameFieldController = new TextEditingController();
    nameFieldController.clear();
    showPassword = false;
    super.initState();
  }
  _getLocation() async {
    LatLng coordinates;

    currentLocation = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    setState(() {
      position = LatLng(currentLocation.latitude, currentLocation.longitude);
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 12.5))
      );
      coordinates = LatLng(position.latitude, position.longitude);
    });
    _getPositionSubscription = Geolocator().getPositionStream(locationOptions).listen((Position positions) {
      var newGeoHash = Geohash.encode(positions.latitude, positions.longitude)
          .substring(0, 8);
      if (newGeoHash != _geoHash) {
        setState(() {
          _geoHash = newGeoHash;
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
  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050),
        confirmText: "Seleccionar",
        cancelText: "Cancelar",
        helpText: "Selecciona la Fecha del Evento",
        initialDatePickerMode: DatePickerMode.day,
        initialEntryMode: DatePickerEntryMode.calendar,
        locale: Locale.fromSubtags(
          languageCode: 'es'
        )
    );
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
        DateFormat dateFormat = DateFormat.yMMMMd('es');
        this.dateFieldController.text = dateFormat.format(currentDate);
      });
  }
  Widget createTextLabel(String text) {
    return Container(
      width: MediaQuery.of(context).size.width * .84,
      child: Text(
        text,
        style: TextStyle(
            fontSize: 17.5,
            fontWeight: FontWeight.w700,
            color: Colors.black.withOpacity(0.4)),
        textAlign: TextAlign.left,
      ),
    );
  }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            "Registro de Evento"
        ),
      ),
      drawer: MenuWidget(),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 30,),
                FadeInLeft(
                    delay: Duration(milliseconds: 300),
                    child: eventTitleInput()
                ),
                SizedBox(height: 30,),
                FadeInRight(
                    delay: Duration(milliseconds: 300),
                    child: dateCaseInput()
                ),
                SizedBox(height: 30,),
                FadeInRight(
                    delay: Duration(milliseconds: 300),
                    child: addressInput()
                ),
                SizedBox(height: 30,),
                FadeInRight(
                    delay: Duration(milliseconds: 300),
                    child: caseInput()
                ),
                SizedBox(height: 30,),
                FadeInLeft(
                    delay: Duration(milliseconds: 300),
                    child: descriptionInput()
                ),
                // FadeInDown(
                //   delay: Duration(milliseconds: 200),
                //   child: Stack(
                //     alignment: Alignment.bottomCenter,
                //     children: <Widget>[
                //       Column(
                //         children: [
                //           SizedBox(
                //             height: 10,
                //           ),
                //           createTextLabel('Foto del evento'),
                //           SizedBox(
                //             height: 10,
                //           ),
                //           Center(
                //             child: InkWell(
                //               onTap: () {
                //                 _optionsPicture();
                //               },
                //               child: Container(
                //                 padding: EdgeInsets.all(15),
                //                 width: MediaQuery.of(context).size.width*0.85,
                //                 height: MediaQuery.of(context).size.width*0.5,
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(10),
                //                     color: Colors.white,
                //                     border: Border.all(
                //                         color: Colors.black.withOpacity(0.4),
                //                         width: 1
                //                     )
                //                   //  shape: BoxShape.circle,
                //                 ),
                //                 child: fileImage == null
                //                     ?
                //                 Icon(
                //                   Icons.car_repair,
                //                   color: Colors.black,
                //                   size: MediaQuery.of(context).size.width*0.35,
                //                 )
                //                     :
                //                 Image.memory(
                //                   fileImage,
                //                   fit: BoxFit.contain,
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //       Row(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         children: <Widget>[
                //           Container(
                //             margin: EdgeInsets.only(
                //                 right: MediaQuery.of(context).size.width*0.12,
                //                 bottom: 10
                //             ),
                //             decoration: BoxDecoration(
                //               color: Colors.white,
                //               boxShadow: [
                //                 BoxShadow(
                //                   color: Colors.grey,
                //                   blurRadius: 5.0,
                //                 ),
                //               ],
                //               shape: BoxShape.circle,
                //             ),
                //             child: IconButton(
                //               splashColor: Colors.transparent,
                //               onPressed: () {
                //                 _optionsPicture();
                //               },
                //               icon: Icon(
                //                 Icons.add_a_photo,
                //                 color: Colors.black,
                //               ),
                //             ),
                //           )
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: MediaQuery.of(context).size.height * .2,),
              ],
            ),
          ),
        ),

      ),
        floatingActionButton: FadeInDown(
          delay: Duration(milliseconds: 400),
          child: InkWell(
            onTap: (){
              _submit();
            },
            child: Container(
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset:
                      Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey),
              child: Center(
                child: Text(
                  'Registrar',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width*0.06,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
  Widget dateCaseInput() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            createTextLabel('Fecha'),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .84,
              color: Colors.transparent,
              child: new TextFormField(
                enabled: false,
                cursorColor: Colors.blueGrey,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.7)),
                controller: dateFieldController,
                validator: (text){
                  if(dateFieldController.text.isEmpty){
                    return "Llenar Campo";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: new InputDecoration(
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.4), width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.4), width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintStyle: TextStyle(color: Colors.black),
                  prefixIcon: new Icon(
                    Icons.date_range,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget descriptionInput() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          createTextLabel('Descripción del Evento'),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .84,
            child: new TextFormField(
              cursorColor: Colors.blueGrey,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.7)
              ),
              controller: descriptionFieldController,
              validator: (text){
                if(descriptionFieldController.text.isEmpty){
                  return "Llenar Campo";
                }else{
                  return null;
                }
              },
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
              decoration: new InputDecoration(
                errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.4),
                      width: 1.0
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: TextStyle(
                    color: Colors.black
                ),
                prefixIcon: new Icon(
                  Icons.margin,
                  color: Colors.blueGrey,
                ),
              ),
              obscureText: showPassword,
            ),
          )
        ],
      ),
    );
  }
  Widget eventTitleInput() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          createTextLabel("Título del evento"),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width * .84,
            color: Colors.transparent,
            child: new TextFormField(
              enabled: true,
              cursorColor: Colors.blueGrey,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.7)),
              controller: nameFieldController,
              validator: (text){
                if(nameFieldController.text.isEmpty){
                  return "Llenar Campo";
                }else{
                  return null;
                }
              },
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              decoration: new InputDecoration(
                errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.4), width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: new Icon(
                  Icons.assignment,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget caseInput() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          createTextLabel('Tipo de caso'),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                setState(() {
                  caseType = 1;
                  caseTypeFieldController.text = "Rescate";
                });
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext builder) {
                      return Scaffold(
                          appBar: AppBar(
                            automaticallyImplyLeading: false,
                            centerTitle: true,
                            title: Text(
                              "Tipo de caso",
                              style: TextStyle(
                                color: Colors.black
                              ),
                            ),
                            backgroundColor: Colors.white,
                            actions: <Widget>[
                              FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(5)),
                                ),
                                color: Colors.white,
                                child: Text(
                                  "Aceptar",
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 16),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                          body: Container(
                            child: CupertinoPicker(
                              magnification: 1.5,
                              scrollController:
                              FixedExtentScrollController(
                                  initialItem: 0),
                              backgroundColor: Colors.white,
                              children: <Widget>[
                                  Center(
                                      child: Container(
                                        child: Text(
                                            "Asalto"),
                                        margin:
                                        EdgeInsets.symmetric(vertical: 5),
                                      )
                                  ),
                                Center(
                                    child: Container(
                                      child: Text(
                                          "Robo de Propiedad"),
                                      margin:
                                      EdgeInsets.symmetric(vertical: 5),
                                    )
                                ),
                                Center(
                                    child: Container(
                                      child: Text(
                                          "Acoso"),
                                      margin:
                                      EdgeInsets.symmetric(vertical: 5),
                                    )
                                ),
                                Center(
                                    child: Container(
                                      child: Text(
                                          "Fraude"),
                                      margin:
                                      EdgeInsets.symmetric(vertical: 5),
                                    )
                                ),
                                Center(
                                    child: Container(
                                      child: Text(
                                          "Accidente Vehicular"),
                                      margin:
                                      EdgeInsets.symmetric(vertical: 5),
                                    )
                                ),
                                Center(
                                    child: Container(
                                      child: Text(
                                          "Sospechoso"),
                                      margin:
                                      EdgeInsets.symmetric(vertical: 5),
                                    )
                                ),
                              ],
                              itemExtent: 50, //height of each item
                              onSelectedItemChanged: (int index) {
                                setState(() {
                                  switch (index){
                                    case 0:
                                      caseType = 1;
                                      caseTypeFieldController.text = "Asalto";
                                      break;
                                    case 1:
                                      caseType = 2;
                                      caseTypeFieldController.text = "Robo de Propiedad";
                                      break;
                                    case 2:
                                      caseType = 3;
                                      caseTypeFieldController.text = "Acoso";
                                      break;
                                    case 3:
                                      caseType = 4;
                                      caseTypeFieldController.text = "Fraude";
                                      break;
                                    case 4:
                                      caseType = 5;
                                      caseTypeFieldController.text = "Accidente Vehicular";
                                      break;
                                    case 5:
                                      caseType = 6;
                                      caseTypeFieldController.text = "Sospechoso";
                                      break;
                                  }
                                });
                              },
                            ),
                          ));
                    });
              },
            child: Container(
              width: MediaQuery.of(context).size.width * .84,
              child: new TextFormField(
                cursorColor: Colors.blueGrey,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.7)
                ),
                controller: caseTypeFieldController,
                validator: (text){
                  if(caseTypeFieldController.text.isEmpty){
                    return "Llenar Campo";
                  }else{
                    return null;
                  }
                },
                enabled: false,
                decoration: new InputDecoration(
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.4),
                        width: 1.0
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  )              ,
                    disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.4),
                        width: 1.0
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintStyle: TextStyle(
                      color: Colors.black
                  ),
                  prefixIcon: new Icon(
                    Icons.warning_outlined,
                    color: Colors.blueGrey,
                  ),
                ),
                obscureText: showPassword,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget addressInput() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          createTextLabel('Dirección'),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                getAddress();
              },
            child: Container(
              width: MediaQuery.of(context).size.width * .84,
              child: new TextFormField(
                cursorColor: Colors.blueGrey,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.7)
                ),
                controller: addressFieldController,
                validator: (text){
                  if(addressFieldController.text.isEmpty){
                    return "Llenar Campo";
                  }else{
                    return null;
                  }
                },
                enabled: false,
                decoration: new InputDecoration(
                  errorStyle: TextStyle(color: Colors.red, fontSize: 15),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.4),
                        width: 1.0
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  )              ,
                    disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.4),
                        width: 1.0
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintStyle: TextStyle(
                      color: Colors.black
                  ),
                  prefixIcon: new Icon(
                    Icons.location_on,
                    color: Colors.blueGrey,
                  ),
                ),
                obscureText: showPassword,
              ),
            ),
          )
        ],
      ),
    );
  }
  Future _optionsPicture() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  InkWell(
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.camera_alt),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                            ),
                            Text('Tomar una foto'),
                          ],
                        )),
                    onTap: () {
                      getImage(true);
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  InkWell(
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.photo),
                            Padding(
                              padding: EdgeInsets.all(4.0),
                            ),
                            Text('Seleccionar de la galería'),
                          ],
                        )),
                    onTap: () {
                      getImage(false);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
  Future getImage(bool isCamera) async {
    var image = await ImagePicker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      try {
        _image = base64Encode(image.readAsBytesSync());
        fileImage = Base64Decoder().convert(_image);
      } catch (e) {
        print(e);
      }
    });
  }
  void getAddress() {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, __, ___) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: StatefulBuilder(builder: (context, setState) {
              _getLocation();
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height*0.05,
                    horizontal: MediaQuery.of(context).size.width*0.05
                ),
                color: Color.fromRGBO(0, 0, 0, 0.75),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    color: Colors.white
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height*0.025,
                      horizontal: MediaQuery.of(context).size.width*0.025
                  ),
                  child: Stack(
                    children: [
                      GoogleMap(
                        onMapCreated: _onMapCreated,
                        trafficEnabled: false,
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        tiltGesturesEnabled: false,
                        onTap: (mapCoordinates){
                          setStringLocation(mapCoordinates);
                          Marker resultMarker = Marker(
                            markerId: MarkerId("1"),
                            position: LatLng(mapCoordinates.latitude,
                                mapCoordinates.longitude),
                          );
                          markers.clear();
                          markers.add(resultMarker);
                          setState(() {});
                          Scaffold.of(context).showSnackBar(
                            new SnackBar(content: new Text("Se ha guardado la dirección")),
                          );
                        },
                        zoomGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                        mapToolbarEnabled: true,
                        rotateGesturesEnabled: true,
                        compassEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        markers: markers,
                        initialCameraPosition: CameraPosition(
                          target: position,
                          zoom: 3.0,
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: FloatingActionButton(
                          elevation: 10,
                          child: Icon(Icons.done_outline_sharp),
                          onPressed: (){
                            _getPositionSubscription?.cancel();
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
          // Scaffold
        })
    ).then((value) {
      _getPositionSubscription?.cancel();
    });
  }
  setStringLocation(address) async {
    markerPosition = address;
    String thoroughfare, featureName, subLocality;
    final coordinates = new Coordinates(address.latitude, address.longitude);
    var addresses =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    if (first.thoroughfare == null || first.thoroughfare == "null") {
      thoroughfare = " ";
    } else {
      thoroughfare = first.thoroughfare;
    }

    if (first.featureName == null || first.featureName == "null") {
      featureName = " ";
    } else {
      featureName = "  #${first.featureName}";
    }

    if (first.subLocality == null || first.subLocality == "null") {
      subLocality = " ";
    } else {
      subLocality = ",  ${first.subLocality}";
    }
    addressFieldController.text = "$thoroughfare$featureName$subLocality";
  }

  @override
  void dispose() {
    _getPositionSubscription?.cancel();
    super.dispose();
  }
  void _submit() async {
    _formKey.currentState.validate();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          loadingContext = context;
          return LoadingAlertDismissible(
            text: "Cargando...",
          );
        });
    if(_formKey.currentState.validate()){
      myCase = new CaseModel(
        name: nameFieldController.text,
        date: dateFieldController.text,
        description: descriptionFieldController.text,
        latitude: markerPosition.latitude.toString(),
        longitude: markerPosition.longitude.toString(),
        location: addressFieldController.text,
        type: caseType
      );
      CaseProvider().registerCase(myCase).then((value){
        if(value != null){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CasesMap()), (route) => false);
        }else{
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  title: Text("Error"),
                  content: Text("Servicio en mantenimiento. Intente más tarde"),
                  actions: <Widget>[
                    FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Aceptar",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pop(loadingContext);
                      },
                    )
                  ],
                );
              });
        }
      });
    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              title: Text("Error"),
              content: Text("Todos los campos y la foto son obligatorios."),
              actions: <Widget>[
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Aceptar",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(loadingContext);
                  },
                )
              ],
            );
          });
    }
  }

}
