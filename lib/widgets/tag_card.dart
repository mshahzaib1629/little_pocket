import 'package:flutter/material.dart';
import 'package:little_pocket/models/tag.dart';
import '../helpers/styling.dart';
import '../models/tag.dart';

class TagCard extends StatelessWidget {
  final int index;
  final Tag tag;
  final bool editable;
  final Function(int index) removeFromTagList;
  final bool isHighlighted;
  final Color highlightedColor;
  TagCard({
    this.index,
    this.tag,
    this.editable = false,
    this.removeFromTagList,
    this.isHighlighted = false,
    this.highlightedColor = Colors.blue,
  });

  void _delete(context) {
    removeFromTagList(index);
    Navigator.pop(context);
  }

  void _onDeletePressed(context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text('Are you sure to delete \"${tag.name}\"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _delete(context),
                  child: Text('Delete',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      )),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: isHighlighted ? highlightedColor : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: editable
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.center,
        children: [
          Container(
            padding: editable
                ? EdgeInsets.only(top: 3, bottom: 3, right: 8)
                : EdgeInsets.symmetric(vertical: 3, horizontal: 2),
            child: Text(
              tag.name,
              textAlign: TextAlign.left,
              style: AppTheme.tagTextStyle
                  .copyWith(color: isHighlighted ? Colors.white : Colors.black),
            ),
          ),
          if (editable)
            InkWell(
              onTap: () => _onDeletePressed(context),
              child: Icon(
                Icons.close,
                color: isHighlighted ? Colors.white : Colors.black,
                size: 15,
              ),
            ),
        ],
      ),
    );
  }
}
