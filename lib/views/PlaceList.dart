import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import '../API.dart';
import '../models/Place.dart';
import './PlaceDetail.dart';
class PlaceList extends StatefulWidget {
  @override
  createState() => _PlaceListState();
}

class _PlaceListState extends State {
  var places = new List<Place>();
  List<Marker> _markers = <Marker>[];
  Completer<GoogleMapController> _controller = Completer();
  _getPlaces() {
    API.getPlaces().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        places = list.map((model) => Place.fromJson(model)).toList();
        places.forEach((p) {
          final marker = Marker(
            flat:true,
            icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            markerId:MarkerId(p.placeId),
            position: LatLng(double.parse(p.lat), double.parse(p.lng)),
            // infoWindow: InfoWindow(title:"${p.name}", "${p.types?.first}")
            infoWindow: InfoWindow(
              title: p.name??p.address
            ),
          );
          _markers.add(marker);
        });
      });
    });
  }
  _gotoDetail(p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceDetail(place: p)
      ),
    );
  }
  Future<void> _gotoLocation(double lat,double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 15,tilt: 50.0,
      bearing: 45.0,)));
  }
  initState() {
    super.initState();
    _getPlaces();
  }

  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _googleMap(context)
          ,_buildContainer(context)
        ],
      )
    );
  }
  Widget _buildContainer(context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child:Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child:ListView.builder(
          scrollDirection:Axis.horizontal,
          itemCount: places.length,
          itemBuilder: (context,index) {
            var p = places[index];
            return _placeBox(p);
          },
        )
      )
    );
  }
  Widget _googleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child:GoogleMap(
        mapType:MapType.normal,
        initialCameraPosition: CameraPosition(target: LatLng(44.0384, -79.2000),zoom: 10),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers:Set<Marker>.of(_markers),
      )
    );
  }
  Widget _placeBox(Place place){
    return (
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: _boxes(place),
      ));
  }
  Widget _boxes(Place place) {
    String _image = "https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no";
    double lat = double.parse(place.lat);
    double lng = double.parse(place.lng);
    String placeName = place.name??'No Name';
    return  GestureDetector(
      onTap: () {
        _gotoDetail(place);
      },
      onDoubleTap: (){
        _gotoLocation(lat,lng);
      },
      child:Container(
        child: new FittedBox(
          child: Material(
            color: Colors.white,
            // elevation: 24.0,
            borderRadius: BorderRadius.circular(10.0),
            // shadowColor: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 180,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(10.0),
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(_image),
                    ),
                  )
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: placeBoxContainer(placeName),
                  ),
                ),
              ]
            )
          ),
        ),
      ),
    );
  }
  Widget placeBoxContainer(String placeName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(placeName,
            style: TextStyle(
                color: Color(0xff6200ee),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height:5.0),
        Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Container(
              //   child: Icon(
              //     FontAwesomeIcons.solidStar,
              //     color: Colors.amber,
              //     size: 15.0,
              //   ),
              // ),
               Container(
                  child: Text(
                "(946)",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
              )),
            ],
          ))
      ],
    );
  }
}