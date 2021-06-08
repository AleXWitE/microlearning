import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/api/services/event_service.dart';
import 'package:microlearning/components/event.dart';
import 'package:microlearning/components/list_card.dart';
import 'package:microlearning/components/users.dart';
import 'package:microlearning/models/drawer_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

  Future<List<Courses>> getAllCourses() async {
    if(_coursesList.isNotEmpty)
      _coursesList.clear();

    await FirebaseFirestore.instance
        .collection('divisions')
        .doc(userDivision)
        .collection('courses')
        .get()
        .then((value) => value.docs.forEach((element) {
                _coursesList.add(
                    Courses(id: value.hashCode.toString(), course: element.data()['title']));
            }));
    return _coursesList;
  }

  @override
  void initState() {
    super.initState();
    // print(userDivision);
    getAllEventsState = getAllCourses().asStream();
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
      // getAllEventsState = getAllEvents().asStream();
      getAllEventsState = getAllCourses().asStream();
      _hasData = true;
      ifNoData(_hasData);
    });
    return null;
  }

  Widget _ifNoData = Center(child: CircularProgressIndicator());
  bool _hasData;

  Future<Null> ifNoData(bool snapdata) async {
    if (snapdata == false) {
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        _ifNoData = Center(
          child: Text(kIsWeb
              ? AppLocalizations.of(context).warningConnectionBrowser
              : AppLocalizations.of(context).warningConnection),
        );
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //не работает(((
    if (state == AppLifecycleState.resumed) {
      setState(() {
        getAllEventsState = getAllCourses().asStream();
      });
    }
  }

  Widget RefreshInd() {
    return RefreshIndicator(

        //обновление списка
        key: refreshKey,
        onRefresh: () async {
          await refreshList();
        },
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
                            events: snapshot.data,
                            i: index,
                            favs: [],
                          ));
            } else {
              _hasData = false;
              ifNoData(_hasData);
              return _ifNoData;
            }
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (getAllEventsState == null) {
      //если мы первый раз запустили экран - получаем в первый раз данные из интернета
      getAllEventsState = getAllCourses().asStream();
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65.0,
        title: Text("${AppLocalizations.of(context).hello} $userName \n${AppLocalizations.of(context).titleDivision} $userDivision",
            style: TextStyle(
              fontSize: 22.0,
            )),
        centerTitle: true,
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
