import 'package:flutter/material.dart';
import '../models/Transaction.dart';
class TransactionDetail extends StatelessWidget {
  final Transaction transaction;
  TransactionDetail({Key key, @required this.transaction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(transaction.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Detail'),
      ),
    );
  }
}