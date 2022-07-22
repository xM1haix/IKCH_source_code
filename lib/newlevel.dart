import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'customwidget.dart';

class NewLevel extends StatefulWidget {
  final String id;
  final String parentid;
  const NewLevel({Key? key, required this.id, required this.parentid})
      : super(key: key);

  @override
  State<NewLevel> createState() => _NewLevelState();
}

class _NewLevelState extends State<NewLevel> {
  final level = TextEditingController();
  final value = TextEditingController();
  final unit = TextEditingController();
  bool type = false;
  bool empty = false;
  double alphavalue = 0;
  double sciencevalue = 0;
  String alphaunit = '';
  int scienceunit = 0;
  bool ready = false;
  checker() async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('Research')
        .doc(widget.parentid)
        .collection('buildings')
        .doc(widget.id)
        .collection('Levels')
        .where('level', isEqualTo: int.parse(level.text))
        .get();
    empty = result.docs.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    Map unities = {
      0: '',
      3: 'k',
      6: 'M',
      9: 'B',
      12: 'T',
      15: 'aa',
      18: 'ab',
      21: 'ac',
      24: 'ad',
      27: 'ae',
      30: 'af',
      33: 'ag',
      36: 'ah',
      39: 'ai',
      42: 'aj',
      45: 'ak',
      48: 'al',
      51: 'am',
      54: 'an',
      57: 'ao',
      60: 'ap',
      63: 'aq',
      66: 'ar',
      69: 'as',
      72: 'at',
      75: 'au'
    };
    return Scaffold(
        appBar: AppBar(
            title: const Text('Add New Level'),
            backgroundColor: Colors.brown,
            centerTitle: true),
        body: ListView(children: [
          CustomFields(
              controller: level,
              text: 'Level',
              type: TextInputType.number,
              format: FilteringTextInputFormatter.digitsOnly),
          Center(
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      type = !type;
                    });
                  },
                  child: Text((type) ? 'Scientific' : 'Letters'))),
          CustomFields(
              controller: value,
              text: 'Value',
              type: TextInputType.number,
              format: FilteringTextInputFormatter.allow(RegExp('[0-9,.]'))),
          CustomFields(
              controller: unit,
              text: 'Unity',
              type: TextInputType.number,
              format: FilteringTextInputFormatter.allow(
                  (type) ? RegExp('[0-9]') : RegExp('[a-z]'))),
          Container(
              padding: const EdgeInsets.all(20),
              child: const Text('*Fields cannot be empty',
                  style: TextStyle(color: Colors.red)))
        ]),
        floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF444444),
            child: const Icon(Icons.save_outlined, color: Colors.green),
            onPressed: () async {
              final QuerySnapshot result = await FirebaseFirestore.instance
                  .collection('Research')
                  .doc(widget.parentid)
                  .collection('buildings')
                  .doc(widget.id)
                  .collection('Levels')
                  .where('level', isEqualTo: int.parse(level.text))
                  .get();
              if (result.docs.isEmpty &&
                  level.text != '' &&
                  value.text != '' &&
                  unit.text != '' &&
                  (((double.parse(value.text) < 1001) && !type) ||
                      ((double.parse(value.text) < 10) && type))) {
                if (type) {
                  createenter(
                      id: widget.id,
                      level: int.parse(level.text),
                      alphavalue: double.parse(value.text) *
                          pow(10, int.parse(unit.text) % 3),
                      alphaunit: unities[
                          int.parse(unit.text) - int.parse(unit.text) % 3],
                      scienceunit: int.parse(unit.text),
                      sciencevalue: double.parse(value.text),
                      parentid: widget.parentid);
                } else {
                  setState(() {
                    sciencevalue = double.parse(value.text);
                    scienceunit = unities.keys
                        .firstWhere((element) => unities[element] == unit.text);
                    if (sciencevalue > 10) {
                      do {
                        sciencevalue = sciencevalue / 10;
                        scienceunit = scienceunit + 1;
                      } while (sciencevalue > 10);
                    }
                  });
                  createenter(
                      id: widget.id,
                      level: int.parse(level.text),
                      alphavalue: double.parse(value.text),
                      alphaunit: unit.text,
                      scienceunit: scienceunit,
                      sciencevalue: sciencevalue,
                      parentid: widget.parentid);
                }
                if (!mounted) return;
                Navigator.of(context).pop();
              }
            }));
  }
}

class Zone {
  String id;
  final int level;
  final String alphaunit;
  final double sciencevalue, alphavalue;
  final int scienceunit;

  Zone(
      {this.id = '',
      required this.level,
      required this.scienceunit,
      required this.sciencevalue,
      required this.alphavalue,
      required this.alphaunit});
  Map<String, dynamic> toJson() => {
        'id': id,
        'level': level,
        'scienceunit': scienceunit,
        'sciencevalue': sciencevalue,
        'alphavalue': alphavalue,
        'alphaunit': alphaunit
      };
  static Zone fromJson(Map<String, dynamic> json) => Zone(
      id: json['id'],
      level: json['level'],
      scienceunit: json['scienceunit'],
      sciencevalue: json['sciencevalue'],
      alphavalue: json['alphavalue'],
      alphaunit: json['alphaunit']);
}

Future createenter(
    {required int level,
    required id,
    required parentid,
    required alphavalue,
    required sciencevalue,
    required scienceunit,
    required alphaunit}) async {
  final doc = FirebaseFirestore.instance
      .collection('Research')
      .doc(parentid)
      .collection('buildings')
      .doc(id)
      .collection('Levels')
      .doc();
  final req = Zone(
      id: doc.id,
      level: level,
      scienceunit: scienceunit,
      sciencevalue: sciencevalue,
      alphavalue: alphavalue,
      alphaunit: alphaunit);
  final json = req.toJson();
  await doc.set(json);
}
