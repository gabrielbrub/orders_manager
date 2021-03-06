import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:ordersmanager/model/Customer.dart';
import 'package:ordersmanager/services/networking.dart';

class CustomerWebClient {
  final storage = new FlutterSecureStorage();
  final String baseUrl = "http://$IP_ADDRESS:$PORT/customers";

  Future<List<Customer>> findAll() async {
    final String token = await storage.read(key: "token");
    final Response response = await get(
      baseUrl,
      headers: {
        'Authorization': 'Bearer $token',
      },
    ).timeout(Duration(seconds: 5));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    List<Customer> customers = List();
    for (int i = 0; i < decodedJson.length; i++) {
      customers.add(Customer.fromJson(decodedJson[i]));
    }
    return customers;
  }

  Future save(Customer customer) async {
    final String token = await storage.read(key: "token");
    final String customerJson = jsonEncode(customer.toJson());
    await post('$baseUrl',
            headers: {
              'Content-type': "application/json;charset=UTF-8",
              'Authorization': 'Bearer $token',
            },
            body: customerJson)
        .timeout(Duration(seconds: 5));
  }

  Future remove(Customer customer) async {
    final String token = await storage.read(key: "token");
        await delete('$baseUrl/${customer.id}',
            headers: {
              'Authorization': 'Bearer $token',
            })
            .timeout(Duration(seconds: 5));
  }

  Future update(Customer customer) async {
    final String token = await storage.read(key: "token");
    final String customerJson = jsonEncode(customer.toJson());
    await put('$baseUrl/${customer.id}',
      headers: {
        'Content-type': "application/json;charset=UTF-8",
        'Authorization': 'Bearer $token',
      },
      body: customerJson).timeout(Duration(seconds: 5));
  }
}
