import 'package:flutter/material.dart';
import 'package:flutter_offline_mode/pages/home_page/home_page.dart';
import '../environments/flavors.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppFlavor.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
