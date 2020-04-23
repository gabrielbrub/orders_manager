import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ordersmanager/components/fetch_error.dart';
import 'package:ordersmanager/screens/forms/customer_form.dart';
import 'package:ordersmanager/services/customer_webclient.dart';

import '../model/Customer.dart';

class CustomersList extends StatefulWidget {
  @override
  _CustomersListState createState() => _CustomersListState();
}

class _CustomersListState extends State<CustomersList> {
  CustomerWebClient webClient = CustomerWebClient();
  List<Customer> customers = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          initialData: List(),
          future: webClient.findAll(),
          builder: (context, snapshot) {
            //List<Customer> customers = List();
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) customers = snapshot.data;
              if (customers.isNotEmpty) {
                return ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                CustomerForm.view(customers[index]),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          trailing: menu(index),
                          title: Text(customers[index].name),
                        ),
                      ),
                    );
                  },
                );
              }
              if (snapshot.hasError) return FetchError();
              return Center(
                child: Text('Empty'),
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CustomerForm(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget menu(int index) {
    return PopupMenuButton<int>(
      onSelected: (int result) async {
        switch (result) {
          case 1:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CustomerForm.editor(customers[index]),
              ),
            );
            break;
          case 2:
            await webClient.remove(customers[index]).catchError((e) {
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

