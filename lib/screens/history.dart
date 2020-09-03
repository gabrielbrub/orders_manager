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
  OrderWebClient _webClient = OrderWebClient();
  Future<List<Order>> _future;
  int page = 0;
  List<Order> orders = List();


  Future<List<Order>> loadData() async {
    orders = await _webClient.findAllFinished(page);
    debugPrint("PAGE: "+ page.toString());
    return orders;
  }


  @override
  Widget build(BuildContext context) {
//    List<Order> orders = List();
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          initialData: List(),
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) orders = snapshot.data;
              if (orders.isNotEmpty) {
                orders = orders.reversed.toList();
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
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
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        IconButton(icon: Icon(Icons.navigate_before),
                          onPressed: (){
                            if(page>0) {
                              page--;
                              setState(() {
                                _future = loadData();
                              });
                            }
                          },
                        ),
                        Text("Page ${page+1} of ${_webClient.numPages}"),
                        IconButton(icon: Icon(Icons.navigate_next),
                          onPressed: (){
                            if(page<_webClient.numPages-1) {
                              page++;
                              setState(() {
                                _future = loadData();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                );
              }
              if (snapshot.hasError) return FetchError();
              return Center(child: Text('Empty'),);
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  @override
  void initState() {
    _future = loadData();
    super.initState();
  }
}



