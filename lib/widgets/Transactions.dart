import 'package:flutter/material.dart';
import '../views/TransactionDetail.dart';
Widget WidgetTransactions(context,transactions,_deleteTransaction) {
  return ListView.builder(
    padding: EdgeInsets.all(10),
    itemCount: transactions.length,
    itemBuilder: (context, index) {
      var t = transactions[index];
      return ListTile(
        leading: Text(
          t.category,
          style: TextStyle(
            color: Colors.brown,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            letterSpacing: 1.4
          ),
          ),
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
        onLongPress: (){
          if (_deleteTransaction != null) {
            _deleteTransaction(t);
          }
        },
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