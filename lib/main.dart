import 'package:my_stor/ItemPage.dart';
import 'package:flutter/material.dart';



void main() {
  // تهيئة SQLite على Windows/Desktop


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Item Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ItemPage(), // الصفحة الرئيسية
    );
  }
}