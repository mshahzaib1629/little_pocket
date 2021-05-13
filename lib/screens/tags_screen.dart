import 'package:flutter/material.dart';
import 'package:little_pocket/helpers/styling.dart';
import 'package:little_pocket/models/tag.dart';
import 'package:little_pocket/providers/tag_provider.dart';
import 'package:little_pocket/widgets/add_tag_button.dart';
import 'package:little_pocket/widgets/tag_card.dart';
import 'package:provider/provider.dart';

class TagScreen extends StatefulWidget {
  TagScreen({Key key}) : super(key: key);

  @override
  _TagScreenState createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  Future<void> removeFromTagList(int index) async {}
  Future<void> addToTagList(Tag tag) async {}
  List<Widget> _getTags(List<Tag> tags, Color highlightedColor) {
    List<Widget> tagsToDisplay = [];
    for (int i = 0; i < tags.length; i++) {
      tagsToDisplay.add(TagCard(
        index: i,
        tag: tags[i],
        editable: true,
        isHighlighted: true,
        removeFromTagList: removeFromTagList,
        highlightedColor: highlightedColor,
      ));
    }
    tagsToDisplay.add(AddTagButton(addToTagList: addToTagList));
    return tagsToDisplay;
  }

  Widget _tagSet(tags, highlightedColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 5,
      ),
      child: Wrap(
          direction: Axis.horizontal,
          spacing: 5,
          runSpacing: 5,
          alignment: WrapAlignment.start,
          children: _getTags(
            tags,
            highlightedColor,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tags'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                accentColor: AppTheme.incomeColor,
              ),
              child: ExpansionTile(
                title: Text('Income Tags'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Consumer<TagProvider>(
                      builder: (context, tagConsumer, _) => _tagSet(
                        tagConsumer.incomeTags,
                        Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black26,
              height: 2,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
                accentColor: AppTheme.expenseColor,
              ),
              child: ExpansionTile(
                title: Text('Expense Tags'),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Consumer<TagProvider>(
                      builder: (context, tagConsumer, _) => _tagSet(
                        tagConsumer.expenseTags,
                        Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
