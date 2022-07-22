import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'base.dart';

void main() {
  WidgetsFlutterBinding();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Scaffold(
            body: Container(
                color: const Color(0xFF000000),
                child: FutureBuilder(
                    future: _fbApp,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Connection error');
                      } else if (snapshot.hasData) {
                        return const BasePage();
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }))));
  }
}
