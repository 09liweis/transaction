import 'package:flutter/material.dart';
Widget WidgetTransactions(context,transactions) {
  return ListView.builder(
    padding: EdgeInsets.all(10),
    itemCount: transactions.length,
    itemBuilder: (context, index) {
      var t = transactions[index];
      return ListTile(
        // leading: Text(t.category),
        leading: Icon(Icons.category,size:30),
        title: Text(t.title),
        subtitle: Text(t.date),
        trailing: Text(t.price.toString()),
        enabled: true,
        onTap:(){
          // _gotoDetail(t);
        }
      );
    },
  );
}