import 'package:intl/intl.dart';
import 'package:little_pocket/helpers/enums.dart';

class Tag {
  int id;
  String name;
  TagType tagType;
  DateTime lastTimeUsed;
  bool isActive;

  Tag({
    this.id,
    this.name,
    this.tagType,
    this.lastTimeUsed,
    this.isActive,
  });

  @override
  String toString() {
    return '{id: $id, name: $name, tagType: ${tagType.toString()}, lastTimeUsed: ${lastTimeUsed.toString()}, isActive: $isActive}';
  }

  Map<String, dynamic> toMap() {
    var mapObj = {
      'name': name,
      'tagType': tagType.toString(),
      'lastTimeUsed': lastTimeUsed.toIso8601String(),
      'isActive': isActive ? 1 : 0,
    };
    return mapObj;
  }

  static Tag fromMap(Map<String, dynamic> tagObj) {
    Tag tag = Tag(
      id: tagObj['id'],
      name: tagObj['name'],
      tagType: getEnumValue(
        type: EnumType.TagType,
        enumString: tagObj['tagType'],
      ),
      lastTimeUsed: DateFormat('yyyy-MM-ddThh:mm:ss', 'en_US')
          .parse(tagObj['lastTimeUsed']),
      isActive: tagObj['isActive'] == 1 ? true : false,
    );
    return tag;
  }
}
