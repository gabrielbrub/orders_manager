import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ordersmanager/model/Customer.dart';
import 'package:ordersmanager/services/customer_webclient.dart';


class CustomerForm extends StatefulWidget {
  String title;
  String btnText;
//  String cpf, address, phoneNumber, name;
  Customer customer;
  bool isNew = true;
  CustomerForm.editor(customer){
    title = 'Edit customer';
    btnText = 'Save';
    isNew = false;
    this.customer = customer;
//    this.cpf = customer.cpf;
//    this.address = customer.address;
//    this.phoneNumber = customer.phoneNumber;
//    this.name = customer.name;
  }
  CustomerForm(){title = 'New customer'; btnText = 'Add';}
  @override
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  CustomerWebClient _webclient = CustomerWebClient();
  bool _loading=false;

  @override
  void initState() {
    if(!widget.isNew) {
      _addressController.text = widget.customer.address;
      _nameController.text = widget.customer.name;
      _phoneNumberController.text = widget.customer.phoneNumber;
      _cpfController.text = widget.customer.cpf;
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
                controller: _addressController,
                enabled: true,
                decoration: InputDecoration(
                  labelText: 'Address',
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
                enabled: true,
                decoration: InputDecoration(
                  labelText: 'CPF',
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
                controller: _phoneNumberController,
                enabled: true,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: SizedBox(
                width: double.maxFinite,
                child: RaisedButton(
                  child: Text(widget.btnText),
                  onPressed: () async {
                    Customer customer = Customer(_nameController.text, _cpfController.text,
                        _addressController.text, _phoneNumberController.text);
                    setState(() {
                      _loading = true;
                    });
                    if(widget.isNew) {
                      await _saveCustomer(customer, context);
                    }else{
                      await _updateCustomer(customer, context);
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

  Future _saveCustomer(Customer customer, BuildContext context) async {
    await _webclient.save(customer)
        .catchError((e) {
      _showFailureMessage(context, 'request timeout');
    }, test: (e) => e is TimeoutException).catchError((e) {
      _showFailureMessage(context, 'unknown error');
    });
  }

  Future _updateCustomer(Customer customer, BuildContext context) async {
    customer.id = widget.customer.id;
    await _webclient.update(customer)
        .catchError((e) {
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
