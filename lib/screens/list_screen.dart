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
  Future getAllEventsState;//определяем переменную под будущий список элементов из интернета
  int count;
  int asyncCount;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);//попытка добавления слушателя состояния, для работы с жизненным циклом виджетов
    refreshKey = GlobalKey<RefreshIndicatorState>(); //задача уникального ключа для виджета обновления спсика
  }

  Future<Null> refreshList() async { //функция обновления списка
    await Future.delayed(Duration(milliseconds: 200));
    setState(() {
      getAllEventsState = getAllEvents();
    });
    return null;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) { //не работает(((
    if (state == AppLifecycleState.resumed) {
      setState(() {
        getAllEventsState = getAllEvents();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (getAllEventsState == null) { //если мы первый раз запустили экран - получаем в первый раз данные из интернета
      getAllEventsState = getAllEvents();
    }

    count = asyncCount;

    return Scaffold(
      appBar: AppBar(
        title: Text("List Title $count cards"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      drawer: DrawerItem(),
      body: RefreshIndicator(//обновление списка
          key: refreshKey,
          onRefresh: () async {
            await refreshList();
          },
          child: FutureBuilder<List<Event>>(
            future: getAllEventsState,
            builder: (context, snapshot) {
              // AppLifecycleState state;
              if (snapshot.connectionState == ConnectionState.done) {
                asyncCount = snapshot.data.length;
                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return ListView.builder( //возвращаем билд списка
                    physics: PageScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) =>  //самое интересное, т.к. у нас тут неопределенное количество повторений может быть, мы вызываем метод подстановки и отрисовки всех элементов списка
                        EventCard(events: snapshot.data, i: index));
              } else {
                return Center(child: CircularProgressIndicator()); //если данные еще не получены, то мы возвращаем значек загрузки
              }
            },
          )),
      floatingActionButton: FloatingActionButton(
        child: Text("Add"),
        backgroundColor: Colors.grey[900],
        onPressed: () {
          Navigator.pushNamed(context, '/add'); //переход на экран добавления элемента
        },
      ),
    );
  }
}
