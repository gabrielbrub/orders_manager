import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ordersmanager/screens/forms/register_form.dart';
import 'package:ordersmanager/screens/home_screen.dart';
import 'package:ordersmanager/services/auth_webclient.dart';

class LoginForm extends StatefulWidget {
  final String title = 'Login';


  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  String password, email;
  bool _loading = false;
  AuthWebclient _webClient = new AuthWebclient();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  height: 64,
                ),
                Text("Orders Manager", style: TextStyle(color: Colors.white, fontFamily: 'OpenSans', letterSpacing: 1.0, fontSize: 32.0, fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 64,
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
                            style: TextStyle(
                            ),
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
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.email,),
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
                            onChanged: (value) {
                              password = value;
                            },
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('New here? ', style: TextStyle(color: Colors.white)),
                            InkWell(
                              onTap: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RegisterForm(),
                                  ),
                                );
                              },
                              child: Text('Create your account.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          ],
                        ),
                      ),
                      RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
//                      side: BorderSide(color: Colors.red)
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 48),//EdgeInsets.all(12),
                        child: Text('Login'),
                        textColor: Color(0xFF2DC880),
                        onPressed: () async {
                          //TODO: remover esses loadings
                          setState(() {
                            _loading = true;
                          });
                          if (_formKey.currentState.validate()) {
                            try {
                              String token = await _webClient.login(email, password);
                              await storage.write(key: "token", value: token);
                              Navigator
                                  .of(context)
                                  .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => HomeScreen(),));
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