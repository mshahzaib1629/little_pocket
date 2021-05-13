import 'package:flutter/material.dart';

class StatefulButton extends StatefulWidget {
  final Function incrementCounter;
  StatefulButton(this.incrementCounter);

  @override
  _StatefulButtonState createState() => _StatefulButtonState();
}

class _StatefulButtonState extends State<StatefulButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatefulStatelessButton(widget.incrementCounter),
        ElevatedButton(
          onPressed: widget.incrementCounter,
          child: Text('stateful'),
        ),
        StatefulStatefullButton(widget.incrementCounter),
      ],
    );
  }
}

class StatefulStatelessButton extends StatelessWidget {
  final Function incrementCounter;
  StatefulStatelessButton(this.incrementCounter);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: incrementCounter,
      child: Text('stateful-stateless'),
    );
  }
}

class StatefulStatefullButton extends StatefulWidget {
  final Function incrementCounter;
  StatefulStatefullButton(this.incrementCounter);

  @override
  _StatefulStatefullButtonState createState() =>
      _StatefulStatefullButtonState();
}

class _StatefulStatefullButtonState extends State<StatefulStatefullButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.incrementCounter,
      child: Text('stateful-stateful'),
    );
  }
}
