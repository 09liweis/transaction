import 'package:flutter/material.dart';
import 'dart:convert';
import '../API.dart';
import '../models/Transaction.dart';
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
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(transactions[index].title),
              subtitle: Text(transactions[index].date)
            );
          },
        ));
  }
}