import 'dart:async';

import 'package:flutter/material.dart';
import 'package:microlearning/api/services/event_service.dart';
import 'package:microlearning/components/event.dart';
import 'package:microlearning/components/list_card.dart';
import 'package:microlearning/models/drawer_item.dart';

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

  @override
  void initState() {
    super.initState();
    refreshKey = GlobalKey<
        RefreshIndicatorState>(); //задача уникального ключа для виджета обновления спсика
  }

  Future<Null> refreshList() async {
    //функция обновления списка
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      getAllEventsState = getAllEvents().asStream();
      _hasData = true;
      ifNoData(_hasData);
    });
    return null;
  }

  Widget _ifNoData = Center(child: CircularProgressIndicator());
  bool _hasData;

  Future<Null> ifNoData(bool snapdata) async {
    if(snapdata == false){
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        _ifNoData = Center(
          child: Text("Something wrong! Try check connection!"),
        );
      });
    }
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //не работает(((
    if (state == AppLifecycleState.resumed) {
      setState(() {
        getAllEventsState = getAllEvents().asStream();
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
        child: StreamBuilder<List<Event>>(
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
                  physics: PageScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  itemCount: count,
                  itemBuilder:
                      (_, index) => //самое интересное, т.к. у нас тут неопределенное количество повторений может быть, мы вызываем метод подстановки и отрисовки всех элементов списка
                          EventCard(events: snapshot.data, i: index, favs: [],));
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
      getAllEventsState = getAllEvents().asStream();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("List Title ${count == null ? count = 0 : count} cards", style: TextStyle(fontSize: 25.0,)),
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
                  _ifNoData = Center(child: CircularProgressIndicator(),);
                });
                await refreshList();
                },
              child: Icon(Icons.refresh),
            )
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/add', ModalRoute.withName('/list_events')); //переход на экран добавления элемента
              },
            ),
    );
  }
}
