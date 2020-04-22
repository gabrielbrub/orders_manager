import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ordersmanager/model/Order.dart';
import 'package:ordersmanager/services/order_webclient.dart';

class OrderForm extends StatefulWidget {
  String title;
  String btnText;

//  String cpf, address, phoneNumber, name;
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
  TextEditingController _dateController = TextEditingController();
  OrderWebClient _webclient = OrderWebClient();
  bool _loading = false;
  DateTime _selectedDate;
  Map _itemMap;

  @override
  void initState() {
    if (!widget.isNew) {
      _nameController.text = widget.order.customerName;
      _cpfController.text = widget.order.customerCpf;
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
                controller: _cpfController,
                enabled: true,
                decoration: InputDecoration(
                  labelText: 'CPF',
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
                      IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: () {
                          
                        },
                      ),
                    ],
                  ),
                  createTable(widget.order.itemList),
//                  ListView.builder(
//                    physics: NeverScrollableScrollPhysics(),
//                    shrinkWrap: true,
//                    scrollDirection: Axis.vertical,
//                    itemBuilder: (context, index) {
//                      _itemMap = widget.order.itemList[index];
//                      String productName = _itemMap['product']['name'];
//                      return Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Text(productName),
//                          Text(_itemMap['amount'].toString()),
//                          IconButton(
//                            icon: Icon(Icons.remove_circle_outline),
//                            onPressed: () {
//                              setState(() {
//                                if (widget.order.itemList[index]['amount'] <=
//                                    2) {
//                                  widget.order.itemList[index]['amount'] = 1;
//                                } else {
//                                  widget.order.itemList[index]['amount']--;
//                                }
//                              });
//                            },
//                          ),
//                          IconButton(
//                            icon: Icon(Icons.add_circle_outline),
//                            onPressed: () {
//                              setState(() {
//                                widget.order.itemList[index]['amount']++;
//                              });
//                            },
//                          ),
//                          IconButton(
//                            icon: Icon(Icons.delete_forever),
//                            onPressed: () {
//                              setState(() {
//                                widget.order.itemList.removeAt(index);
//                              });
//                            },
//                          ),
//                        ],
//                      );
//                      //Text(productName);
//                    },
//                    itemCount: widget.order.itemList.length,
//                  ),
                ],
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
                    var formatter = new DateFormat('yyyy-MM-dd HH:mm');
//                    for (int i = 0; i < widget.order.itemList.length; i++){
//                      _itemMap = Order.toMap(widget.order.itemList);
//                    }
//                      Order order = Order(
//                        _nameController.text,
//                        _cpfController.text,
//                        formatter.format(_selectedDate),
//                        formatter.format(DateTime.now()),
//                        _itemMap);
                    setState(() {
                      _loading = true;
                    });
                    if (widget.isNew) {
                      //await _webclient.save(order);
                    } else {
                      print('before update:' + widget.order.itemList[0]['amount'].toString());
                      await _webclient.update(widget.order);
                    }
                    await Future.delayed(Duration(seconds: 2));
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 6,
                    child: TextField(
                      controller: _dateController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Order date',
                      ),
                      style: TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(
                        Icons.date_range,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () async {
                        _selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2018),
                          lastDate: DateTime(2030),
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.fallback(),
                              child: child,
                            );
                          },
                        );
                        _dateController.text =
                            ('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createTable(List itemList) {
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 1.0,
        ),
        verticalInside: BorderSide(
          color: Colors.black,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      columnWidths: {1: IntrinsicColumnWidth(), 2: IntrinsicColumnWidth(), 3:IntrinsicColumnWidth()},
      children: createLines(itemList),
    );
  }

  List<TableRow> createLines(List itemList) {
    List<TableRow> rows = List();
    rows.add(TableRow(
      children: [
        Center(child: Text('Product')),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text('Amount')),
        ),
        Center(child: Text('Actions')),
      ],
    ));
    for (int i = 0; i < itemList.length; i++) {
      rows.add(TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: Text(itemList[i]['product']['name']),
          ),
          Center(child: Text(itemList[i]['amount'].toString())),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: () {
                  setState(() {
                    if (widget.order.itemList[i]['amount'] <= 2) {
                      widget.order.itemList[i]['amount'] = 1;
                    } else {
                      widget.order.itemList[i]['amount']--;
                    }
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  setState(() {
                    widget.order.itemList[i]['amount']++;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  setState(() {
                    widget.order.itemList.removeAt(i);
                  });
                },
              ),
            ],
          ),
        ],
      ));
    }
    return rows;
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
