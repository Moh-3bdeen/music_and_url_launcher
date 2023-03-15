import 'package:flutter/material.dart';
import 'all_instruments.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musical Instruments',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AllMusicalInstruments(),
    );
  }
}
