import 'package:flutter/material.dart';
import 'package:ordersmanager/model/Product.dart';
import 'package:ordersmanager/screens/forms/product_form.dart';
import 'package:ordersmanager/services/product_webclient.dart';

class ProductPickList extends StatefulWidget {
  @override
  _ProductPickListState createState() => _ProductPickListState();
}

class _ProductPickListState extends State<ProductPickList> {
  ProductWebClient webClient = ProductWebClient();

  @override
  Widget build(BuildContext context) {
    Product product;
    List<Product> products = List();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          initialData: List(),
          future: webClient.findAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) products = snapshot.data;
              if (products.isNotEmpty) {
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        trailing: IconButton(icon: Icon(Icons.add), onPressed: (){
                          Navigator.pop(context, products[index]);
                        },),
                        title: Text(products[index].name),
                      ),
                    );
                  },
                );
              }
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