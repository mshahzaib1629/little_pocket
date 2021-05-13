import 'package:flutter/material.dart';
import 'stateful_button.dart';
import 'stateful_text.dart';
import 'stateless_button.dart';
import 'stateless_text.dart';

// ============================================
// HOW TO TEST?
// Simply call this file below MaterialApp
// ============================================

class StateHandlingTest extends StatefulWidget {
  StateHandlingTest({Key key}) : super(key: key);

  @override
  _StateHandlingTestState createState() => _StateHandlingTestState();
}

class _StateHandlingTestState extends State<StateHandlingTest> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('State Handling Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'final Local State: $_counter',
              style: Theme.of(context).textTheme.headline6,
            ),
            StatelessText(_counter),
            StatefulText(_counter),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('Local Button'),
            ),
            StatelessButton(_incrementCounter),
            StatefulButton(_incrementCounter),
          ],
        ),
      ),
    );
  }
}
