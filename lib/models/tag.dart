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
}
