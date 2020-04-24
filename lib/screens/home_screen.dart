import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ordersmanager/screens/history.dart';
import 'package:ordersmanager/screens/products_list.dart';

import 'customers_list.dart';
import 'orders_list.dart';

class HomeScreen extends StatelessWidget {
  final Color cardColor = Colors.lightGreen[100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Orders Manager'),
        centerTitle: true,
      ),
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
              color: Colors.lightGreen[100],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(),
                    Icon(
                      Icons.people,
                      size: 64,
                    ),
                    Text(
                      'Customers',
                      style: TextStyle(fontSize: 18),
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
              color: Colors.lightGreen[100],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(),
                    Icon(
                      Icons.shop_two,
                      size: 64,
                    ),
                    Text(
                      'Products',
                      style: TextStyle(fontSize: 18),
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
                      size: 64,
                    ),
                    Text(
                      'Orders',
                      style: TextStyle(fontSize: 18),
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
                      size: 64,
                    ),
                    Text(
                      'History',
                      style: TextStyle(fontSize: 18),
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

}
