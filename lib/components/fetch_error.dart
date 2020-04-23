import 'package:flutter/material.dart';

class FetchError extends StatelessWidget {
  const FetchError({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            size: 32,
            color: Colors.grey[700],
          ),
          Text(
            'Error',
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}