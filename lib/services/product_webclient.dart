import 'package:http/http.dart';
import 'dart:convert';
import 'package:ordersmanager/model/Product.dart';

class ProductWebClient {
  final String baseUrl = "http://192.168.15.19:8080/products";
  Future<List<Product>> findAll() async {
    final Response response = await get(
        baseUrl
    );
    final List<dynamic> decodedJson = jsonDecode(response.body);
    print(decodedJson.length);
    List<Product> products = List();
    for (int i = 0; i < decodedJson.length; i++) {
      products.add(Product.fromJson(decodedJson[i]));
      print(products[i].name);
    }
    return products;
  }

  Future save(Product product) async {
    final String transactionJson = jsonEncode(product.toJson());
    print(transactionJson);

    final Response response = await post('$baseUrl',
        headers: {
          'Content-type': "application/json;charset=UTF-8",
        },
        body: transactionJson)
        .timeout(Duration(seconds: 5));
//    if (response.statusCode == 200) {
//      return Product.fromJson(jsonDecode(response.body));
//    }
  }

  Future remove(Product product) async {
    final Response response =
    await delete('$baseUrl/${product.id}')
        .timeout(Duration(seconds: 5));
  }

  Future update(Product product) async {
    final String productJson = jsonEncode(product.toJson());
    final Response response =
    await put('$baseUrl/${product.id}',
        headers: {
          'Content-type': "application/json;charset=UTF-8",
        },
        body: productJson).timeout(Duration(seconds: 5));
  }
}
