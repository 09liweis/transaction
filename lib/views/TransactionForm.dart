import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:convert';
import '../API.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:location/location.dart' as LocationManager;
import '../models/Transaction.dart';
import 'package:geolocator/geolocator.dart';

const kGoogleApiKey = 'AIzaSyA74jvNet0DufU8aoTe39dELLy2rVMeuos';
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

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
  final placeNameController = TextEditingController();
  final placeAddressController = TextEditingController();
  final placeIdController = TextEditingController();
  final placeLatController = TextEditingController();
  final placeLngController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markers = <Marker>[];
  CameraPosition _cameraPosition = CameraPosition(target: LatLng(0, 0),zoom: 10);

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
      .then((Position position) async {
        final location = Location(position.latitude, position.longitude);
        final result = await _places.searchNearbyWithRadius(location, 2500);
        
      setState(() {
        result.results.forEach((f) {
          final marker = Marker(
            flat:true,
            icon:BitmapDescriptor.defaultMarker,
            markerId:MarkerId(f.placeId),
            position: LatLng(f.geometry.location.lat, f.geometry.location.lng),
            // infoWindow: InfoWindow(title:"${f.name}", "${f.types?.first}")
            infoWindow: InfoWindow(
              title: f.name, snippet: f.vicinity
            ),
          );
          _markers.add(marker);
        });
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
                TextFormField(
                  controller: placeNameController,
                  decoration: InputDecoration(labelText: 'Place Name'),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter name.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                    });
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    print('Search Place');
                  },
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFF0D47A1),
                          Color(0xFF1976D2),
                          Color(0xFF42A5F5),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                      'Search Place',
                      style: TextStyle(fontSize: 20)
                    ),
                  ),
                ),
                TextFormField(
                  controller: placeAddressController,
                  decoration: InputDecoration(labelText: 'Place Address'),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter address.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                    });
                  },
                ),
                TextFormField(
                  controller: placeIdController,
                  decoration: InputDecoration(labelText: 'Place Id'),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter placeid.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                    });
                  },
                ),
                TextFormField(
                  controller: placeLatController,
                  decoration: InputDecoration(labelText: 'Place Lat'),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter lat.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                    });
                  },
                ),
                TextFormField(
                  controller: placeLngController,
                  decoration: InputDecoration(labelText: 'Place Lng'),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter lng.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                    });
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/4,
                  child: GoogleMap(
                    myLocationEnabled:true,
                    myLocationButtonEnabled:true,
                    mapType: MapType.normal,
                    initialCameraPosition: _cameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers:Set<Marker>.of(_markers),
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
                          'place':{
                            'name':placeNameController.text,
                            'address':placeAddressController.text,
                            'lat':placeLatController.text,
                            'lng':placeLngController.text,
                            'place_id':placeIdController.text
                          }
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