import 'package:flutter/material.dart';
import 'package:ordersmanager/screens/forms/login_form.dart';
import 'screens/home_screen.dart';

void main() => runApp(OrdersManager());

class OrdersManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF2AB775), //(0xFF2DC880)
        accentColor: Color(0xFF26A66A), //(0Xff59D99D)
        primaryTextTheme: TextTheme(
            title: TextStyle(
                color: Colors.white
            )
        ),
        primaryIconTheme: const IconThemeData.fallback().copyWith(
          color: Colors.white,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF26A66A),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: HomeScreen(),//LoginForm(),
    );
  }
}