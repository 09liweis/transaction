import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import '../API.dart';
import '../models/Place.dart';
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
  _gotoDetail(t) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PlaceDetail(transaction: t)
    //   ),
    // );
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
        ],
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
}