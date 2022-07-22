import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomListTile extends StatefulWidget {
  final String title;
  final Widget navigation;
  const CustomListTile(
      {Key? key, required this.navigation, required this.title})
      : super(key: key);

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: const Color(0xFF343434),
        child: ListTile(
            title: Text(widget.title,
                style: const TextStyle(color: Colors.orange, fontSize: 20)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => widget.navigation));
            }));
  }
}

class CustomFields extends StatefulWidget {
  final TextInputType type;
  final TextEditingController controller;
  final String text;
  final TextInputFormatter format;

  const CustomFields(
      {Key? key,
      required this.controller,
      required this.text,
      required this.type,
      required this.format})
      : super(key: key);
  @override
  State<CustomFields> createState() => _CustomFieldsState();
}

class _CustomFieldsState extends State<CustomFields> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
            color: const Color(0xFF121212),
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                    inputFormatters: [widget.format],
                    keyboardType: widget.type,
                    controller: widget.controller,
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                        label: Text(widget.text,
                            style: const TextStyle(fontSize: 17)),
                        hintStyle: const TextStyle(color: Colors.red))))));
  }
}
