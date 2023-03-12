import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  static const String id = "main";

  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Main Page"),
      ),
    );
  }
}
