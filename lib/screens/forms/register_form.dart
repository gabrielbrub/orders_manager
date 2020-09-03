import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ordersmanager/screens/home_screen.dart';
import 'package:ordersmanager/services/auth_webclient.dart';

import 'login_form.dart';

class RegisterForm extends StatefulWidget {
  final String title = 'Create Account';


  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  String password, email, username;
  bool _loading = false;
  AuthWebclient _webClient = new AuthWebclient();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0Xff59D99D),
                  Color(0xFF48D594),
                  Color(0xFF37D28A),
                  Color(0xFF2DC880),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: _loading,
                  child: LinearProgressIndicator(),
                ),
                SizedBox(
                  height: 12,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 20.0,
                          shadowColor: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                          child: TextFormField(

                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              username = value;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.account_box,),
                              border: InputBorder.none,
                              labelText: 'Username',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 20.0,
                          shadowColor: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty || !value.contains('@') || !value.contains('.')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email,),
                              border: InputBorder.none,
                              labelText: 'Email',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 20.0,
                          shadowColor: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a valid password';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock,),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                color: _obscureText?Colors.black38:Colors.black,
                                onPressed: (){
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              border: InputBorder.none,
                              labelText: 'Password',
                            ),
                          ),
                        ),
                      ),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 48),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text('Create'),
                        textColor: Color(0xFF2DC880),
                        onPressed: () async {
                          setState(() {
                            _loading = true;
                          });
                          if (_formKey.currentState.validate()){
                            try {
                              await _webClient.register(email, password, username);
                              Navigator
                                  .of(context)
                                  .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => LoginForm(),));
                            } on TimeoutException catch (e) {
                              showErrorDialog('Server not responding');
                            }
                          }
                          setState(() {
                            _loading = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showErrorDialog(String text){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Error'),
        content: Text(text),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }
}