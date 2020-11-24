import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  static const String title = 'Guess my number';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = 'Try a number!';
  bool _enabled = true;
  String _buttonName = 'Guess';
  static const int _max = 100;
  int _myNumber = Random().nextInt(_max);
  final TextEditingController _controller = TextEditingController();

  void checkAnswer(int userNumber) {
    setState(() {
      if (userNumber == null) {
        _message = 'Enter a number';
      } else if (userNumber == _myNumber) {
        _message = 'It is $_myNumber, Congratulations!';
        _showDialog();
        _enabled = false;
      } else if (userNumber < _myNumber) {
        _message = 'Try greater number!';
      } else {
        _message = 'Try smaller number!';
      }
      _controller.clear();
    });
  }

  void resetTheGame() {
    setState(() {
      _myNumber = Random().nextInt(_max);
      _enabled = true;
      _controller.clear();
      _buttonName = 'Guess';
      _message = 'Try a number';
    });
  }

  Future<void> _showDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You guessed right!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('It was $_myNumber'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Try again'),
              onPressed: () {
                resetTheGame();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                setState(() {
                  _buttonName = 'Reset';
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_myNumber);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: <Widget>[
          const Text(
            'I`m thinking of a number between 1 - 100.',
            style: TextStyle(fontSize: 27.2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          const Text(
            'It`s your turn to guess my number.',
            style: TextStyle(fontSize: 24.2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          Container(
            width: 500,
            height: 200,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 15.0),
                    blurRadius: 15.0,
                  ),
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, -10),
                    blurRadius: 10.0,
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Text(
                    '$_message',
                    style: const TextStyle(fontSize: 30.2),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    enabled: _enabled,
                    controller: _controller,
                    decoration: const InputDecoration(),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  RaisedButton(
                    onPressed: () {
                      if (_buttonName == 'Guess') {
                        checkAnswer(int.tryParse(_controller.text));
                      } else {
                        resetTheGame();
                      }
                    },
                    child: Text(_buttonName),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
