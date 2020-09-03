import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:ordersmanager/services/networking.dart';

class AuthWebclient{
  final String baseUrl = "http://$IP_ADDRESS:$PORT/auth";

   Future<String> login(String email, String password) async {
     final msg = jsonEncode({"email":email, "senha":password});
     Response response = await post('$baseUrl',
         headers: {
           'Content-type': "application/json;charset=UTF-8",
         },
         body: msg,
     )
         .timeout(Duration(seconds: 10));
     var decodedJson = jsonDecode(response.body);
     String token = decodedJson["token"];
     debugPrint(token);
     return token;
  }

  register(String email, String password, String username) async {
    final msg = jsonEncode({"email":email, "senha":password, "name":username});
    Response response = await post('$baseUrl/register',
      headers: {
        'Content-type': "application/json;charset=UTF-8",
      },
      body: msg,
    )
        .timeout(Duration(seconds: 10)) ;
  }


}

