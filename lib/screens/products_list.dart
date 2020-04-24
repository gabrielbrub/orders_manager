import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ordersmanager/components/fetch_error.dart';
import 'package:ordersmanager/model/Product.dart';
import 'package:ordersmanager/screens/forms/product_form.dart';
import 'package:ordersmanager/services/product_webclient.dart';

class ProductsList extends StatefulWidget {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  ProductWebClient _webClient = ProductWebClient();

  @override
  Widget build(BuildContext context) {
    List<Product> products = List();
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          initialData: List(),
          future: _webClient.findAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) products = snapshot.data;
              if (products.isNotEmpty) {
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProductForm.view(products[index]),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          trailing: menu(products[index], index),
                          title: Text(products[index].name),
                        ),
                      ),
                    );
                  },
                );
              }
              if (snapshot.hasError) return FetchError();
              return Center(child: Text('Empty'),);
            }
            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductForm(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget menu(Product product, int index) {
    return PopupMenuButton<int>(
      onSelected: (int result) async {
        switch (result) {
          case 1:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProductForm.editor(product),
              ),
            );
            break;
          case 2:
            await _webClient.remove(product).catchError((e) {
              _showFailureMessage(context, 'request timeout');
            }, test: (e) => e is TimeoutException).catchError((e) {
              _showFailureMessage(context, 'unknown error');
            });
            setState(() {});
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Edit"),
        ),
        PopupMenuItem(
          value: 2,
          child: Text("Delete"),
        ),
      ],
    );
  }

  void _showFailureMessage(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(message), actions: <Widget>[
            FlatButton(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ]);
        });
  }
}
