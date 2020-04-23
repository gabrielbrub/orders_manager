import 'package:flutter/material.dart';
import 'package:ordersmanager/components/fetch_error.dart';
import 'package:ordersmanager/model/Order.dart';
import 'package:ordersmanager/services/order_webclient.dart';

import 'order_viewer.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  OrderWebClient webClient = OrderWebClient();
  @override
  Widget build(BuildContext context) {
    List<Order> orders = List();
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          initialData: List(),
          future: webClient.findAllFinished(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) orders = snapshot.data;
              if (orders.isNotEmpty) {
                orders = orders.reversed.toList();
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
    );
  }
}



