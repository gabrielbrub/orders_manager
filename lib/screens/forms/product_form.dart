import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ordersmanager/model/Product.dart';
import 'package:ordersmanager/services/product_webclient.dart';

class ProductForm extends StatefulWidget {
  String title;
  String btnText;

//  String cpf, address, phoneNumber, name;
  Product product;
  bool isNew = true;

  ProductForm.editor(product) {
    title = 'Edit product';
    btnText = 'Save';
    isNew = false;
    this.product = product;
//    this.cpf = product.cpf;
//    this.address = product.address;
//    this.phoneNumber = product.phoneNumber;
//    this.name = product.name;
  }

  ProductForm() {
    title = 'New product';
    btnText = 'Add';
  }

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  ProductWebClient _webclient = ProductWebClient();
  bool _loading = false;

  @override
  void initState() {
    if (!widget.isNew) {
      _nameController.text = widget.product.name;
      _priceController.text = widget.product.price.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Visibility(
              child: LinearProgressIndicator(),
              visible: _loading,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _nameController,
                enabled: true,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLength: 6,
                keyboardType: TextInputType.number,
                controller: _priceController,
                enabled: true,
                decoration: InputDecoration(
                  labelText: 'Price',
                  counterText: '',
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: SizedBox(
                width: double.maxFinite,
                child: RaisedButton(
                  child: Text(widget.btnText),
                  onPressed: () async {
                    Product product = Product(_nameController.text,
                        double.parse(_priceController.text));
                    setState(() {
                      _loading = true;
                    });
                    if (widget.isNew) {
                      await _saveProduct(product, context);
                    } else {
                      await _updateProduct(product, context);
                    }
                    await Future.delayed(Duration(seconds: 2));
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _saveProduct(Product product, BuildContext context) async {
    await _webclient.save(product).catchError((e) {
      _showFailureMessage(context, 'request timeout');
    }, test: (e) => e is TimeoutException).catchError((e) {
      _showFailureMessage(context, 'unknown error');
    });
  }

  Future _updateProduct(Product product, BuildContext context) async {
    product.id = widget.product.id;
    await _webclient.update(product).catchError((e) {
      _showFailureMessage(context, 'request timeout');
    }, test: (e) => e is TimeoutException).catchError((e) {
      _showFailureMessage(context, 'unknown error');
    });
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
