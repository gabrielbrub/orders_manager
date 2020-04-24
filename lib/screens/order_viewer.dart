import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ordersmanager/components/item_table.dart';
import 'package:ordersmanager/model/Customer.dart';
import 'package:ordersmanager/model/Order.dart';
import 'package:ordersmanager/services/order_webclient.dart';

class OrderViewer extends StatefulWidget {
  Order order;

  OrderViewer(order) {
    this.order = order;
  }

  @override
  _OrderViewerState createState() => _OrderViewerState();
}

class _OrderViewerState extends State<OrderViewer> {
  final String title = 'Order View';
  final String btnText = 'Done';
  OrderWebClient _webClient = OrderWebClient();
  bool _loading = false;
  Map _itemMap = Map();
  Order _order;
  List<Customer> customers = List();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _statusController = TextEditingController();

  @override
  void initState() {
    _order = widget.order;
    _itemMap = _order.itemMap;
    _statusController.text = _order.status;
    _nameController.text = _order.customerName;
    _cpfController.text = _order.customerCpf;
    _dateController.text = _order.date;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                enabled: false,
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
                maxLength: 11,
                keyboardType: TextInputType.number,
                controller: _cpfController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'CPF',
                  counterText: '',
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLength: 11,
                keyboardType: TextInputType.number,
                controller: _dateController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Date',
                  counterText: '',
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLength: 11,
                keyboardType: TextInputType.number,
                controller: _statusController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Status',
                  counterText: '',
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            Card(
              child: ExpansionTile(
                title: Text('Items'),
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Center(child: Text('Add item')),
                      Icon(
                        Icons.add_circle,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                  ItemTable(itemMap: _itemMap, editable: false),
                ],
              ),
            ),
            Visibility(
              visible: _order.status == 'ACTIVE' ? true : false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: SizedBox(
                  width: double.maxFinite,
                  child: RaisedButton(
                      child: Text(btnText),
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                        });
                        _order.status = 'DONE';
                        _order.date = DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now());
                        _updateOrder();
                        await Future.delayed(Duration(seconds: 2));
                        Navigator.pop(context);
                      }),
                ),
              ),
            ),
            Visibility(
              visible: _order.status == 'ACTIVE' ? true : false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: RaisedButton(
                    color: Colors.red,
                    child: Text('Cancel'),
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      _order.status = 'CANCELED';
                      await _webClient.update(_order);
                      await Future.delayed(Duration(seconds: 2));
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _updateOrder() async {
    await _webClient.update(_order).catchError((e) {
      _showFailureMessage(context, 'request timeout');
    }, test: (e) => e is TimeoutException).catchError((e) {
      _showFailureMessage(context, 'unknown error');
    });
  }


  void _showFailureMessage(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Text(message),
              title: Text('Error'),
              actions: <Widget>[
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
