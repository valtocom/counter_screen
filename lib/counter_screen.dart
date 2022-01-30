import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterScreen extends StatefulWidget {
  CounterScreen({Key? key}) : super(key: key);

  final CounterStorage storage = CounterStorage();

  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _push = 0;
  int _check = 0;


  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _push = (prefs.getInt('counter') ?? 0);
    });
    widget.storage.readCounter().then((int value) {
      setState(() {
        _check = value;
      });
    });
  }

  void _incrementCounterPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _push = (prefs.getInt('push') ?? 0) + 1;
      prefs.setInt('push', _push);
    });
  }

  Future<File> _incrementCounterFile() {
    setState(() {
      _check++;
    });

    return widget.storage.writeCounter(_check);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Сохранение и загрузка данных"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                'shared_preferences',
                style: TextStyle(fontSize: 30),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: _incrementCounterPrefs,
                child: const Text('Добавить'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Text(
                  'Значение счетчика: $_push',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            Container(
              alignment: Alignment.center,
              child: const Text(
                "хранение в файле",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: _incrementCounterFile,
                child: const Text('Добавить'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card(
                child: Text(
                  'Значение счетчика: $_check',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    return file.writeAsString('$counter');
  }
}