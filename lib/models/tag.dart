import 'package:little_pocket/helpers/enums.dart';

class Tag {
  String id;
  String name;
  TagType tagType;
  DateTime lastTimeUsed;
  bool isActive;

  Tag({
    this.id,
    this.name,
    this.lastTimeUsed,
    this.isActive,
  });

  @override
  String toString() {
    // TODO: implement toString
    return '{id: $id, name: $name, tagType: ${tagType.toString()}, lastTimeUsed: ${lastTimeUsed.toString()}, isActive: $isActive}';
  }
}
