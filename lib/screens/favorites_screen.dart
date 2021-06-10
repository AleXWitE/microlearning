import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/components/event.dart';
import 'package:microlearning/components/list_card.dart';
import 'package:microlearning/components/users.dart';
import 'package:microlearning/db/moor_db.dart';
import 'package:microlearning/models/drawer_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    _getFavStream();
    // print(favEvent.length);
  }

  Widget _ifNoFavorite = Center(child: CircularProgressIndicator());
  bool _hasFav;

  Future<Null> ifNoFavorite(bool snapdata) async {
    if(snapdata == false){
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _ifNoFavorite = Center(
          child: Text(AppLocalizations.of(context).favWarning),
        );
      });
    }
  }

  _getFavStream() async {
    final _dao = Provider.of<FavorDao>(context, listen: false);
    return _favoritesList = _dao.watchAllFavorites();
  }

  getFavStream() async{
    await compute<dynamic, Stream<List<Favor>>>(_getFavStream(), null);
  }

  ListBuilder(Stream<List<Favor>> _check) {
    return StreamBuilder<List<Favor>>(
      stream: _check,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return ListView.builder(
            //возвращаем билд списка
              physics: PageScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 40),
              itemCount: snapshot.data.length,
              itemBuilder:
                  (_, index) => //самое интересное, т.к. у нас тут неопределенное количество повторений может быть, мы вызываем метод подстановки и отрисовки всех элементов списка
              EventCard(courses: [], i: index, favs: snapshot.data));
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
        for(int i = 0; i < event.length; i++){
          await _dao.deleteFavorite(event[i]);
          favorItem.clear();
        }
      });
      });
      _getFavStream();
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).favAlertInfo),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context).favAlertCancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context).favAlertDel),
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
      if (_favoritesList.isBroadcast) _notNull = true;
      else _notNull = false;
    });

    return Scaffold(
        appBar: AppBar(
          title: Text("${AppLocalizations.of(context).userFavoritesCourses} $userName", style: TextStyle(fontSize: 22.0,)),
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
                    child: Text(AppLocalizations.of(context).favWarning),
                  )
                : ListBuilder(_favoritesList)
            : !_notNull
                ? Row(
                    children: [
                      Container(width: 200, child: DrawerItem()),
                      Container(
                          width: MediaQuery.of(context).size.width - 200,
                          child: Center(
                            child: Text(AppLocalizations.of(context).favWarning),
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
