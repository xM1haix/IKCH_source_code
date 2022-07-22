import 'package:flutter/material.dart';
import 'package:ikch/customwidget.dart';
import 'package:ikch/research.dart';

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.brown,
          title: const Text('Idle Kingdom Cliker Helper'),
        ),
        body: ListView(children: const [
          CustomListTile(title: 'Research', navigation: ResearchPage())
        ]));
  }
}
