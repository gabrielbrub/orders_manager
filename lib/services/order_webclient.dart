import 'package:http/http.dart';
import 'dart:convert';
import 'package:ordersmanager/model/Order.dart';

class OrderWebClient {
  final String baseUrl = "http://192.168.15.19:8080/orders";
  Future<List<Order>> findAll() async {
    final Response response = await get(
        baseUrl
    );
    final List<dynamic> decodedJson = jsonDecode(response.body);
    print(decodedJson);
    List<Order> orders = List();
    for (int i = 0; i < decodedJson.length; i++) {
      orders.add(Order.fromJson(decodedJson[i]));
      print(orders[i].customerCpf);
    }
    return orders;
  }

  Future save(Order order) async {
    final String transactionJson = jsonEncode(order.toJson());

    final Response response = await post(baseUrl,
        headers: {
          'Content-type': "application/json;charset=UTF-8",
        },
        body: transactionJson)
        .timeout(Duration(seconds: 5));
//    if (response.statusCode == 200) {
//      return order.fromJson(jsonDecode(response.body));
//    }
  }

  Future update(Order order) async {
    print('dentro do update:' + order.itemList.length.toString());
    final String orderJson = jsonEncode(order.toJson());
    print(orderJson);
    final Response response =
    await put('$baseUrl/${order.id}',
        headers: {
          'Content-type': "application/json;charset=UTF-8",
        },
        body: orderJson).timeout(Duration(seconds: 5));
  }


  Future remove(Order order) async {
    final Response response =
    await delete('$baseUrl/${order.id}')
        .timeout(Duration(seconds: 5));
  }
}
