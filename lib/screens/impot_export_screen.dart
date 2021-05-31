import 'package:flutter/material.dart';
import 'package:little_pocket/helpers/json_handler.dart';
import 'package:little_pocket/helpers/manual_exception.dart';
import 'package:little_pocket/widgets/default_error_dialog.dart';
import 'package:little_pocket/widgets/default_snack_bar.dart';

class ImportExportScreen extends StatelessWidget {
  const ImportExportScreen({Key key}) : super(key: key);

  Future<void> _onImportPressed(BuildContext context) async {
    try {
      String filePath = await JsonHelper.import();
      if (filePath != null) {
        showDefaultSnackBar(context,
            text: 'Data imported from \n$filePath', color: Colors.black);
      }
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
              onPressed: () => _onImportPressed(context),
              child: Text('Import'),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
              onPressed: () => _onExportPressed(context),
              child: Text('Export'),
            )
          ],
        ),
      ),
    );
  }
}
