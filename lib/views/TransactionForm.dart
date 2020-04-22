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
import '../models/Place.dart';
import 'package:geolocator/geolocator.dart';

const kGoogleApiKey = 'AIzaSyA74jvNet0DufU8aoTe39dELLy2rVMeuos';
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class TransactionForm extends StatefulWidget {
  final Transaction transaction;
  TransactionForm({Key key, @required this.transaction}) : super(key: key);
  @override
  createState() => _TransactionForm();
}

class _TransactionForm extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  Transaction _transaction;
  final titleController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();
  final dateController = TextEditingController();
  String _date = '';
  bool _placeLoaded = false;
  final placeNameController = TextEditingController();
  final placeAddressController = TextEditingController();
  final placeIdController = TextEditingController();
  final placeLatController = TextEditingController();
  final placeLngController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> _markers = <Marker>[];
  CameraPosition _cameraPosition;

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
      .then((Position position) {
        // final location = Location(position.latitude, position.longitude);
        // final result = await _places.searchNearbyWithRadius(location, 2500);
        
      setState(() {
        _cameraPosition = CameraPosition(target: LatLng(position.latitude, position.longitude),zoom: 10);
      });
    }).catchError((e) {
      print(e);
    });
  }
  _searchPlaces() async {
    var searchPlaces = await _places.searchByText(placeNameController.text);
    setState(() {
      List<Marker> markers = <Marker>[];
      searchPlaces.results.forEach((f) {
        final marker = Marker(
          onTap: (){
            placeIdController.text = f.placeId;
            placeLatController.text = f.geometry.location.lat.toString();
            placeLngController.text = f.geometry.location.lng.toString();
            placeAddressController.text = f.formattedAddress;
            placeNameController.text = f.name;
          },
          flat:true,
          icon:BitmapDescriptor.defaultMarker,
          markerId:MarkerId(f.placeId),
          position: LatLng(f.geometry.location.lat, f.geometry.location.lng),
          infoWindow: InfoWindow(
            title: f.name, snippet: f.vicinity
          ),
        );
        markers.add(marker);
      });
      _markers = markers;
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
  Widget build(context) {
    _transaction = widget.transaction;
    if (_transaction != null) {
      titleController.text = _transaction.title;
      priceController.text = _transaction.price.toString();
      categoryController.text = _transaction.category;
      dateController.text = _transaction.date;
      setState(() {
        _date = _transaction.date;
      });
      if (_placeLoaded == false) {
        API.getTransaction(_transaction.id).then((res){
          _placeLoaded = true;
          print(res.place);
          Place place = res.place;
          if (place != null) {
            placeNameController.text = place.name;
            placeAddressController.text = place.address;
            placeIdController.text = place.placeId;
            placeLatController.text = place.lat;
            placeLngController.text = place.lng;
            setState(() {
              final marker = Marker(
                flat:true,
                icon:BitmapDescriptor.defaultMarker,
                markerId:MarkerId(place.placeId),
                position: LatLng(double.parse(place.lat), double.parse(place.lng)),
                infoWindow: InfoWindow(
                  title: place.name
                ),
              );
              _markers.add(marker);
            });
          }
        });
      }
    }
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
                          _date = finalDate;
                        });
                      }
                    );
                  },
                  child: Text(
                    _date??'Pick a date',
                    style: TextStyle(color: Colors.white),
                  )
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height/4,
                  child: (_cameraPosition != null)?GoogleMap(
                    myLocationEnabled:true,
                    myLocationButtonEnabled:true,
                    mapType: MapType.normal,
                    initialCameraPosition: _cameraPosition,
                    // cameraTargetBounds: CameraTargetBounds(_bounds),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers:Set<Marker>.of(_markers),
                  ):Center(
                    child: Text('Loading Map'),
                  ),
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
                  onPressed: _searchPlaces,
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
                  onSaved: (value) {
                    setState(() {
                    });
                  },
                ),
                TextFormField(
                  controller: placeIdController,
                  decoration: InputDecoration(labelText: 'Place Id'),
                  onSaved: (value) {
                    setState(() {
                    });
                  },
                ),
                TextFormField(
                  controller: placeLatController,
                  decoration: InputDecoration(labelText: 'Place Lat'),
                  onSaved: (value) {
                    setState(() {
                    });
                  },
                ),
                TextFormField(
                  controller: placeLngController,
                  decoration: InputDecoration(labelText: 'Place Lng'),
                  onSaved: (value) {
                    setState(() {
                    });
                  },
                ),
              ]
            )
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() {
          if (_formKey.currentState.validate()) {
            // If the form is valid, display a Snackbar.
            String message = 'Added';
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
            if (_transaction != null) {
              message = 'Updated';
              data['_id'] = _transaction.id;
            }
            API.upsertTransaction(data).then((res){
              Navigator.pop(context,{'msg':message,'ret':res});
            });
          }
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
        
  }
}