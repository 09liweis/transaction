import 'package:flutter/material.dart';
import 'dart:convert';
import '../API.dart';
import '../models/Place.dart';
class PlaceList extends StatefulWidget {
  @override
  createState() => _PlaceListState();
}

class _PlaceListState extends State {
  var places = new List<Place>();

  _getPlaces() {
    API.getPlaces().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        places = list.map((model) => Place.fromJson(model)).toList();
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
}

Widget _googleMap(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
  );
}