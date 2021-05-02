import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/db/moor_db.dart';

import 'models/flutter_app.dart';
//если происходит смена войда мэйн, то нужно перезапускать все приложение, а так, самая главная функция, стартовая точка входа в приложение
AppDatabase database;

void main() {
  database = AppDatabase();
  runApp(FlutterTutorialApp());
}