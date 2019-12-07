import 'package:flutter/material.dart';
import 'dart:convert';
import '../API.dart';
import '../models/Transaction.dart';
import '../views/TransactionForm.dart';
class MyListScreen extends StatefulWidget {
  @override
  createState() => _MyListScreenState();
}

class _MyListScreenState extends State {
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
      appBar: AppBar(
        title: Text("Transaction List"),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          var t = transactions[index];
          return ListTile(
            leading: Text(t.category),
            title: Text(t.title),
            subtitle: Text(t.date),
            trailing: Text(t.price.toString()),
            enabled: true,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoForm,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
        
  }
}