import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'widget/home.dart';

void main() => runApp(new CryptoApp());

class CryptoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Cryptocurrency',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(title: 'Cryptocurrency MarketCap'),
    );
  }
}

