import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ordersmanager/components/date_time_field.dart';
import 'package:ordersmanager/components/item_table.dart';
import 'package:ordersmanager/model/Customer.dart';
import 'package:ordersmanager/model/Order.dart';
import 'package:ordersmanager/model/Product.dart';
import 'package:ordersmanager/screens/product_pick_list.dart';
import 'package:ordersmanager/services/customer_webclient.dart';
import 'package:ordersmanager/services/order_webclient.dart';

class OrderForm extends StatefulWidget {
  String title;
  String btnText;
  Order order;
  bool isNew = true;


  OrderForm.editor(order) {
    title = 'Edit order';
    btnText = 'Save';
    isNew = false;
    this.order = order;
  }

  OrderForm() {
    title = 'New order';
    btnText = 'Add';
  }

  @override
  _OrderFormState createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  OrderWebClient _webclient = OrderWebClient();
  CustomerWebClient _customerWebClient = CustomerWebClient();
  bool _loading = false;
  Map _itemMap = Map();
  List<DropdownMenuItem<String>> menuItems = List();
  Order _order;
  BasicDateTimeField basicDateTimeField;
  List<Customer> _customers = List();

  @override
  void initState() {
    _getMenuItems();
    _order = widget.order;
    if (!widget.isNew) {
      basicDateTimeField = BasicDateTimeField.withDate(
          DateTime.parse(_order.date)); //remover enabled
      _itemMap = _order.itemMap;
      _nameController.text = _order.customerName;
      _cpfController.text = _order.customerCpf;
    } else {
      basicDateTimeField = BasicDateTimeField();
    }
    super.initState();
  }

   _getMenuItems() async {
    _customers = await _customerWebClient.findAll();
    for (Customer c in _customers) {
      if (c != null)
        menuItems.add(DropdownMenuItem<String>(child: Text(c.name), value: c.cpf));
    }
    setState(() {
    });
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
            Visibility(
              visible: widget.isNew,
              child: Container(
                height: 50,
                padding: EdgeInsets.all(8.0),
                //width: double.maxFinite,
                child: DropdownButton<String>(
                  hint: Text('Select customer from list'),
                  items: menuItems,
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      Customer customer =
                          _customers.singleWhere((c) => c.cpf == value);
                      _cpfController.text = customer.cpf;
                      _nameController.text = customer.name;
                    });
                  },
                ),
              ),
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
            basicDateTimeField,
            Card(
              child: ExpansionTile(
                title: Text('Items'),
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Center(child: Text('Add item')),
                      IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: () async {
                          Product product = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductPickList(),
                            ),
                          );
                          setState(() {
                            if (product != null)
                              _itemMap.putIfAbsent(product.name, () => 1);
                          });
                        },
                      ),
                    ],
                  ),
                  ItemTable(
                    itemMap: _itemMap,
                    editable: true,
                    onIncrement: (String product) {
                      setState(() {
                        _itemMap[product]++;
                      });
                    },
                    onDecrement: (String product, int amount) {
                      setState(() {
                        if (amount <= 2) {
                          _itemMap[product] = 1;
                        } else {
                          _itemMap[product]--;
                        }
                      });
                    },
                    onDelete: (String product) {
                      setState(() {
                        _itemMap.remove(product);
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: SizedBox(
                width: double.maxFinite,
                child: RaisedButton(
                  child: Text(widget.btnText),
                  onPressed: () async {
                    if (_itemMap.length > 0) {
                      setState(() {
                        _loading = true;
                      });
                      if (widget.isNew) {
                        _order = Order(_cpfController.text,
                            basicDateTimeField.datePicked, _itemMap);
                        await _saveOrder(_order);
                      } else {
                        _order.date =
                            basicDateTimeField.datePicked ?? _order.date;
                        _order.itemMap = _itemMap;
                        await _updateOrder();
                      }
                      await Future.delayed(Duration(seconds: 2));
                      Navigator.pop(context);
                    } else {
                      _showFailureMessage(
                          context, 'Order requires at least one item');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _updateOrder() async {
    await _webclient.update(_order).catchError((e) {
      _showFailureMessage(context, 'request timeout');
    }, test: (e) => e is TimeoutException).catchError((e) {
      _showFailureMessage(context, 'unknown error');
    });
  }

  Future _saveOrder(Order order) async {
    await _webclient.save(order).catchError((e) {
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
