// lib/main.dart
import 'package:flutter/material.dart';
import 'pages/airplane_list_page.dart';
import 'pages/customer_form_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airplane Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AirplaneListPage(),
    );
  }
}
