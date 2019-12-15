import './Transaction.dart';
class Place {
  String id;
  String placeId;
  String name;
  String lat;
  String lng;
  String address;
  List<Transaction> transactions;

  Place(String id, String placeId, String address, String name, String lat,String lng) {
    this.id = id;
    this.placeId = placeId;
    this.name = name;
    this.lat = lat;
    this.lng = lng;
    this.address = address;
  }

  Place.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        placeId = json['place_id'],
        name = json['name'],
        lat = json['lat'],
        address = json['address'],
        lng = json['lng'];

  Map toJson() {
    return {'_id': id, 'place_id':placeId, 'name': name, 'address':address, 'lat': lat,'lng':lng};
  }
}