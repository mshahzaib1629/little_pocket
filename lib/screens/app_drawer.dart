import 'package:flutter/material.dart';
import 'package:little_pocket/screens/history_screen.dart';
import 'package:little_pocket/screens/tags_screen.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Little Pocket'),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).accentColor,
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title:
                Text('My Record', style: Theme.of(context).textTheme.subhead),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.bookmark),
            title: Text('My Tags', style: Theme.of(context).textTheme.subhead),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TagScreen()));
            },
          ),
        ],
      ),
    );
  }
}
