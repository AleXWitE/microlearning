import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/api/services/event_service.dart';
import 'package:microlearning/components/event.dart';
import 'package:microlearning/components/list_card.dart';
import 'package:microlearning/models/drawer_item.dart';

class ListScreen extends StatefulWidget {
  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> with WidgetsBindingObserver {
  GlobalKey<RefreshIndicatorState> refreshKey;
  GlobalKey<RefreshIndicatorState> refreshKey2;
  Future
      getAllEventsState; //определяем переменную под будущий список элементов из интернета
  int count;
  int asyncCount;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
        this); //попытка добавления слушателя состояния, для работы с жизненным циклом виджетов
    refreshKey = GlobalKey<
        RefreshIndicatorState>(); //задача уникального ключа для виджета обновления спсика
    refreshKey2 = GlobalKey<
        RefreshIndicatorState>();
  }

  Future<Null> refreshList() async {
    //функция обновления списка
    await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      getAllEventsState = getAllEvents();
      ifNoData();
    });
    return null;
  }

  Widget _ifNoData = CircularProgressIndicator();

  Future<Null> ifNoData() async{
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      _ifNoData = Center(child: Text("Something wrong! Try check connection!"),);
    });
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
        getAllEventsState = getAllEvents();
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
        child: FutureBuilder<List<Event>>(
          future: getAllEventsState,
          builder: (context, snapshot) {
            // AppLifecycleState state;
            print(snapshot.hasData);
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
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
                          EventCard(events: snapshot.data, i: index));
            } else {
              ifNoData();
              return RefreshIndicator(
                //обновление списка
                  key: refreshKey2,
                  onRefresh: () async {
                    await refreshList();
                  },
              child: Center(
                  child:
                      _ifNoData //если данные еще не получены, то мы возвращаем значек загрузки
              )
              );}
          },
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (getAllEventsState == null) {
      //если мы первый раз запустили экран - получаем в первый раз данные из интернета
      getAllEventsState = getAllEvents();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("List Title $count cards"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      drawer: MediaQuery.of(context).size.width > 600
          ? null
          : Drawer(
              child: DrawerItem(),
            ), //боковая менюшка
      body: SafeArea(
        child: MediaQuery.of(context).size.width < 600 //обратить внимание на эту строку когдавсе починю
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
      floatingActionButton: FloatingActionButton(
        child: Text("Add"),
        backgroundColor: Colors.grey[900],
        onPressed: () {
          Navigator.pushNamed(
              context, '/add'); //переход на экран добавления элемента
        },
      ),
    );
  }
}
