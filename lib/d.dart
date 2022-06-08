import 'dart:io';

import 'package:flutter_meteo/db/database.dart';
import 'package:flutter_meteo/models/city.dart';
import 'package:flutter_meteo/models/meteo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meteo/utils/glob_var.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'weather'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String search = "";
  late Future<Database> database;
  TextEditingController textfield = TextEditingController();
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      handler.deleteCityByName("Ouai");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(children: [
          TextField(
            controller: textfield,
            decoration: InputDecoration(
                suffixIcon: InkWell(
                    onTap: () {
                      handler.insertCity(textfield.text);
                      textfield.clear();
                    },
                    child: new Icon(Icons.add))),
          ),
          FutureBuilder<List<City>>(
            future: this.handler.retrieveCity(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("loading");
              } else if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(snapshot.data![index].name));
                  },
                );
              } else {
                return Container();
              }
            },
          )
        ]));
  }
}
