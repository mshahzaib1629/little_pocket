import 'package:flutter/material.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/helpers/styling.dart';
import 'package:little_pocket/models/tag.dart';

class AddTagButton extends StatelessWidget {
  final _key = GlobalKey<FormState>();
  final _tagController = TextEditingController();
  final Function(Tag tag) addToTagList;
  final TagType tagType;

  AddTagButton({this.tagType, this.addToTagList});

  Future<void> _addTag(context) {
    print(_tagController.text);
    Tag tag = Tag(
        name: _tagController.text,
        tagType: tagType,
        lastTimeUsed: DateTime.now(),
        isActive: true);
    addToTagList(tag);
    _tagController.text = '';
    Navigator.pop(context);
  }

  void _saveForm(context) {
    if (_key.currentState.validate()) {
      _addTag(context);
    }
  }

  void _onTap(context) {
    String _tipString =
        'Add all the relavent keywords of any targeted Tag for better search results!';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Container(
          height: 140,
          child: Column(
            children: [
              Form(
                key: _key,
                child: TextFormField(
                  controller: _tagController,
                  cursorColor: Theme.of(context).accentColor,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value.isEmpty) return 'Tag name should not be empty!';
                    return null;
                  },
                  decoration:
                      AppTheme.inputDecoration(Theme.of(context).accentColor)
                          .copyWith(
                    labelText: 'Tag Name',
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).accentColor,
                    ),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: 'Tip: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: _tipString,
                  ),
                ]),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _tagController.text = '';
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ),
          TextButton(
            onPressed: () => _saveForm(context),
            child: Text(
              'Add',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTap(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(top: 3, bottom: 3, right: 8),
              child: Text(
                'Add New',
                textAlign: TextAlign.left,
                style: AppTheme.addTagBtnTextStyle,
              ),
            ),
            Icon(
              Icons.add,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}
