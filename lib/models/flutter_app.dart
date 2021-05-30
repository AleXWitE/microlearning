import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:microlearning/db/moor_db.dart';
import 'package:microlearning/screens/about_screen.dart';
import 'package:microlearning/screens/add_screen.dart';
import 'package:microlearning/screens/auth_screen.dart';
import 'package:microlearning/screens/event_screen.dart';
import 'package:microlearning/screens/favorites_screen.dart';
import 'package:microlearning/screens/home_screen.dart';
import 'package:microlearning/screens/list_screen.dart';
import 'package:microlearning/users_roles/admin_role.dart';
import 'package:microlearning/users_roles/moderator_role.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FlutterTutorialApp extends StatefulWidget {
  @override
  _FlutterTutorialAppState createState() => _FlutterTutorialAppState();
}

class _FlutterTutorialAppState extends State<FlutterTutorialApp> {
  bool _initialized = false;
  bool _error = false;

  String _userEmail;


  // Определяем ассинхронную функцию для инициализации FlutterFire
  void initializeFlutterFire() async {
    try {
      // Дожидаемся пока пройдет инициализация и меняем состояние `_initialized` на true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Сменяем `_error` состояние на true если Firebase инициализация провалилась
      setState(() {
        _error = true;
      });
    }
  }

  // Сделать проверку ШП на экране авторизации и если есть ключи, то подставлять их в функцию входа,
  // чтобы в бд отмечалось время последнего входа

  _getUser() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    _userEmail = _prefs.getString('userEmailPref') ?? null;
    print('user shared prefs = $_userEmail');
  }

  @override
  void initState() {
    // стартуем подключение к Firebase
    initializeFlutterFire();
    super.initState();
    _getUser();
  }

  final Locale rusLocale = Locale('ru', '');
  final Locale engLocale = Locale('en', '');

  @override
  Widget build(BuildContext context) {
    //здесь определяется логика роутов и переходов по экранам, ну и с какого экрана начинать

    // if(_error){
    //   return MaterialApp(home: Center(child: Text("Something wrong with Firebase!")));
    // }

    if (!_initialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
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
        onGenerateTitle: (BuildContext context) => AppLocalizations.of(context).title,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // supportedLocales: AppLocalizations.supportedLocales,
        supportedLocales: [
          // const Locale('en', 'US'), //english support
          // const Locale('ru', 'RU'), //russian support
          engLocale,
          rusLocale,
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {

            for (var locale in supportedLocales) {
              print(locale.languageCode + deviceLocale.languageCode);
              if (locale.languageCode == deviceLocale.languageCode ) {
                print(deviceLocale.languageCode + ' is supported');
                return deviceLocale;
              }
            }
            print('>>>>> ' +
                deviceLocale.languageCode +
                ' <<<<<< is not supported');
            return supportedLocales.first;

        },
        // initialRoute: _error ? '/' : _userEmail == null ? '/auth' : '/list_events'  ,
        initialRoute: '/admin_form',
        home: _error
            ? Center(
                child:
                    Text(AppLocalizations.of(context).errorFirebase))
            : null,
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
          '/admin_form': (BuildContext context) => AdminRole(),
          '/moderator_form': (BuildContext context) => ModeratorRole(),
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
