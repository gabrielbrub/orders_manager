import 'package:http/http.dart';
import 'dart:convert';
import 'package:ordersmanager/model/Order.dart';
import 'package:ordersmanager/services/networking.dart';

class OrderWebClient {
  final String baseUrl = "http://$IP_ADDRESS:$PORT/orders";
  Future<List<Order>> findAll() async {
    final Response response = await get(
        baseUrl
    ).timeout(Duration(seconds: 5));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    List<Order> orders = List();
    for (int i = 0; i < decodedJson.length; i++) {
      orders.add(Order.fromJson(decodedJson[i]));
    }
    return orders;
  }

  Future<List<Order>> findAllFinished() async {
    final Response response = await get(
        '$baseUrl/history'
    ).timeout(Duration(seconds: 5));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    List<Order> orders = List();
    for (int i = 0; i < decodedJson.length; i++) {
      orders.add(Order.fromJson(decodedJson[i]));
    }
    return orders;
  }

  Future save(Order order) async {
    final String orderJson = jsonEncode(order.toJson());
    await post(baseUrl,
        headers: {
          'Content-type': "application/json;charset=UTF-8",
        },
        body: orderJson)
        .timeout(Duration(seconds: 5));
  }

  Future update(Order order) async {
    final String orderJson = jsonEncode(order.toJson());
    await put('$baseUrl/${order.id}',
        headers: {
          'Content-type': "application/json;charset=UTF-8",
        },
        body: orderJson).timeout(Duration(seconds: 5));
  }


  Future remove(Order order) async {
    await delete('$baseUrl/${order.id}')
        .timeout(Duration(seconds: 5));
  }
}
