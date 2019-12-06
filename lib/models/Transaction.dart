class Transaction {
  String _id;
  String title;
  String date;
  String category;
  dynamic price;

  Transaction(String _id, dynamic price, String title, String date,String category) {
    this._id = _id;
    this.title = title;
    this.date = date;
    this.category = category;
    this.price = price;
  }

  Transaction.fromJson(Map json)
      : _id = json['_id'],
        title = json['title'],
        date = json['date'],
        price = json['price'],
        category = json['category'];

  Map toJson() {
    return {'_id': _id, 'title': title, 'price':price, 'date': date,'category':category};
  }
}