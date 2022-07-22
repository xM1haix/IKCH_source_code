import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ikch/level.dart';
import 'newlevel.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class Building extends StatefulWidget {
  final String parentid;

  final String id;
  const Building({Key? key, required this.id, required this.parentid})
      : super(key: key);

  @override
  State<Building> createState() => _BuildingState();
}

class _BuildingState extends State<Building> {
  bool alphabetic = true;
  late List multi;
  late Stream<DocumentSnapshot> stream;
  @override
  void initState() {
    stream = FirebaseFirestore.instance
        .collection('Research')
        .doc(widget.parentid)
        .collection('buildings')
        .doc(widget.id)
        .snapshots();
    super.initState();
    _activelisteners();
  }

  void _activelisteners() {
    FirebaseDatabase.instance.ref('production').onValue.listen((event) {
      setState(() {
        multi = event.snapshot.value as List;
      });
    });
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
                      : const Text('Loading ...'),
                  actions: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            alphabetic = !alphabetic;
                          });
                        },
                        icon: Icon((alphabetic)
                            ? MdiIcons.alphabetical
                            : MdiIcons.numeric))
                  ]),
              body: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Research')
                      .doc(widget.parentid)
                      .collection('buildings')
                      .doc(widget.id)
                      .collection('Levels')
                      .orderBy('level')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: Text('Loading'));
                    }
                    return ListView(
                        children: snapshot.data!.docs.map((reqest) {
                      return Card(
                          color: const Color(0xFF343434),
                          child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LevelPage(
                                            id: reqest['id'],
                                            level: reqest['level'],
                                            parentid:
                                                'Research/${widget.parentid}/buildings/${widget.id}/Levels')));
                              },
                              title: Text('${reqest['level']}',
                                  style: const TextStyle(
                                      color: Colors.orange, fontSize: 20)),
                              subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      const Text('Price: '),
                                      Text(
                                          (alphabetic)
                                              ? '${reqest['alphavalue']} ${reqest['alphaunit']}'
                                              : '${reqest['sciencevalue']} E${reqest['scienceunit']}',
                                          style: const TextStyle(
                                              color: Colors.orange))
                                    ]),
                                    Row(children: [
                                      const Text('Multiplier: '),
                                      Text('${multi[reqest['level']]}',
                                          style: const TextStyle(
                                              color: Colors.orange))
                                    ])
                                  ]),
                              isThreeLine: true));
                    }).toList());
                  }),
              floatingActionButton: FloatingActionButton(
                  tooltip: 'New building',
                  backgroundColor: const Color(0xFF444444),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewLevel(
                                id: widget.id, parentid: widget.parentid)));
                  },
                  child: const Icon(Icons.add, color: Colors.green)));
        });
  }
}
