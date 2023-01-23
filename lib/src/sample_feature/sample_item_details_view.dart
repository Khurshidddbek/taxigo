import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatelessWidget {
  SampleItemDetailsView({super.key});

  static const routeName = '/sample_item';

  final DatabaseReference ref = FirebaseDatabase.instance.ref();

  void _testWrite() async {
    await ref.set({"testing": "test"});
  }

  void _deleteTestWrittenValue() async {
    await ref.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
              onPressed: _testWrite,
              child: const Text("TEST WRITE"),
            ),
            CupertinoButton(
              onPressed: _deleteTestWrittenValue,
              child:
                  Text("Delete the value written by test write".toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}
