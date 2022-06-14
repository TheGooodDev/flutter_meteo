import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meteo/db/database.dart';
import 'package:flutter_meteo/models/city.dart';
import 'package:flutter_meteo/models/meteo.dart';
import 'package:flutter_meteo/services/meteo_service.dart';
import 'package:intl/intl.dart';
import 'package:prompt_dialog/prompt_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather It',
      home: const MyHomePage(title: 'Weather It'),
      debugShowCheckedModeBanner: false,
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
  late TextEditingController controller;

  String name = '';
  String city = 'lyon';
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      handler.deleteCityByName("Ouai");
    });
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 91, 49, 132),
                // image: DecorationImage(
                //   image: AssetImage("images/kamehouse.jpg"),
                //   fit: BoxFit.cover,
                // ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Container(
                    child: Text('Weather`s City',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ),
                  SizedBox(height: 23),
                  ElevatedButton(
                      onPressed: () async {
                        //return print(await prompt(context));
                        final name = await SearchButton();
                        if (name == null || name.isEmpty) return;

                        setState(() {
                          handler.insertCity(name);
                        });
                        Navigator.pop;
                      },
                      child: Text('Search City'))
                ],
              ),
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
                      return ListTile(
                        title: Text(snapshot.data![index].name),
                        onTap: () {
                          setState(() {
                            city = snapshot.data![index].name.toLowerCase();
                          });
                        },
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            )
          ],
        ),
      ),
      body: FutureBuilder<List<City>>(
        future: this.handler.retrieveCity(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("loading");
          } else if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder<Meteo>(
              future: getMeteoData(city),
              builder: (context2, snapshot2) {
                if (snapshot2.connectionState == ConnectionState.waiting) {
                  return const Text("loading");
                } else if (snapshot2.connectionState == ConnectionState.done) {
                  Meteo meteo = snapshot2.data!;
                  return Column(
                      // children: [
                      //   Text(snapshot2.data!.city!.name),
                      //   Text(snapshot2.data!.list![0].temp.toString()),
                      //   Text(DateFormat("yyyy-MM-dd HH:mm:ss").format(
                      //       DateTime.fromMillisecondsSinceEpoch(
                      //           meteo.list![0].dt * 1000)))
                      // ],
                      children: [
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //mainAxisSize: MainAxisSize.max,
                          children: [
                            Center(
                                child: Icon(CupertinoIcons.location_solid,
                                    color: Colors.black)),
                            Center(
                              child: Text(snapshot2.data!.city!.name,
                                  style: TextStyle(
                                      fontFamily: 'TestFont',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 27)),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Image.asset(
                          'assets/images/sun.png',
                          height: 200,
                          width: 200,
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                              snapshot2.data!.list![0].temp.toString() + '°C',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'TestFont',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 70)),
                        ),
                        Center(
                          child: Text(snapshot2.data!.list![0].description,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'TestFont',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20)),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Wrap(
                              spacing: 10,
                              children: [
                                Text('Max. ' +
                                    snapshot2.data!.list![0].tempMax
                                        .toString()),
                                Text('Min. ' +
                                    snapshot2.data!.list![0].tempMin
                                        .toString()),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            height: 1.0,
                            width: 300,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          height: 100,
                          child: new ListView(
                            children: [
                              new Container(
                                height: 80.0,
                                child: new ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Row(
                                      children: [
                                        Card(
                                          child: new Container(
                                            width: 70.0,
                                            height: 70.0,
                                            child: Column(
                                              children: [
                                                Text(snapshot2
                                                    .data!.list![0].temp
                                                    .toString()),
                                                Image.asset(
                                                  'assets/images/sun.png',
                                                  height: 30,
                                                  width: 30,
                                                ),
                                                Text(DateFormat("HH:mm").format(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            meteo.list![0].dt *
                                                                1000)))
                                              ],
                                            ),
                                          ),
                                        ),
                                        Card(
                                          child: new Container(
                                            width: 70.0,
                                            height: 70.0,
                                            child: Column(
                                              children: [
                                                Text(snapshot2
                                                    .data!.list![1].temp
                                                    .toString()),
                                                Image.asset(
                                                  'assets/images/sun.png',
                                                  height: 30,
                                                  width: 30,
                                                ),
                                                Text(DateFormat("HH:mm").format(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            meteo.list![1].dt *
                                                                1000)))
                                              ],
                                            ),
                                          ),
                                        ),
                                        Card(
                                          child: new Container(
                                            width: 70.0,
                                            height: 70.0,
                                            child: Column(
                                              children: [
                                                Text(snapshot2
                                                    .data!.list![2].temp
                                                    .toString()),
                                                Image.asset(
                                                  'assets/images/sun.png',
                                                  height: 30,
                                                  width: 30,
                                                ),
                                                Text(DateFormat("HH:mm").format(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            meteo.list![2].dt *
                                                                1000)))
                                              ],
                                            ),
                                          ),
                                        ),
                                        Card(
                                          child: new Container(
                                            width: 70.0,
                                            height: 70.0,
                                            child: Column(
                                              children: [
                                                Text(snapshot2
                                                    .data!.list![3].temp
                                                    .toString()),
                                                Image.asset(
                                                  'assets/images/sun.png',
                                                  height: 30,
                                                  width: 30,
                                                ),
                                                Text(DateFormat("HH:mm").format(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            meteo.list![3].dt *
                                                                1000)))
                                              ],
                                            ),
                                          ),
                                        ),
                                        Card(
                                          child: new Container(
                                            width: 70.0,
                                            height: 70.0,
                                            child: Column(
                                              children: [
                                                Text(snapshot2
                                                    .data!.list![4].temp
                                                    .toString()),
                                                Image.asset(
                                                  'assets/images/sun.png',
                                                  height: 30,
                                                  width: 30,
                                                ),
                                                Text(DateFormat("HH:mm").format(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            meteo.list![4].dt *
                                                                1000)))
                                              ],
                                            ),
                                          ),
                                        ),
                                        Card(
                                          child: new Container(
                                            width: 70.0,
                                            height: 70.0,
                                            child: Column(
                                              children: [
                                                Text(snapshot2
                                                    .data!.list![5].temp
                                                    .toString()),
                                                Image.asset(
                                                  'assets/images/sun.png',
                                                  height: 30,
                                                  width: 30,
                                                ),
                                                Text(DateFormat("HH:mm").format(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            meteo.list![5].dt *
                                                                1000)))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 20,
                            ),
                            Text('Prévision pour les prochains jours')
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            height: 1.0,
                            width: 300,
                            color: Colors.black54,
                          ),
                        ),
                        
                      ]);
                } else {
                  return Container();
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Future<String?> SearchButton() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Search City'),
            content: TextField(
              autofocus: true,
              controller: controller,
              onSubmitted: (_) => submit(),
              decoration: InputDecoration(hintText: 'Enter City Name ?'),
            ),
            actions: [TextButton(onPressed: submit, child: Text('Ajouter'))],
          ));

  void submit() {
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }
}
