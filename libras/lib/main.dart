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
      fontFamily: 'EspressoDolce',
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
  List<ExactAssetImage> images = [];
  List classes = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'I',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'Y'
  ];

  Future click() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);

    final stopwatch = Stopwatch()..start();

    int x = await platform.invokeMethod('model', image?.path);

    dev.log('model executed in ${stopwatch.elapsed}');

    s = classes[x];

    setState(() {});
  }

  GestureDetector teste(int index) {
    return GestureDetector(
      onTap: () async => showDialog(
          context: context, builder: (_) => ImageDialog(image: images[index])),
      child: Container(
        padding: const EdgeInsets.all(8),
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
          children: [
            Flexible(
              child: FractionallySizedBox(
                heightFactor: 0.9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: images[index], fit: BoxFit.scaleDown),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(classes[index], style: const TextStyle(fontSize: 15)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: Random().nextDouble(),
                  backgroundColor: const Color.fromRGBO(207, 207, 207, 1),
                  color: Colors.orange,
                  minHeight: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container lessonType1() {
    return Container(
        child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Selecione a figura certa para a letra 'A': ",
            style: TextStyle(fontSize: 25),
          ),
        ),
        GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: 4,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: images[index], fit: BoxFit.scaleDown),
                  ),
                ),
              );
            }),
      ],
    ));
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    for (var classe in classes) {
      images.add(ExactAssetImage("assets/images/${classe}1.png"));
    }
  }

  @override
  void didChangeDependencies() {
    for (var image in images) {
      precacheImage(image, context, size: const Size(200, 320));
    }
    super.didChangeDependencies();
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
            GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3 / 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                itemCount: 20,
                itemBuilder: (BuildContext context, int index) {
                  return teste(index);
                }),
            lessonType1(),
            const Text("info"),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ImageDialog extends StatelessWidget {
  ExactAssetImage image;
  ImageDialog({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 320,
        decoration: BoxDecoration(
            image: DecorationImage(image: image, fit: BoxFit.scaleDown)),
      ),
    );
  }
}
