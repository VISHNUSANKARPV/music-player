import 'package:hive_flutter/adapters.dart';
part 'datamodel.g.dart';

@HiveType(typeId: 1)
class MusicModel {
  @HiveField(0)
  String? name;

  @HiveField(1)
  List<dynamic> songlistdb;

  MusicModel({this.name, this.songlistdb = const []});
}
