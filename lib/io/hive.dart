import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:xbox_minecraft_tools/data/main_list.dart';

class HiveDB {
  static init() async {
    Hive.registerAdapter(MainListDataAdapter());
    await Hive.initFlutter();
  }

  static Future<List<MainListData>> getMainServerList() async {
    final box = await Hive.openBox("main");
    List<MainListData> l =
        (box.get("server_list", defaultValue: []))!.cast<MainListData>();
    return l;
  }

  static Future<List<MainListData>> saveMainServerList(
      List<MainListData> list) async {
    final box = await Hive.openBox("main");
    await box.put("server_list", list);
    return getMainServerList();
  }
}
