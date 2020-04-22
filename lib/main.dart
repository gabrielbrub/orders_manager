import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(OrdersManager());

class OrdersManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[800],
        accentColor: Colors.green[500],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.green[500],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: HomeScreen(),
    );
  }
}