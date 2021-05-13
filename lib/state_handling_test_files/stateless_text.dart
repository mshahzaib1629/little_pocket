import 'package:flutter/material.dart';

class StatelessText extends StatelessWidget {
  final int counter;
  StatelessText(this.counter);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'final stateless: $counter',
          style: Theme.of(context).textTheme.headline6,
        ),
        StatelessStatelessWidget(counter),
        StatelessStatefulWidget(counter),
      ],
    );
  }
}

// ignore: must_be_immutable
class StatelessStatelessWidget extends StatelessWidget {
  final int counter;
  StatelessStatelessWidget(this.counter);

  @override
  Widget build(BuildContext context) {
    return Text(
      'final stateless-stateless: $counter',
      style: Theme.of(context).textTheme.headline6,
    );
  }
}

class StatelessStatefulWidget extends StatefulWidget {
  final int counter;
  StatelessStatefulWidget(this.counter);

  @override
  _StatelessStatefulWidgetState createState() =>
      _StatelessStatefulWidgetState();
}

class _StatelessStatefulWidgetState extends State<StatelessStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(
      'final stateless-stateful: ${widget.counter}',
      style: Theme.of(context).textTheme.headline6,
    );
  }
}
