import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();

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
                color: Color.fromARGB(255, 216, 80, 89),
              ),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Container(
                    child: Text('Weather`s City',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () async {
                        //return print(await prompt(context));
                        final name = await SearchButton();
                        if (name == null || name.isEmpty) return;

                        setState(() {
                          this.name = name;
                        });
                      },
                      child: Text('Search City'))
                ],
              ),
            ),
            // Row(
            //   children: [
            //     Expanded(child: Text('Name: ', style: TextStyle(fontSize: 15))),
            //     SizedBox(width: 9),
            //     Text(name),
            //   ],
            // ),
            ListTile(
              title: Text(name),
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => ()),
              //   );
              // }
            ),
            ListTile(
              title: const Text('Nom de ville'),
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => ()),
              //   );
              // },
            ),
          ],
        ),
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
