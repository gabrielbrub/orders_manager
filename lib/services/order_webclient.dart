import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:ordersmanager/model/Order.dart';
import 'package:ordersmanager/services/networking.dart';

class OrderWebClient {
  int numPages;
  final storage = new FlutterSecureStorage();
  final String baseUrl = "http://$IP_ADDRESS:$PORT/orders";

  Future<List<Order>> findAll() async {
    final String token = await storage.read(key: "token");
    final Response response = await get(
        baseUrl,
        headers: {
          'Authorization': 'Bearer $token',
        }
    ).timeout(Duration(seconds: 5));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    List<Order> orders = List();
    for (int i = 0; i < decodedJson.length; i++) {
      orders.add(Order.fromJson(decodedJson[i]));
    }
    return orders;
  }

  Future<List<Order>> findAllFinished(int page) async {
    final String token = await storage.read(key: "token");
    final int size = 10;
    final Response response = await get(
        '$baseUrl/history?page=$page&size=$size',
        headers: {
          'Authorization': 'Bearer $token',
        }
    ).timeout(Duration(seconds: 5));
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    List<Order> orders = List();
    for (int i = 0; i < decodedJson['content'].length; i++) {
      orders.add(Order.fromJson(decodedJson['content'][i]));
    }
    numPages = decodedJson['totalPages'];
    return orders;
  }

  Future save(Order order) async {
    final String token = await storage.read(key: "token");
    final String orderJson = jsonEncode(order.toJson());
    await post(baseUrl,
        headers: {
          'Content-type': "application/json;charset=UTF-8",
          'Authorization': 'Bearer $token',
        },
        body: orderJson)
        .timeout(Duration(seconds: 5));
  }

  Future update(Order order) async {
    final String token = await storage.read(key: "token");
    final String orderJson = jsonEncode(order.toJson());
    await put('$baseUrl/${order.id}',
        headers: {
          'Content-type': "application/json;charset=UTF-8",
          'Authorization': 'Bearer $token',
        },
        body: orderJson).timeout(Duration(seconds: 5));
  }


  Future remove(Order order) async {
    final String token = await storage.read(key: "token");
    await delete('$baseUrl/${order.id}',
        headers: {
          'Authorization': 'Bearer $token',
        })
        .timeout(Duration(seconds: 5));
  }
}
