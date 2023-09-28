import 'package:flutter/material.dart';
import 'package:my_capstone_weather/pages/home_page_scaffold.dart';

void main() => runApp(const MaterialApp(home: MyHomePage()));

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomePageScaffold();
  }
}
