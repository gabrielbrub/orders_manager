import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ordersmanager/components/fetch_error.dart';
import 'package:ordersmanager/model/Order.dart';

import 'package:ordersmanager/screens/forms/order_form.dart';
import 'package:ordersmanager/screens/order_viewer.dart';
import 'package:ordersmanager/services/order_webclient.dart';

class OrdersList extends StatefulWidget {
  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  OrderWebClient webClient = OrderWebClient();

  @override
  Widget build(BuildContext context) {
    List<Order> orders = List();
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          initialData: List(),
          future: webClient.findAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) orders = snapshot.data;
              if (orders.isNotEmpty) {
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OrderViewer(orders[index]),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          trailing: menu(orders[index], index),
                          title: Text(orders[index].customerName),
                          subtitle: Text(orders[index].date),
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
              builder: (context) => OrderForm(),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget menu(Order order, int index) {
    return PopupMenuButton<int>(
      onSelected: (int result) async {
        switch (result) {
          case 1:
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OrderForm.editor(order),
              ),
            );
            break;
          case 2:
            await webClient.remove(order).catchError((e) {
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
