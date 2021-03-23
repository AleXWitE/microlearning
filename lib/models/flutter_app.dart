import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/screens/about_screen.dart';
import 'package:microlearning/screens/add_screen.dart';
import 'package:microlearning/screens/event_screen.dart';
import 'package:microlearning/screens/home_screen.dart';
import 'package:microlearning/screens/list_screen.dart';

class FlutterTutorialApp extends StatefulWidget {

  @override
  _FlutterTutorialAppState createState() => _FlutterTutorialAppState();
}

class _FlutterTutorialAppState extends State<FlutterTutorialApp> {
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Example",
        initialRoute: '/home',
        routes: {
          '/home': (BuildContext context) => HomeScreen(),
          '/list_events': (BuildContext context) => ListScreen(),
          '/event': (BuildContext context) => EventScreen(),
          '/about': (BuildContext context) => AboutScreen(),
          '/add': (BuildContext context) => AddScreen(),

        },
      onGenerateRoute: (routeSettings){
        var path = routeSettings.name.split('/');

        if (path[1] == "event") {
          return new MaterialPageRoute(
            builder: (context) => new EventScreen(id:path[2]),
            settings: routeSettings,
          );
        }
      },);
        // home: HomeScreen());
        // home: ListScreen());
  }
}

