import 'package:flutter/material.dart';

class StatefulText extends StatefulWidget {
  final int counter;
  StatefulText(this.counter);

  @override
  _StatefulTextState createState() => _StatefulTextState();
}

class _StatefulTextState extends State<StatefulText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'final stateful: ${widget.counter}',
          style: Theme.of(context).textTheme.headline6,
        ),
        StatefulStatelessWidget(widget.counter),
        StatefulStatefulWidget(widget.counter),
      ],
    );
  }
}

// ignore: must_be_immutable
class StatefulStatelessWidget extends StatelessWidget {
  final int counter;
  StatefulStatelessWidget(this.counter);

  @override
  Widget build(BuildContext context) {
    return Text(
      'final stateful-stateless: $counter',
      style: Theme.of(context).textTheme.headline6,
    );
  }
}

class StatefulStatefulWidget extends StatefulWidget {
  final int counter;
  StatefulStatefulWidget(this.counter);

  @override
  _StatefulStatefulWidgetState createState() => _StatefulStatefulWidgetState();
}

class _StatefulStatefulWidgetState extends State<StatefulStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(
      'final stateful-stateful: ${widget.counter}',
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
