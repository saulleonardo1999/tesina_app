import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:tesina/src/models/caseModel.dart';
class CaseCard extends StatefulWidget {
  final CaseModel myCase;
  const CaseCard({Key key, this.myCase}) : super(key: key);
  @override
  _CaseCardState createState() => _CaseCardState();
}

class _CaseCardState extends State<CaseCard> {
  String location;
  // Uint8List photo;
  @override
  void initState() {
    location = " ";
    // try{
    //   photo = base64Decode(widget.myCase.photo);
    // }catch(e){}
    _getLocation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.transparent)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Color.fromRGBO(0, 0, 0, 0.05),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 30,),
                  Icon(
                      Icons.warning_outlined
                  ),
                  SizedBox(width: 40,),
                  Container(
                    padding: EdgeInsets.only(right: 20),
                    width: MediaQuery.of(context).size.width*0.5,
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(widget.myCase.name,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: MediaQuery.of(context).size.width*0.04,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            infoLabel(widget.myCase.date),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
          ),
          Container(
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      "Descripción",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontSize: MediaQuery.of(context).size.width*0.032,
                          fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    color: Colors.transparent,
                  ),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      widget.myCase.description,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: MediaQuery.of(context).size.width*0.035,
                          fontWeight: FontWeight.w500),
                    ),
                    color: Colors.transparent,
                  )
                ],
              )
          ),
          Divider(
            endIndent: 20.0,
            indent: 20.0,
            thickness: 1.0,
          ),
          Container(
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      "Dirección",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontSize: MediaQuery.of(context).size.width*0.032,
                          fontWeight: FontWeight.bold),
                    ),
                    color: Colors.transparent,
                  ),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      location,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: MediaQuery.of(context).size.width*0.035,
                          fontWeight: FontWeight.w500),
                    ),
                    color: Colors.transparent,
                  )
                ],
              )
          ),
          Divider(
            endIndent: 20.0,
            indent: 20.0,
            thickness: 1.0,
          ),
          Container(
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      "Fecha",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontSize: MediaQuery.of(context).size.width*0.032,
                          fontWeight: FontWeight.bold),
                    ),
                    color: Colors.transparent,
                  ),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      widget.myCase.date,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: MediaQuery.of(context).size.width*0.035,
                          fontWeight: FontWeight.w500),
                    ),
                    color: Colors.transparent,
                  )
                ],
              )
          ),
          Divider(
            endIndent: 20.0,
            indent: 20.0,
            thickness: 1.0,
          ),
          Container(
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      "Tipo de Caso",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontSize: MediaQuery.of(context).size.width*0.032,
                          fontWeight: FontWeight.bold),
                    ),
                    color: Colors.transparent,
                  ),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      widget.myCase.type == 1 ? "Asalto" :
                      widget.myCase.type == 2 ? "Robo de Propiedad" :
                      widget.myCase.type == 3 ? "Acoso" :
                      widget.myCase.type == 4 ? "Fraude" :
                      widget.myCase.type == 5 ? "Accidente Vehicular" :
                      widget.myCase.type == 6 ? "Sospechoso" : "N/A",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: MediaQuery.of(context).size.width*0.035,
                          fontWeight: FontWeight.w500),
                    ),
                    color: Colors.transparent,
                  )
                ],
              )
          ),
          SizedBox(height: 20,)
          // Container(
          //   padding: EdgeInsets.symmetric(
          //       horizontal: MediaQuery.of(context).size.width*0.075,
          //       vertical: 20
          //   ),
          //     width: MediaQuery.of(context).size.width - 40,
          //     height: MediaQuery.of(context).size.height*0.3,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10),
          //         color: Colors.transparent),
          //   child: Image(
          //     height: MediaQuery.of(context).size.height*0.2,
          //     image: MemoryImage(
          //       this.photo
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
  _getLocation() async {
    String thoroughfare, featureName, subLocality;
    final coordinates = new Coordinates(
        double.parse(widget.myCase.latitude), double.parse(widget.myCase.longitude));
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
    setState(() {
      location = "$thoroughfare$featureName$subLocality";
    });
  }

  Widget infoLabel(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      decoration: new BoxDecoration(
        color:
        Colors.red ,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Center(
        child: new Text(
          "$text",
          style: new TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width*0.032,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
