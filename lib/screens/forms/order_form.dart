import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ordersmanager/components/date_time_field.dart';
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
  Order order;
  BasicDateTimeField basicDateTimeField;
  List<Customer> customers = List();

  @override
  void initState() {
    order = widget.order;
    if (!widget.isNew) {
      basicDateTimeField = BasicDateTimeField.withDate(DateTime.parse(order.date)); //remover enabled
      _itemMap = order.itemMap;
      _nameController.text = order.customerName;
      _cpfController.text = order.customerCpf;
    }else{
      basicDateTimeField = BasicDateTimeField();
    }
    _getMenuItems();
    super.initState();
  }

  void _getMenuItems() async{
    customers = await _customerWebClient.findAll();
    for(Customer c in customers){
      if(c!=null)
      menuItems.add(DropdownMenuItem<String>(child: Text(c.name), value: c.cpf));
    }

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Select from list: ', style: TextStyle(fontSize: 18),),
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: DropdownButton<String>(
                      hint: Text('Customer'),
                      items: menuItems,
                      onChanged: (value){
                        setState(() {
                          Customer customer = customers.singleWhere((c) => c.cpf == value);
                          _cpfController.text = customer.cpf;
                          _nameController.text = customer.name;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _nameController,
                enabled: widget.isNew, //nao pode alterar cliente de encomenda
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
                enabled: widget.isNew,
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
                  createTable(),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical:4),
              child: SizedBox(
                width: double.maxFinite,
                child: RaisedButton(
                  child: Text(widget.btnText),
                  onPressed: () async {
                    //var formatter = new DateFormat('yyyy-MM-dd HH:mm');
                    if (_itemMap.length > 0) {
                      setState(() {
                        _loading = true;
                      });
                      if (widget.isNew) {
                        Order order = Order(_cpfController.text,
                            basicDateTimeField.datePicked, _itemMap);
                        await _saveOrder(order);
                      } else {
                        order.date = basicDateTimeField.datePicked ?? order.date;
                        order.itemMap = _itemMap;
                        await _updateOrder();
                      }
                      await Future.delayed(Duration(seconds: 2));
                      Navigator.pop(context);
                    } else {
                      _showFailureMessage(
                          context, 'Order needs at least one item');
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
    await _webclient.update(order).catchError((e) {
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

  Widget createTable() {
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
      columnWidths: {
        1: IntrinsicColumnWidth(),
        2: IntrinsicColumnWidth(),
        3: IntrinsicColumnWidth()
      },
      children: createLines(),
    );
  }

  List<TableRow> createLines() {
    List<TableRow> rows = List();
    rows.add(TableRow(
      children: [
        Center(child: Text('Product')),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(child: Text('Amount')),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(child: Text('Actions')),
        ),
      ],
    ));
    _itemMap.forEach((product, amount) => rows.add(
          TableRow(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                child: Text(product),
              ),
              Center(child: Text(amount.toString())),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      setState(() {
                        if (amount <= 2) {
                          _itemMap[product] = 1;
                        } else {
                          _itemMap[product]--;
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() {
                        _itemMap[product]++;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_forever),
                    onPressed: () {
                      setState(() {
                        _itemMap.remove(product);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ));

    return rows;
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

