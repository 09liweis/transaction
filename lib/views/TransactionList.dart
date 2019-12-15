import 'package:flutter/material.dart';
import 'dart:convert';
import '../API.dart';
import '../models/Transaction.dart';
import '../views/TransactionForm.dart';
import '../views/TransactionDetail.dart';
import '../widgets/Transactions.dart';
class TransactionList extends StatefulWidget {
  @override
  createState() => _TransactionListState();
}

class _TransactionListState extends State {
  var transactions = new List<Transaction>();

  _getTransactions() {
    API.getTransactions().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        transactions = list.map((model) => Transaction.fromJson(model)).toList();
      });
    });
  }
  _gotoForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransactionForm()),
    );
  }
  _gotoDetail(t) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDetail(transaction: t)
      ),
    );
  }
  initState() {
    super.initState();
    _getTransactions();
  }

  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    return Scaffold(
      body: WidgetTransactions(context, transactions),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoForm,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
        
  }
}