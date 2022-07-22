import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class LevelPage extends StatefulWidget {
  final String parentid, id;
  final int level;
  const LevelPage(
      {Key? key, required this.id, required this.parentid, required this.level})
      : super(key: key);

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  late Stream<DocumentSnapshot> stream;
  double multi = 0;
  bool edit = true;
  @override
  void initState() {
    stream = FirebaseFirestore.instance
        .collection(widget.parentid)
        .doc(widget.id)
        .snapshots();
    super.initState();
    _activelisteners();
  }

  void _activelisteners() {
    FirebaseDatabase.instance
        .ref('production/${widget.level}')
        .onValue
        .listen((event) {
      setState(() {
        multi = event.snapshot.value as double;
      });
    });
  }

  Widget _delete(context, level, id) {
    return AlertDialog(
        title: Text('Are you sure you want to delete this level: "$level" '),
        content: const Text('Deletion is irreversible!'),
        actions: [
          OutlinedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection(widget.parentid)
                    .doc(id)
                    .delete();
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('Yes!')),
          OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No!'))
        ]);
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
                      ? Text('${snapshot.data!['level']}')
                      : const Text('Loading ...'),
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _delete(context, snapshot.data!['level'],
                                    widget.id);
                              });
                        },
                        icon: const Icon(Icons.delete, color: Colors.redAccent))
                  ]),
              body: Column(children: [
                const SizedBox(height: 25),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            NameText(text: 'Level'),
                            NameText(text: 'Multiplier'),
                            NameText(text: 'Price alphanumeric'),
                            NameText(text: 'Price scientific')
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            DataText(data: '${snapshot.data!['level']}'),
                            DataText(data: '$multi'),
                            DataText(
                                data:
                                    '${snapshot.data!['alphavalue']} ${snapshot.data!['alphaunit']}'),
                            DataText(
                                data:
                                    '${snapshot.data!['sciencevalue']} E${snapshot.data!['scienceunit']}')
                          ])
                    ])
              ]));
        });
  }
}

class NameText extends StatefulWidget {
  final String text;
  const NameText({Key? key, required this.text}) : super(key: key);

  @override
  State<NameText> createState() => _NameTextState();
}

class _NameTextState extends State<NameText> {
  @override
  Widget build(BuildContext context) {
    return Text('${widget.text}:',
        style: const TextStyle(fontSize: 24, color: Colors.white60));
  }
}

class DataText extends StatefulWidget {
  final String data;
  const DataText({Key? key, required this.data}) : super(key: key);

  @override
  State<DataText> createState() => _DataTextState();
}

class _DataTextState extends State<DataText> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.data,
        style: const TextStyle(fontSize: 24, color: Colors.orange));
  }
}
