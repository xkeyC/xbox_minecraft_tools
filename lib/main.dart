import 'package:flutter/material.dart';
import 'package:xbox_minecraft_tools/io/hive.dart';

import 'package:xbox_minecraft_tools/ui/main_UI.dart';

void main() async {
  await HiveDB.init();
  runApp(const MainUI());
}
