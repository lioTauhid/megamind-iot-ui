import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../constant/value.dart';

class ApiClient {
  //GET
  Future<dynamic> get(String endPoint) async {
    var uri = Uri.parse(baseUrl + endPoint);
    try {
      var response = await http.get(uri).timeout(const Duration(seconds: 40));
      // return _processResponse(response);
      return json.decode(response.body);
    } catch (e) {}
  }

  //POST
  Future<dynamic> post(String endPoint, dynamic body) async {
    var uri = Uri.parse(baseUrl + endPoint);
    try {
      var response = await http.post(uri, body: jsonEncode(body), headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      }).timeout(const Duration(seconds: 30));
      return jsonDecode(response.body);
    } catch (e) {}
  }
}
