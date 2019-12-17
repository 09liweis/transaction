import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/Place.dart';
import '../API.dart';
import './PlaceForm.dart';
import '../widgets/Transactions.dart';
class PlaceDetail extends StatelessWidget {
  final Place place;
  final API api = API();
  PlaceDetail({Key key, @required this.place}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.name??place.address),
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
        child: FutureBuilder<Place>(
          future:api.getPlace(place.id),
          builder: (context,snapshot) {
            if (snapshot.hasData) {
              Place p = snapshot.data;
              var transactions = p.transactions;
              return (
                WidgetTransactions(context, transactions)
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            }
            return Center(
              child: CircularProgressIndicator()
            );
          },
        )
      ),
    );
  }
}