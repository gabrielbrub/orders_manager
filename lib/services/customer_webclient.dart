import 'package:http/http.dart';
import 'dart:convert';
import 'package:ordersmanager/model/Customer.dart';

class CustomerWebClient {
  final String baseUrl = "http://192.168.15.19:8080/customers";
  Future<List<Customer>> findAll() async {
    final Response response = await get(
      baseUrl
    );
    final List<dynamic> decodedJson = jsonDecode(response.body);
    print(decodedJson.length);
    List<Customer> customers = List();
    for (int i = 0; i < decodedJson.length; i++) {
      customers.add(Customer.fromJson(decodedJson[i]));
      print(customers[i].name);
    }
    return customers;
  }

  Future save(Customer customer) async {
    final String transactionJson = jsonEncode(customer.toJson());

    final Response response = await post('$baseUrl',
            headers: {
              'Content-type': "application/json;charset=UTF-8",
            },
            body: transactionJson)
        .timeout(Duration(seconds: 5));
//    if (response.statusCode == 200) {
//      return Customer.fromJson(jsonDecode(response.body));
//    }
  }

  Future remove(Customer customer) async {
    final Response response =
        await delete('$baseUrl/${customer.id}')
            .timeout(Duration(seconds: 5));
  }

  Future update(Customer customer) async {
    final String transactionJson = jsonEncode(customer.toJson());
    final Response response =
    await put('$baseUrl/${customer.id}',
      headers: {
        'Content-type': "application/json;charset=UTF-8",
      },
      body: transactionJson).timeout(Duration(seconds: 5));
  }
}
