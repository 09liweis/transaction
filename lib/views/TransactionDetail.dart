import 'package:flutter/material.dart';
import '../models/Transaction.dart';
import '../views/TransactionForm.dart';
class TransactionDetail extends StatefulWidget {
  final Transaction transaction;
  TransactionDetail({Key key, @required this.transaction}) : super(key: key);
  @override
  createState() => _TransactionDetailState();
}
class _TransactionDetailState extends State<TransactionDetail> {
  Future _editTransaction(Transaction t) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransactionForm(transaction:t)),
    );
    if (result!=null){
      print(result);
      // Scaffold.of(context).showSnackBar(SnackBar(content: Text(result['msg']),duration: Duration(seconds: 3),));
    }
  }
  initState() {
    super.initState();
  }

  dispose() {
    super.dispose();
  }
  @override
  Widget build(context) {
    var t = widget.transaction;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editTransaction(t);
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