import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/db/moor_db.dart';
import 'package:microlearning/screens/about_screen.dart';
import 'package:microlearning/screens/add_screen.dart';
import 'package:microlearning/screens/auth_screen.dart';
import 'package:microlearning/screens/event_screen.dart';
import 'package:microlearning/screens/favorites_screen.dart';
import 'package:microlearning/screens/home_screen.dart';
import 'package:microlearning/screens/list_screen.dart';
import 'package:provider/provider.dart';

class FlutterTutorialApp extends StatefulWidget {
  @override
  _FlutterTutorialAppState createState() => _FlutterTutorialAppState();
}

class _FlutterTutorialAppState extends State<FlutterTutorialApp> {

  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //здесь определяется логика роутов и переходов по экранам, ну и с какого экрана начинать

    if(_error){
      return Text("Something wrong with Firebase!");
    }

    if(!_initialized){
      return Center(child: CircularProgressIndicator(),);
    }

    return MultiProvider(
      providers: [
        Provider<FavorDao>(
          create: (_) => AppDatabase().favorDao,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        //отключает бесячий "дебаг" в верхнем углу экрана
        title: "Microlearning-LMS",
        initialRoute: '/auth',
        theme: ThemeData(
            fontFamily: 'Gilroy',
            primaryColor: Colors.black,
            accentColor: Colors.white,
        ),
        routes: {
          //пути определения классов, переходя по этим ссылкам, будут вызывать эти классы
          '/home': (BuildContext context) => HomeScreen(),
          '/list_events': (BuildContext context) => ListScreen(),
          '/event': (BuildContext context) => EventScreen(),
          '/about': (BuildContext context) => AboutScreen(),
          '/add': (BuildContext context) => AddScreen(),
          '/favorite': (BuildContext context) => FavoritesScreen(),
          '/auth': (BuildContext context) => AuthScreen(),
        },
        onGenerateRoute: (routeSettings) {
          //генерация путей второго порядка
          var path = routeSettings.name.split('/'); //разделитель путей в адресе

          if (path[1] == "event") {
            //если первая часть пути такая
            return MaterialPageRoute(
              // то вернуть виджет отрисованного роута
              builder: (context) => EventScreen(id: path[2]),
              //и отрисовать внутри класс по полученному id
              settings: routeSettings,
            );
          }
        },
      ),
    );
    // home: HomeScreen());  //это в том случае использовать, если 1 экран и не предусмотрена сложна иерархия путей
    // home: ListScreen());
  }
}
