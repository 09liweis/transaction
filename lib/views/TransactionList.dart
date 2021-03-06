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
  var _transactions = new List<Transaction>();

  Future<void> _getTransactions() async {
    var transactions = await API.getTransactions();
    setState(() {
      _transactions = transactions;
    });
  }
  Future _gotoForm() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransactionForm(transaction:null)),
    );
    if (result!=null){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(result['msg']),duration: Duration(seconds: 3),));
    }
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
      body: new RefreshIndicator(
        child:WidgetTransactions(context, _transactions, _deleteTransaction),
        onRefresh: _getTransactions,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoForm,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
        
  }
}