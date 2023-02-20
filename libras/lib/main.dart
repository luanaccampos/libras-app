import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:developer' as dev;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    home: const Home(),
    theme: ThemeData(
      primaryColor: const Color.fromRGBO(0, 48, 135, 1),
    ),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const platform = MethodChannel('teste');
  String s = "libras";
  List r = [];
  List classes = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'i',
    'l',
    'm',
    'n',
    'o',
    'p',
    'q',
    'r',
    's',
    't',
    'u',
    'v',
    'w',
    'y'
  ];

  Future<void> test() async {
    try {
      dev.log(await platform.invokeMethod('model'));
    } on PlatformException catch (e) {
      dev.log(e.toString());
    }
  }

  Future click() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);

    int x = await platform.invokeMethod('model', image?.path);

    s = classes[x];

    setState(() {});
  }

  GestureDetector card(final letra) {
    return GestureDetector(
      child: Container(
        width: 80,
        height: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              offset: Offset(2.0, 2.0),
              spreadRadius: 0.0,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
                width: 30,
                height: 48,
                child: Image.asset("assets/images/${letra}1.png")),
            Text(letra),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: Random().nextDouble(),
                minHeight: 10,
                backgroundColor: const Color.fromRGBO(207, 207, 207, 1),
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
      onTap: () async => showDialog(
          context: context, builder: (_) => ImageDialog(letra: letra)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 48, 135, 1),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.translate),
              ),
              Tab(
                icon: Icon(Icons.sign_language),
              ),
              Tab(
                icon: Icon(Icons.info),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        card("A"),
                        card("B"),
                        card("C"),
                        card("D"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        card("E"),
                        card("F"),
                        card("G"),
                        card("I"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        card("L"),
                        card("M"),
                        card("N"),
                        card("O"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        card("P"),
                        card("Q"),
                        card("R"),
                        card("S"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        card("T"),
                        card("U"),
                        card("V"),
                        card("W"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Text("teste"),
            const Text("info"),
          ],
        ),
      ),
    );
  }
}

class ImageDialog extends StatelessWidget {
  String letra = "";
  ImageDialog({super.key, required this.letra});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 320,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage("assets/images/${letra}1.png"),
                fit: BoxFit.scaleDown)),
      ),
    );
  }
}
