import 'package:flutter/material.dart';
import '../models/Place.dart';
import './PlaceForm.dart';
class PlaceDetail extends StatelessWidget {
  final Place place;
  PlaceDetail({Key key, @required this.place}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var t = place;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.name??t.address),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaceForm(place: place)
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(t.address),
          ]
        )
      ),
    );
  }
}