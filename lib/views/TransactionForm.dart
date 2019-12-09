import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:convert';
import '../API.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/Transaction.dart';
import 'package:geolocator/geolocator.dart';
class TransactionForm extends StatefulWidget {
  @override
  createState() => _TransactionForm();
}

class _TransactionForm extends State {
  final _formKey = GlobalKey<FormState>();
  // final _transaction = Transaction();
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();
  final dateController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _cameraPosition = CameraPosition(target: LatLng(0, 0),zoom: 10);
  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
      .then((Position position) {
      setState(() {
        _cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude),zoom: 10);
      });
    }).catchError((e) {
      print(e);
    });
  }
  initState() {
    super.initState();
    _getCurrentLocation();
  }

  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction Form"),
      ),
      body: Container(
        padding:EdgeInsets.all(10),
        child: Builder(
          builder:(context) => Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:[
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter title.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      
                    });
                  },
                ),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter price.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                    });
                  },
                ),
                TextFormField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter category.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                    });
                  },
                ),
                FlatButton(
                  color: Colors.green,
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      currentTime: DateTime.now(),
                      // onChanged: (date) {
                      //   print(date.toString().substring(0,10));
                      // },
                      onConfirm: (date) {
                        String finalDate = date.toString().substring(0,10);
                        setState(() {
                          dateController.text = finalDate;
                        });
                      }
                    );
                  },
                  child: Text(
                    'Pick a date',
                    style: TextStyle(color: Colors.white),
                  )
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/3,
                  child: GoogleMap(
                    myLocationEnabled:true,
                    myLocationButtonEnabled:true,
                    mapType: MapType.normal,
                    initialCameraPosition: _cameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    // markers:[

                    // ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                        var data = {
                          'title':titleController.text,
                          'price':priceController.text,
                          'category':categoryController.text,
                          'date':dateController.text,
                        };
                        API.postTransaction(data);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ]
            )
          )
        ),
      )

    );
        
  }
}