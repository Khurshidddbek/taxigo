import 'package:flutter/material.dart';
import 'package:taxigo/screens/main_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TAXIGO',
      theme: ThemeData(
        fontFamily: "Brand-Regular",
      ),
      home: const MainPage(),
    );
  }
}
