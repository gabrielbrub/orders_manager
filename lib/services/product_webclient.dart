import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:ordersmanager/model/Product.dart';
import 'package:ordersmanager/services/networking.dart';

class ProductWebClient {
  final storage = new FlutterSecureStorage();
  final String baseUrl = "http://$IP_ADDRESS:$PORT/products";

  Future<List<Product>> findAll() async {
    final String token = await storage.read(key: "token");
    final Response response = await get(
        baseUrl,
        headers: {
          'Authorization': 'Bearer $token',
        }
    ).timeout(Duration(seconds: 5));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    List<Product> products = List();
    for (int i = 0; i < decodedJson.length; i++) {
      products.add(Product.fromJson(decodedJson[i]));
    }
    return products;
  }

  Future save(Product product) async {
    final String token = await storage.read(key: "token");
    final String productJson = jsonEncode(product.toJson());
    await post('$baseUrl',
        headers: {
          'Content-type': "application/json;charset=UTF-8",
          'Authorization': 'Bearer $token',
        },
        body: productJson)
        .timeout(Duration(seconds: 5));
  }

  Future remove(Product product) async {
    final String token = await storage.read(key: "token");
    await delete('$baseUrl/${product.id}',
        headers: {
          'Authorization': 'Bearer $token',
        })
        .timeout(Duration(seconds: 5));
  }

  Future update(Product product) async {
    final String token = await storage.read(key: "token");
    final String productJson = jsonEncode(product.toJson());
    await put('$baseUrl/${product.id}',
        headers: {
          'Content-type': "application/json;charset=UTF-8",
          'Authorization': 'Bearer $token',
        },
        body: productJson).timeout(Duration(seconds: 5));
  }
}
