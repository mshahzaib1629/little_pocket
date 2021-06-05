import 'package:flutter/material.dart';
import 'package:little_pocket/helpers/json_handler.dart';
import 'package:little_pocket/helpers/manual_exception.dart';
import 'package:little_pocket/helpers/styling.dart';
import 'package:little_pocket/providers/transaction_provider.dart';
import 'package:little_pocket/widgets/default_error_dialog.dart';
import 'package:little_pocket/widgets/default_snack_bar.dart';
import 'package:provider/provider.dart';

class ImportExportScreen extends StatelessWidget {
  const ImportExportScreen({Key key}) : super(key: key);

  Future<void> _onImportPressed(BuildContext context) async {
    try {
      bool shouldImport = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Sure to Import?'),
                content: Text(
                  'On importing external data, current data will be lost.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Yes, I\'m sure'),
                  ),
                ],
              ));
      if (!shouldImport) return;
      String filePath = await JsonHelper.import();
      if (filePath != null) {
        showDefaultSnackBar(context,
            text: 'Data imported from \n$filePath', color: Colors.black);
      }
      final transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);
      await transactionProvider.fetchTransactions();
    } on ManualException catch (error) {
      if (error.toString() == 'invalid_file_format') {
        showDefaultSnackBar(context,
            text: 'This is not a valid file', color: Colors.red);
      } else if (error.toString() == 'permission_denied') {
        showDefaultSnackBar(context,
            text: 'Storage permission is denied', color: Colors.red);
      } else
        showDefaultErrorMsg(context);
    } catch (error) {
      print('error from _onImportPressed: \n${error.toString()}');
      showDefaultErrorMsg(context);
    }
  }

  Future<void> _onExportPressed(BuildContext context) async {
    try {
      String filePath = await JsonHelper.export();
      if (filePath != null) {
        showDefaultSnackBar(context,
            text: 'Saved as \n$filePath', color: Colors.black);
      }
    } on ManualException catch (error) {
      if (error.toString() == 'permission_denied') {
        showDefaultSnackBar(context,
            text: 'Storage permission is denied', color: Colors.red);
      } else
        showDefaultErrorMsg(context);
    } catch (error) {
      print('error from _onExportPressed: \n$error');
      showDefaultErrorMsg(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Import / Export'),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              onTap: () => _onImportPressed(context),
              title: Text('Import',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  )),
              subtitle: Text(
                  'On importing external data, current data will be lost.'),
            ),
            Divider(),
            ListTile(
              onTap: () => _onExportPressed(context),
              title: Text('Export',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                  )),
              subtitle:
                  Text('Exported file will be in directory:\n /Little Pocket/'),
            ),
          ],
        ),
      ),
    );
  }
}
