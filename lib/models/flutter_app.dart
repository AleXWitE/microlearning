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
  Widget build(BuildContext context) { //здесь определяется логика роутов и переходов по экранам, ну и с какого экрана начинать

    return MaterialApp(
        debugShowCheckedModeBanner: false, //отключает бесячий "дебаг" в верхнем углу экрана
        title: "Example",
        initialRoute: '/home',
        routes: { //пути определения классов, переходя по этим ссылкам, будут вызывать эти классы
          '/home': (BuildContext context) => HomeScreen(),
          '/list_events': (BuildContext context) => ListScreen(),
          '/event': (BuildContext context) => EventScreen(),
          '/about': (BuildContext context) => AboutScreen(),
          '/add': (BuildContext context) => AddScreen(),

        },
      onGenerateRoute: (routeSettings){ //генерация путей второго порядка
        var path = routeSettings.name.split('/'); //разделитель путей в адресе

        if (path[1] == "event") { //если первая часть пути такая
          return MaterialPageRoute(// то вернуть виджет отрисованного роута
            builder: (context) => EventScreen(id:path[2]), //и отрисовать внутри класс по полученному id
            settings: routeSettings,
          );
        }
      },);
        // home: HomeScreen());  //это в том случае использовать, если 1 экран и не предусмотрена сложна иерархия путей
        // home: ListScreen());
  }
}

