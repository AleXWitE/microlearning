import 'package:flutter/material.dart';
import 'package:microlearning/api/services/event_service.dart';
import 'package:microlearning/components/event.dart';
import 'package:microlearning/components/list_card.dart';
import 'package:microlearning/models/drawer_item.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoritesScreen> {
  int count;
  int len = favorites.length;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    didUpdateWidget(FavoritesScreen());

    return Scaffold(
      appBar: AppBar(
        title: Text("In favorite ${count == null ? count = 0 : count} cards"),
        centerTitle: true,
        backgroundColor: Colors.grey[700],
      ),
      drawer: DrawerItem(),
      body: favorites.isEmpty
          ? Center(
              child: Text("There is no favorite data!"),
            )
          : ListView.builder(
              //возвращаем билд списка
              physics: PageScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 40),
              itemCount: len,
              itemBuilder:
                  (BuildContext context, index) => //самое интересное, т.к. у нас тут неопределенное количество повторений может быть, мы вызываем метод подстановки и отрисовки всех элементов списка
                      EventCard(events: favorites, i: index)),
    );
  }
}
