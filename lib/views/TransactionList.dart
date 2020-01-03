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
      MaterialPageRoute(builder: (context) => TransactionForm(transaction:new Transaction('', '', '', '', ''))),
    );
  }
  initState() {
    super.initState();
    _getTransactions();
  }
  _deleteTransaction(Transaction t) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Transaction'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You are about to detele '+t.title)
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Regret'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Confirm'),
              onPressed: () {
                API.deleteTransaction(t.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    return Scaffold(
      body: WidgetTransactions(context, transactions, _deleteTransaction),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoForm,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
        
  }
}