import 'package:flutter/material.dart';
import '../views/TransactionDetail.dart';
Widget WidgetTransactions(context,transactions) {
  return ListView.builder(
    padding: EdgeInsets.all(10),
    itemCount: transactions.length,
    itemBuilder: (context, index) {
      var t = transactions[index];
      return ListTile(
        // leading: Text(t.category),
        leading: Icon(Icons.category,size:30),
        title: Text(
          t.title,
          style:TextStyle(
            color:Colors.blueGrey,
            fontSize: 20,
            fontWeight: FontWeight.bold
          )),
        subtitle: Text(t.date),
        trailing: Text(
          t.price.toString(),
          style:TextStyle(
            color: (t.price < 0)?Colors.red:Colors.green,
            fontSize: 20,
          )
        ),
        enabled: true,
        onTap:(){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetail(transaction: t)
            ),
          );
        }
      );
    },
  );
}