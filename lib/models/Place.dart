class Transaction {
  String _id;
  String placeId;
  String name;
  String lat;
  String lng;
  String address;

  Transaction(String _id, String placeId, String address, String name, String lat,String lng) {
    this._id = _id;
    this.placeId = placeId;
    this.name = name;
    this.lat = lat;
    this.lng = lng;
    this.address = address;
  }

  Transaction.fromJson(Map json)
      : _id = json['_id'],
        placeId = json['place_id'],
        name = json['name'],
        lat = json['lat'],
        address = json['address'],
        lng = json['lng'];

  Map toJson() {
    return {'_id': _id, 'place_id':placeId, 'name': name, 'address':address, 'lat': lat,'lng':lng};
  }
}