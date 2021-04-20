// import 'dart:io';
//
// import 'package:microlearning/components/users.dart';
// import 'package:sqflite/sqflite.dart';
//
//
// class DBProvider {
//   DBProvider._();
//   static final DBProvider db = DBProvider._();
// }
//
// Database _database;
// Future<Database> get database async{
//   if(_database != null || await checkDB(user))
//     return _database;
//
//   _database = await initDB(user);
//   return _database;
// }
//
// checkDB(Users user) async {
//   var databasesPath = await getDatabasesPath();
//   String path = join(databasesPath, "TestDB.db");
//
//   return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
//     await db.execute("SELECT name FROM sqlite_master"
//         "WHERE type'table' AND name='$user'"
//     );
//   });
// }
//
// initDB(Users user) async{
//   Directory documentDirectory = await getApplicationDocumentsDirectory();
//   String path = join(documentDirectory.path, "TestDB.db");
//   return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
//     await db.execute("CRAETE TABLE $user ("
//     "id INTEGER PRIMARY KEY,"
//     "name TEXT,"
//     "location TEXT,"
//     "date TEXT)"
//     );
//   });
// }

import 'package:flutter/material.dart';
import 'package:microlearning/components/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesFav extends StatefulWidget {
  SharedPreferencesFav({Key key}) : super(key: key);

  @override
  SharedPreferencesFavState createState() => SharedPreferencesFavState();
}

class SharedPreferencesFavState extends State<SharedPreferencesFav> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<List<String>> _favorite;

  Future<void> addFaforite(String item) async {
    final SharedPreferences prefs = await _prefs;
    final List<String> favorites = (prefs.getStringList('favorites') ?? 0);
    final String _item = item;

    setState(() {
      _favorite = prefs.setStringList("favorites", favorites).then((bool success) {
        return favorites;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _favorite = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('favorites') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SharedPreferences Demo"),
      ),
      body: Center(
          child: FutureBuilder<List<String>>(
              future: _favorite,
              builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text(
                        'Button tapped ${snapshot.data} time${snapshot.data == 1 ? '' : 's'}.\n\n'
                            'This should persist across restarts.',
                      );
                    }
                }
              })),
      floatingActionButton: FloatingActionButton(
        // onPressed: addFaforite(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
