import 'package:flutter/material.dart';
import 'package:microlearning/components/event.dart';
import 'package:microlearning/components/list_card.dart';
import 'package:microlearning/db/moor_db.dart';
import 'package:microlearning/models/drawer_item.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  FavoriteScreenState createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoritesScreen> {
  int count;
  Stream<List<Favor>> _favoritesList;


  @override
  void initState() {
    super.initState();
    // print(favEvent.length);
  }

  Widget _ifNoFavorite = Center(child: CircularProgressIndicator());
  bool _hasFav;

  Future<Null> ifNoFavorite(bool snapdata) async {
    if(snapdata == false){
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _ifNoFavorite = Center(
          child: Text("There is no favorite data!"),
        );
      });
    }
  }

  Widget ListBuilder(Stream<List<Favor>> _check) {
    final _dao = Provider.of<FavorDao>(context);

    return StreamBuilder<List<Favor>>(
      stream: _check,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          // return _builtFav(context, snapshot.data);
          return ListView.builder(
            //возвращаем билд списка
              physics: PageScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 40),
              itemCount: snapshot.data.length,
              itemBuilder:
                  (_, index) => //самое интересное, т.к. у нас тут неопределенное количество повторений может быть, мы вызываем метод подстановки и отрисовки всех элементов списка
              EventCard(events: [], i: index, favs: snapshot.data));
        } else {
          _hasFav = false;
          ifNoFavorite(_hasFav);
          return _ifNoFavorite;

        }
      },
    );
  }

  Future<void> _showDelDialog() async {
    final _dao = Provider.of<FavorDao>(context, listen: false);

    delFunc() {
      setState(() {
      _favoritesList.listen((event) async {
        for(int i = 0; i < event.length-1; i++){
          Favor checkFavorite = await _dao.getFavorite(event[i].id);
          if(checkFavorite != null) await _dao.deleteFavorite(checkFavorite);
        }
      });
      // favorItem.clear();
      });
    }

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
                Navigator.of(context).pop();
                delFunc();
                setState(() {
                  count = 0;
                  // favorItem.clear();
                });


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
    final _dao = Provider.of<FavorDao>(context);

    bool _notNull;

    setState(() {
      _favoritesList = _dao.watchAllFavorites();
      if (_favoritesList.isBroadcast) _notNull = true;
      else _notNull = false;
    });



    return Scaffold(
        appBar: AppBar(
          title: Text("In favorite ${count == null ? count = 0 : count} cards", style: TextStyle(fontSize: 25.0,)),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => _showDelDialog(),
                icon: Icon(Icons.delete_forever))
          ],
        ),
        drawer: MediaQuery.of(context).size.width > 600
            ? null
            : Drawer(
                child: DrawerItem(),
              ),
        //боковая менюшка
        body: MediaQuery.of(context).size.width < 600
            ? !_notNull
                ? Center(
                    child: Text("There is no favorite data!"),
                  )
                : ListBuilder(_favoritesList)
            : !_notNull
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
                        child: ListBuilder(_favoritesList),
                        width: MediaQuery.of(context).size.width - 200,
                      ),
                    ],
                  ),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.refresh),
      elevation: 10.0,
      onPressed: () {
        setState(() {
          _favoritesList = _dao.watchAllFavorites();
        });
      },
    ),);
  }
}
