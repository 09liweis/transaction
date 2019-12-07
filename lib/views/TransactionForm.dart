import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:convert';
import '../API.dart';
import '../models/Transaction.dart';
class TransactionForm extends StatefulWidget {
  @override
  createState() => _TransactionForm();
}

class _TransactionForm extends State {
  final _formKey = GlobalKey<FormState>();
  // final _transaction = Transaction();

  initState() {
    super.initState();
  }

  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction Form"),
      ),
      body: Container(
        padding:EdgeInsets.all(10),
        child: Builder(
          builder:(context) => Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter title.';
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter price.';
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value){
                    if (value.isEmpty) {
                      return 'Please enter category.';
                    }
                  },
                ),
                FlatButton(
                  color: Colors.green,
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      currentTime: DateTime.now(),
                      // onChanged: (date) {
                      //   print(date.toString().substring(0,10));
                      // },
                      onConfirm: (date) {
                        String finalDate = date.toString().substring(0,10);
                      }
                    );
                  },
                  child: Text(
                    'Pick a date',
                    style: TextStyle(color: Colors.white),
                  ))
              ]
            )
          )
        ),
      )

    );
        
  }
}