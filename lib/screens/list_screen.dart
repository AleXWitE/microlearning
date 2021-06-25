import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:microlearning/components/bread_dots.dart';
import 'package:microlearning/components/list_card.dart';
import 'package:microlearning/components/users.dart';
import 'package:microlearning/models/drawer_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> with WidgetsBindingObserver {
  GlobalKey<RefreshIndicatorState> refreshKey;
  Stream
      getAllEventsState; //определяем переменную под будущий список элементов из интернета
  int count;
  int asyncCount;

  List<Courses> _coursesList = [];
  List<Divisions> _divCoursesList = [];
  Divisions selectedDivision;

  final databaseRefDivs = FirebaseFirestore.instance.collection('divisions');

  String _choosenDiv = "Example";

  Future<List<Courses>> getAllCourses(String _div) async {
    if (_coursesList.isNotEmpty) _coursesList.clear();

    int i = 1;

    if (userDivision != 'all')
      _choosenDiv = userDivision;
    else
      _choosenDiv = _div;

    if (userDivision != 'all') {
      await FirebaseFirestore.instance
          .collection('divisions')
          .doc(_choosenDiv)
          .collection('courses')
          .get()
          .then((value) => value.docs.forEach((element) {
                setState(() {
                  _coursesList.add(Courses(
                      id: i++,
                      course: element.data()['title'],
                      division: element.id));
                });
              }));
    } else {
      await FirebaseFirestore.instance
          .collection('divisions')
          .get()
          .then((value) => value.docs.forEach((element) {
                setState(() {
                  _divCoursesList.clear();
                  _divCoursesList.add(Divisions(
                      division: element.id,
                      title: element.data()['title_division']));
                  selectedDivision = _divCoursesList.first;
                });
              }));
    }
    return _coursesList;
  }

  @override
  void initState() {
    super.initState();
    getAllEventsState = getAllCourses(userDivision).asStream();
    databaseRefDivs.get().then((value) => value.docs.forEach((element) {
          _divCoursesList.add(Divisions(
              title: element.data()['title_division'], division: element.id));
          print(element.id + element.data()['title_division']);
        }));
    // selectedDivision = _divCoursesList.first;
    refreshKey = GlobalKey<
        RefreshIndicatorState>(); //задача уникального ключа для виджета обновления спсика
  }

  Future<Null> refreshList() async {
    //функция обновления списка
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      _coursesList.clear();
    });
    setState(() {
      getAllEventsState = getAllCourses(userDivision).asStream();
      _hasData = true;
      ifNoData(_hasData);
    });
    return null;
  }

  Widget _ifNoData = Center(child: CircularProgressIndicator());
  bool _hasData;

  Widget _chooseCourse() {
    return DropdownButton<Divisions>(
        hint: Text(
          AppLocalizations.of(context).dropdownDivisions,
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        value: selectedDivision,
        style: TextStyle(color: Theme.of(context).accentColor),
        dropdownColor: Theme.of(context).primaryColor,
        onChanged: (value) async {
          setState(() {
            selectedDivision = value;
            userDivision = value.division;
          });
          await getAllCourses(selectedDivision.division);
          await refreshList();
        },
        items: _divCoursesList.map((item) {
          return DropdownMenuItem<Divisions>(
              value: item,
              child: Text(
                item.title,
              ));
        }).toList());
  }

  Future<Null> ifNoData(bool snapdata) async {
    if (snapdata == false) {
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        _ifNoData = Center(
          child: Text(userRole == 'admin'
              ? AppLocalizations.of(context).youAreAdmin
              : AppLocalizations.of(context).warningConnection),
        );
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //не работает(((
    if (state == AppLifecycleState.resumed) {
      setState(() {
        getAllEventsState = getAllCourses(userDivision).asStream();
      });
    }
  }

  Widget RefreshInd() {
    return RefreshIndicator(
        //обновление списка
        key: refreshKey,
        backgroundColor: Theme.of(context).primaryColor,
        onRefresh: () async {
          await refreshList();
        },
        child: Column(children: [
          Expanded(
              flex: 1,
              child: BreadDots(
                  title: AppLocalizations.of(context).breadDotsCourses)),
          Expanded(
            flex: 9,
            child: StreamBuilder<List<Courses>>(
              stream: getAllEventsState,
              builder: (context, snapshot) {
                // AppLifecycleState state;
                print(snapshot.hasData);
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  _hasData = true;
                  count = snapshot.data.length;
                  if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  return ListView.builder(
                      //возвращаем билд списка
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      itemCount: count,
                      itemBuilder:
                          (_, index) => //самое интересное, т.к. у нас тут неопределенное количество повторений может быть, мы вызываем метод подстановки и отрисовки всех элементов списка
                              EventCard(
                                courses: snapshot.data,
                                i: index,
                                favs: [],
                              ));
                } else {
                  _hasData = false;
                  ifNoData(_hasData);
                  return _ifNoData;
                }
              },
            ),
          ),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    if (getAllEventsState == null) {
      //если мы первый раз запустили экран - получаем в первый раз данные из интернета
      getAllEventsState = getAllCourses(userDivision).asStream();
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0,
        title: Text(
            "${AppLocalizations.of(context).hello} $userName\n"
            "${AppLocalizations.of(context).titleDivision} $userDivision\n"
            "${AppLocalizations.of(context).titleAvailable} $count",
            style: TextStyle(
              fontSize: 22.0,
            )),
        centerTitle: true,
        actions: [
          userRole == 'admin' ? _chooseCourse() : Container(),
        ],
        // backgroundColor: Theme.of(context).accentColor,
      ),
      drawer: MediaQuery.of(context).size.width > 600
          ? null
          : Drawer(
              child: DrawerItem(),
            ), //боковая менюшка
      body: SafeArea(
        child: MediaQuery.of(context).size.width <
                600 //обратить внимание на эту строку когдавсе починю
            ? RefreshInd()
            : Row(
                children: [
                  Container(
                    width: 200,
                    child: DrawerItem(),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 200,
                    child: RefreshInd(),
                  )
                ],
              ),
      ),
      floatingActionButton: _hasData == false
          ? FloatingActionButton(
              onPressed: () async {
                setState(() {
                  _ifNoData = Center(
                    child: CircularProgressIndicator(),
                  );
                });
                await refreshList();
              },
              child: Icon(Icons.refresh),
            )
          : Container(),
    );
  }
}

//   TODO: проверить английскую орфографию (попросить ЗВёздочку помочь),
//   TODO: убрать все тени и сделать более политеховские цвета (бред какой-то...) убрать скругления,
