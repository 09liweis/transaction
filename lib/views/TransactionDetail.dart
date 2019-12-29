import 'package:flutter/material.dart';
import '../models/Transaction.dart';
import '../views/TransactionForm.dart';
class TransactionDetail extends StatelessWidget {
  final Transaction transaction;
  TransactionDetail({Key key, @required this.transaction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var t = transaction;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TransactionForm(transaction:transaction)
                ),
              );
            },
          )
        ]
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(t.price.toString()),
            Text(t.date),
            Text(t.category),
          ]
        )
      ),
    );
  }
}