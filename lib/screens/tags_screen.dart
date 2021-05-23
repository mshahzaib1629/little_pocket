import 'package:flutter/material.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/helpers/styling.dart';
import 'package:little_pocket/models/tag.dart';
import 'package:little_pocket/providers/tag_provider.dart';
import 'package:little_pocket/widgets/add_tag_button.dart';
import 'package:little_pocket/widgets/default_error_dialog.dart';
import 'package:little_pocket/widgets/tag_card.dart';
import 'package:provider/provider.dart';

class TagScreen extends StatefulWidget {
  TagScreen({Key key}) : super(key: key);

  @override
  _TagScreenState createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchTags();
  }

  Future<void> _fetchTags() async {
    try {
      final tagProvider = Provider.of<TagProvider>(context, listen: false);
      setState(() {
        _isLoading = true;
      });
      await tagProvider.fetchTags(TagType.Income);
      await tagProvider.fetchTags(TagType.Expense);
    } catch (error) {
      print('error from _fetchTags: \n$error');
      showDefaultErrorMsg(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> removeFromTagList(int index) async {
    try {} catch (error) {
      print('error from removeFromTagList: \n$error');
      showDefaultErrorMsg(context);
    }
  }

  Future<void> addToTagList(Tag tag) async {
    try {
      final tagProvider = Provider.of<TagProvider>(context, listen: false);
      tagProvider.addNewTag(tag);
    } catch (error) {
      print('error from addToTagList: \n$error');
      showDefaultErrorMsg(context);
    }
  }

  List<Widget> _getTags(
      List<Tag> tags, TagType tagType, Color highlightedColor) {
    List<Widget> tagsToDisplay = [];
    for (int i = 0; i < tags.length; i++) {
      tagsToDisplay.add(
        TagCard(
          index: i,
          tag: tags[i],
          editable: true,
          isHighlighted: true,
          removeFromTagList: removeFromTagList,
          highlightedColor: highlightedColor,
        ),
      );
    }
    tagsToDisplay
        .add(AddTagButton(tagType: tagType, addToTagList: addToTagList));
    return tagsToDisplay;
  }

  Widget _tagSet(tags, tagType, highlightedColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 5,
      ),
      child: _isLoading
          ? Text('Loading...')
          : Wrap(
              direction: Axis.horizontal,
              spacing: 5,
              runSpacing: 5,
              alignment: WrapAlignment.start,
              children: _getTags(
                tags,
                tagType,
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
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                expandedAlignment: Alignment.topLeft,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Consumer<TagProvider>(
                      builder: (context, tagConsumer, _) => _tagSet(
                        tagConsumer.incomeTags,
                        TagType.Income,
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
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                expandedAlignment: Alignment.topLeft,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Consumer<TagProvider>(
                      builder: (context, tagConsumer, _) => _tagSet(
                        tagConsumer.expenseTags,
                        TagType.Expense,
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
