import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:ordersmanager/model/Customer.dart';
import 'package:ordersmanager/services/networking.dart';

class CustomerWebClient {
  final String baseUrl = "http://$IP_ADDRESS:$PORT/customers";
  Future<List<Customer>> findAll() async {
    final Response response = await get(
      baseUrl
    ).timeout(Duration(seconds: 5));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    List<Customer> customers = List();
    for (int i = 0; i < decodedJson.length; i++) {
      customers.add(Customer.fromJson(decodedJson[i]));
    }
    return customers;
  }

  Future save(Customer customer) async {
    final String customerJson = jsonEncode(customer.toJson());
    await post('$baseUrl',
            headers: {
              'Content-type': "application/json;charset=UTF-8",
            },
            body: customerJson)
        .timeout(Duration(seconds: 5));
  }

  Future remove(Customer customer) async {
        await delete('$baseUrl/${customer.id}')
            .timeout(Duration(seconds: 5));
  }

  Future update(Customer customer) async {
    final String customerJson = jsonEncode(customer.toJson());
    await put('$baseUrl/${customer.id}',
      headers: {
        'Content-type': "application/json;charset=UTF-8",
      },
      body: customerJson).timeout(Duration(seconds: 5));
  }
}
