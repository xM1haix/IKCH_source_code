import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ikch/customwidget.dart';
import 'buildings.dart';

class TypeList extends StatefulWidget {
  final String id;
  const TypeList({Key? key, required this.id}) : super(key: key);
  @override
  State<TypeList> createState() => _TypeListState();
}

class _TypeListState extends State<TypeList> {
  late Stream<DocumentSnapshot> stream;
  @override
  void initState() {
    stream = FirebaseFirestore.instance
        .collection('Research')
        .doc(widget.id)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
          return Scaffold(
              appBar: AppBar(
                  backgroundColor: Colors.brown,
                  centerTitle: true,
                  title: (snapshot.hasData)
                      ? Text(snapshot.data!['name'])
                      : const Text('Loading ...')),
              body: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Research')
                      .doc(widget.id)
                      .collection('buildings')
                      .orderBy('tier')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text('Loading'));
                    }
                    return ListView(
                        children: snapshot.data!.docs.map((reqest) {
                      return CustomListTile(
                          navigation:
                              Building(id: reqest['id'], parentid: widget.id),
                          title: reqest['name']);
                    }).toList());
                  }));
        });
  }
}
