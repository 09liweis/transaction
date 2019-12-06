class Transaction {
  String _id;
  String title;
  String date;
  String category;

  Transaction(String _id, String title, String date,String category) {
    this._id = _id;
    this.title = title;
    this.date = date;
    this.category = category;
  }

  Transaction.fromJson(Map json)
      : _id = json['_id'],
        title = json['title'],
        date = json['date'],
        category = json['category'];

  Map toJson() {
    return {'_id': _id, 'title': title, 'date': date,'category':category};
  }
}