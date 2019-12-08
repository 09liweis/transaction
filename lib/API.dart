
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "https://samliweisen.herokuapp.com/api/";
// const baseUrl = "http://localhost:8081/api/";

class API {
  static Future getTransactions() {
    var url = baseUrl + "transactions";
    return http.get(url);
  }
  static Future postTransaction(Map data) async {
    var url = baseUrl + 'transactions';
    var body = json.encode(data);
    var response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
    );
    return response;
  }
}