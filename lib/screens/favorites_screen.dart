import 'package:flutter/material.dart';
import 'package:microlearning/api/services/event_service.dart';
import 'package:microlearning/components/event.dart';
import 'package:microlearning/components/list_card.dart';
import 'package:microlearning/models/drawer_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:microlearning/db/shared_preferences.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

Future initFav() async {
  return favorites;
}

class FavoriteScreenState extends State<FavoritesScreen> {
  int count;
  int len = favorites.length;

  @override
  void initState() {
    super.initState();
    // _favorites = _prefs.then((SharedPreferences prefs) {
    //   return (prefs.getStringList('favorites') ?? 0);
  // });
  }

  Widget _builtFav(BuildContext context, AsyncSnapshot snapshot) {
    initFav();
    return ListView.builder(
        //возвращаем билд списка
        physics: PageScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 40),
        itemCount: snapshot.data.length,
        itemBuilder:
            (_, index) => //самое интересное, т.к. у нас тут неопределенное количество повторений может быть, мы вызываем метод подстановки и отрисовки всех элементов списка
                EventCard(events: snapshot.data, i: index));
  }

  Widget ListBuilder() {
    return FutureBuilder(
      future: initFav(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return _builtFav(context, snapshot);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<void> _showDelDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want delete all favorites?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                // await prefs.clear();
                Navigator.of(context).pop();
                print('delete');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("In favorite ${count == null ? count = 0 : count} cards"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => _showDelDialog(),
                icon: Icon(Icons.delete_forever))
          ],
          backgroundColor: Colors.grey[700],
        ),
        drawer: MediaQuery.of(context).size.width > 600
            ? null
            : Drawer(
                child: DrawerItem(),
              ),
        //боковая менюшка
        body: MediaQuery.of(context).size.width < 600
            ? favorites.isEmpty
                ? Center(
                    child: Text("There is no favorite data!"),
                  )
                : ListBuilder()
            : favorites.isEmpty
                ? Row(
                    children: [
                      Container(width: 200, child: DrawerItem()),
                      Container(
                          width: MediaQuery.of(context).size.width - 200,
                          child: Center(
                            child: Text("There is no favorite data!"),
                          ))
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        child: DrawerItem(),
                        width: 200,
                      ),
                      Container(
                        child: ListBuilder(),
                        width: MediaQuery.of(context).size.width - 200,
                      ),
                    ],
                  ));
  }
}
