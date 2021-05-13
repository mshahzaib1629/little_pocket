import 'package:flutter/material.dart';

class StatelessButton extends StatelessWidget {
  final Function incrementCounter;
  StatelessButton(this.incrementCounter);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StatelessStatelessButton(incrementCounter),
        ElevatedButton(
          onPressed: incrementCounter,
          child: Text('Stateless'),
        ),
        StatelessStatefullButton(incrementCounter),
      ],
    );
  }
}

class StatelessStatelessButton extends StatelessWidget {
  final Function incrementCounter;
  StatelessStatelessButton(this.incrementCounter);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: incrementCounter,
      child: Text('stateless-stateless'),
    );
  }
}

class StatelessStatefullButton extends StatefulWidget {
  final Function incrementCounter;
  StatelessStatefullButton(this.incrementCounter);

  @override
  _StatelessStatefullButtonState createState() =>
      _StatelessStatefullButtonState();
}

class _StatelessStatefullButtonState extends State<StatelessStatefullButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.incrementCounter,
      child: Text('stateless-stateful'),
    );
  }
}
