import 'package:hive/hive.dart';

part 'main_list.g.dart';

@HiveType(typeId : 1)
class MainListData {
  @HiveField(0)
  String title;
  @HiveField(1)
  String host;
  @HiveField(2)
  String port;
  MainListData(this.title, this.host, this.port);
}
