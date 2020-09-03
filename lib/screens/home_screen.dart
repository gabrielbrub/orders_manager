import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ordersmanager/screens/forms/login_form.dart';
import 'package:ordersmanager/screens/history.dart';
import 'package:ordersmanager/screens/products_list.dart';

import 'customers_list.dart';
import 'orders_list.dart';

class HomeScreen extends StatelessWidget {
  final Color cardColor = Color(0xFF48D594);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Manager'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app,
              color: Colors.white,
          ),
            onPressed: () async {_logoutAndRedirect(context);},
          ),
        ],
      ),
//      drawer: Drawer(
//        child: ListView(
//          children: <Widget>[
//            DrawerHeader(
//              decoration: BoxDecoration(
//                color: Color(0xFF48D594),
//              ),
//            ),
//            FlatButton(
//              onPressed: () async {_logoutAndRedirect(context);},
//              child: Container(
//                  padding: EdgeInsets.symmetric(vertical: 8),
//                  child: Row(children: <Widget>[Text('Logout'), SizedBox(width: 6) ,Icon(Icons.exit_to_app)]),
//              ),
//            ),
//          ],
//        ),
//      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(8),
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CustomersList(),
              ));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(),
                    Icon(
                      Icons.people,
                      size: 56,
                      color: Colors.white,
                    ),
                    Text(
                      'Customers',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductsList(),
              ));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: Color(0xFF48D594),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(),
                    Icon(
                      Icons.shop_two,
                      size: 56,
                      color: Colors.white,
                    ),
                    Text(
                      'Products',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OrdersList(),
              ));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(),
                    Icon(
                      Icons.playlist_add_check,
                      size: 56,
                      color: Colors.white,
                    ),
                    Text(
                      'Orders',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => History(),
              ));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(),
                    Icon(
                      Icons.history,
                      size: 56,
                      color: Colors.white,
                    ),
                    Text(
                      'History',
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _logoutAndRedirect(BuildContext context) async{
    final storage = new FlutterSecureStorage();
    await storage.deleteAll();
    Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => LoginForm()), (Route<dynamic> route) => false);
//    Navigator
//        .of(context)
//        .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) => LoginForm(),));
  }

}
