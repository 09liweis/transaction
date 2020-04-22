import './Transaction.dart';
class Place {
  String id;
  String placeId;
  String name;
  String lat;
  String lng;
  String address;
  String icon;
  dynamic rating;
  List<Transaction> transactions;

  Place(String id, String placeId, String icon, String address, String name, dynamic rating, String lat,String lng) {
    this.id = id;
    this.rating = rating;
    this.placeId = placeId;
    this.icon = icon;
    this.name = name;
    this.lat = lat;
    this.lng = lng;
    this.address = address;
  }

  Place.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        rating = json['rating'],
        placeId = json['place_id'],
        name = json['name'],
        lat = json['lat'],
        address = json['address'],
        lng = json['lng'],
        icon = json['icon'];

  Map toJson() {
    return {'_id': id,'icon':icon,'rating':rating, 'place_id':placeId, 'name': name, 'address':address, 'lat': lat,'lng':lng};
  }
}