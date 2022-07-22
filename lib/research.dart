import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ikch/customwidget.dart';
import '/typelist.dart';

class ResearchPage extends StatefulWidget {
  const ResearchPage({Key? key}) : super(key: key);
  @override
  State<ResearchPage> createState() => _ResearchPageState();
}

class _ResearchPageState extends State<ResearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Reseach'),
            centerTitle: true,
            backgroundColor: Colors.brown),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('Research').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text('Loading'));
              }
              return ListView(
                  children: snapshot.data!.docs.map((reqest) {
                return CustomListTile(
                    navigation: TypeList(id: reqest['id']),
                    title: reqest['name']);
              }).toList());
            }));
  }
}
