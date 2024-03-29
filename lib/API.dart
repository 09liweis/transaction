
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './models/Place.dart';
import './models/Transaction.dart';

const baseUrl = "https://samliweisen.herokuapp.com/api/";
// const baseUrl = "http://localhost:8081/api/";

const headers = {"Content-Type": "application/json"};

class API {
  static Future getTransactions() async {
    var url = baseUrl + "transactions";
    var response = await http.post(url);
    Iterable list = json.decode(response.body);
    return list.map((model) => Transaction.fromJson(model)).toList();
  }
  static Future upsertTransaction(Map data) async {
    var url = baseUrl + 'transactions';
    var method = 'post';
    if (data['_id'] != null) {
      url+='/'+data['_id'];
      method = 'put';
    } else {
      url += '/new';
    }
    var body = json.encode(data);
    var response;
    if (method == 'post'){
      response = await http.post(url,
        headers: headers,
        body: body
      );
    } else {
      response = await http.put(url,
      headers:headers,
      body:body);
    }
    if (response.statusCode == 200) {
      var transactionJson = json.decode(response.body);
      var transaction = Transaction.fromJson(transactionJson);
      Place place = Place.fromJson(transactionJson['place']);
      transaction.place = place;
      return transaction;
    } else {
      return null;
    }
  }
  static deleteTransaction(String id) {
    var url = baseUrl + 'transactions/'+id;
    return http.delete(url);
  }
  static Future<Transaction> getTransaction(String id) {
    var url = baseUrl + 'transactions/'+id;
    return http.get(url).then((response){
      if (response.statusCode == 200) {
        var transactionJson = json.decode(response.body);
        var transaction = Transaction.fromJson(transactionJson);
        Place place = Place.fromJson(transactionJson['place']);
        transaction.place = place;
        return transaction;
      } else {
        throw Exception('Failed to load Transaction');
      }
    });
  }
  static Future getPlaces() async {
    var response = await http.get(baseUrl+'places');
    Iterable list = json.decode(response.body);
    return list.map((model) => Place.fromJson(model)).toList();
  }
  Future<Place> getPlace(String id) async {
    var url = baseUrl+'places/'+id;
    final response = await http.get(url);
    if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON.
      var placeJson = json.decode(response.body);
      var place = Place.fromJson(placeJson);
      Iterable transactionsJson = placeJson['transactions'];
      List<Transaction> transactions = transactionsJson.map((model) => Transaction.fromJson(model)).toList();
      place.transactions = transactions;
      return place;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
  static Future upsertPlace(Map data) async {
    var url = baseUrl + 'places';
    var body = json.encode(data);
    var response = await http.post(
      url,
      headers: headers,
      body: body
    );
    return response;
  }
}