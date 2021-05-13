import 'package:flutter/material.dart';
import 'package:little_pocket/helpers/styling.dart';
import 'package:little_pocket/providers/tag_provider.dart';
import 'package:little_pocket/providers/transaction_provider.dart';
import 'package:little_pocket/screens/history_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => TransactionProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => TagProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Little Pocket',
          theme: AppTheme.themeData,
          home: HistoryScreen(),
        ));
  }
}
