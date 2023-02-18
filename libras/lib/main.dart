import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:developer' as dev;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const platform = MethodChannel('teste');
  List r = [];

  Future<void> test() async {
    try {
      dev.log(await platform.invokeMethod('model'));
    } on PlatformException catch (e) {
      dev.log(e.toString());
    }
  }

  Future click() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    var x = await platform.invokeMethod('model', image?.path);

    dev.log(x.toString());
  }

  Container card(final letra) {
    return Container(
      width: 80,
      height: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(20)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LIBRAS'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: click, child: const Text("APRENDA O ALFABETO")),
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
                card("H"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                card("I"),
                card("J"),
                card("K"),
                card("L"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                card("M"),
                card("N"),
                card("O"),
                card("P"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                card("Q"),
                card("R"),
                card("S"),
                card("T"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                card("U"),
                card("V"),
                card("W"),
                card("X"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
