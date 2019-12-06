
import 'dart:async';
import 'package:http/http.dart' as http;

const baseUrl = "http://samliweisen.herokuapp.com/api/";

class API {
  static Future getTransactions() {
    var url = baseUrl + "transactions";
    return http.get(url);
  }
}