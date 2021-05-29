import 'package:flutter/cupertino.dart';
import 'package:little_pocket/helpers/enums.dart';
import 'package:little_pocket/helpers/local_db_helper.dart';
import 'package:little_pocket/models/tag.dart';

class TagProvider with ChangeNotifier {
  List<Tag> _incomeTags = [];
  List<Tag> _expenseTags = [];

  List<Tag> get incomeTags {
    return _incomeTags;
  }

  List<Tag> get expenseTags {
    return _expenseTags;
  }

  Future<void> fetchTags(TagType tagType) async {
    try {
      // @TODO: fetch Adjustment Tag along with Income / Expense Tags
      var tagsFetched = await LocalDatabase.getTagsOfType(tagType);
      List<Tag> tagsParsed = tagsFetched.map((e) => Tag.fromMap(e)).toList();
      Tag adjustmentTag = await getAdjustmentTagOnly();
      if (adjustmentTag != null) tagsParsed.add(adjustmentTag);
      if (tagType == TagType.Income)
        _incomeTags = tagsParsed;
      else if (tagType == TagType.Expense) _expenseTags = tagsParsed;

      notifyListeners();
    } catch (error) {
      print('error from fetchTags: \n$error');
      throw error;
    }
  }

  Future<Tag> addNewTag(Tag tag) async {
    try {
      int id = await LocalDatabase.insert('tags', tag.toMap());
      tag.id = id;
      if (tag.tagType == TagType.Income)
        _incomeTags.add(tag);
      else
        _expenseTags.add(tag);
      notifyListeners();
      return tag;
    } catch (error) {
      print('error from addNewTag: \n$error');
      throw error;
    }
  }

  Future<Tag> getAdjustmentTagOnly() async {
    try {
      var tagFetched = await LocalDatabase.getTagsOfType(TagType.Adjustment);
      if (tagFetched.isEmpty) return null;
      Tag adjustmentTag = Tag.fromMap(tagFetched[0]);
      return adjustmentTag;
    } catch (error) {
      print('error from getAdjustmentTagOnly: \n$error');
      throw error;
    }
  }

  Future<void> deleteTag(Tag tag) async {
    try {
      tag.isActive = false;
      await LocalDatabase.update('tags', tag.id, tag.toMap());
      if (tag.tagType == TagType.Income)
        _incomeTags.remove(tag);
      else
        _expenseTags.remove(tag);
      notifyListeners();
    } catch (error) {
      print('error from getAdjustmentTagOnly: \n$error');
      throw error;
    }
  }
}
