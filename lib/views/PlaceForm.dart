import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../API.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import '../models/Place.dart';

const kGoogleApiKey = 'AIzaSyA74jvNet0DufU8aoTe39dELLy2rVMeuos';
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class PlaceForm extends StatefulWidget {
  final Place place;
  PlaceForm({Key key, @required this.place}) : super(key: key);
  @override
  createState() => _PlaceForm();
}

class _PlaceForm extends State<PlaceForm> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final placeIdController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _cameraPosition = CameraPosition(target: LatLng(0, 0),zoom: 10);
  Place _place;
  Marker _marker = new Marker();

  initState() {
    super.initState();
  }

  dispose() {
    super.dispose();
  }

  @override
  Widget build(context) {
    _place = widget.place;
    nameController.text = _place.name??'';
    addressController.text = _place.address;
    placeIdController.text = _place.placeId;
    latController.text = _place.lat;
    lngController.text = _place.lng;
    setState(() {
      var position = LatLng(double.parse(_place.lat),double.parse(_place.lng));
      _marker = Marker(
        markerId: MarkerId(_place.placeId),
        position: position,
      );
      _cameraPosition = CameraPosition(target: position,zoom:18);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Place Form"),
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
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter place name.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      
                    });
                  },
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter place address.';
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
                      return 'Please enter placeId.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                    });
                  },
                ),
                TextFormField(
                  controller: latController,
                  decoration: InputDecoration(labelText: 'Lat'),
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
                  controller: lngController,
                  decoration: InputDecoration(labelText: 'Lng'),
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
                  height: MediaQuery.of(context).size.height/3,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _cameraPosition,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    markers:Set<Marker>.of([_marker]),
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
                          'name':nameController.text,
                          'address':addressController.text,
                          'place_id':placeIdController.text,
                          'lat':latController.text,
                          'lng':lngController.text
                        };
                        API.upsertPlace(data);
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