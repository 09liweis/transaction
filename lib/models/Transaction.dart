import './Place.dart';
class Transaction {
  String id;
  String title;
  String date;
  String category;
  dynamic price;
  Place place;

  Transaction(String id, dynamic price, String title, String date,String category) {
    this.id = id;
    this.title = title;
    this.date = date;
    this.category = category;
    this.price = price;
  }

  Transaction.fromJson(Map json)
    : id = json['_id'],
    title = json['title'],
    date = json['date'],
    price = json['price'],
    category = json['category'];

  Map toJson() {
    return {'_id': id, 'title': title, 'price':price, 'date': date,'category':category};
  }
}