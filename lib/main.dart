import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Counter',
        storage: CounterStorage(),
      ),
    );
  }
}

class CounterStorage {
  Future<String> get _localPath async {
    // Find the path to the documents directory 
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    //Achieve a reference to the file’s full location
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If we encounter an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, @required this.storage}) : super(key: key);

  final String title;
  final CounterStorage storage;
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.pink,
    Colors.yellow,
    Colors.orange,
    Colors.brown,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.cyan
  ];

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // Called exactly once when
  @override
  void initState() { 
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<File> _incrementCounter() async {
    // Notify that something should be change in screen
    setState(() {
      _counter++;
    });
    // Write the variable as a string to the file
    return widget.storage.writeCounter(_counter);
  }

  Future<File> _resetCounter() async {
    setState(() {
      _counter = 0;
    });
    return widget.storage.writeCounter(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // Arrange widgets on top of a base widget
      body: Stack(
        alignment: Alignment(0, 0.5),
        children: <Widget>[
          Center(
            child: Container(
              width: 160,
              height: 160,
              color: widget.colors[_counter % widget.colors.length],
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.display4,
                ),
              ),
            ),
          ),
          FlatButton(
            child: Text('RESET'),
            onPressed: _resetCounter,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
