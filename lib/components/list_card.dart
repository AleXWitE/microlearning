import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:microlearning/components/users.dart';
import 'package:microlearning/db/moor_db.dart';
import 'package:provider/provider.dart';

import 'event.dart';

class EventCard extends StatefulWidget {
  //здесь мы получаем элемент списка чтобы нарисовать карточку для конкретнного элемента
  final List<Courses> courses;
  final List<Favor> favs;
  final int i;

  EventCard({Key key, this.courses, this.i, this.favs}) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  void initState() {
    super.initState();
    print("${widget.courses.length}\n"); //вывод в консоли количество элементов
    print("${widget.favs.length}"); //вывод в консоли количество элементов
  }

  bool _isEnabled = true;
  bool _isFavorite;

  @override
  Widget build(BuildContext context) {
    final _dao = Provider.of<FavorDao>(context);

    bool _fav;

    var element;
    var elId;
    if (widget.courses.isEmpty && widget.favs.isNotEmpty) {
      element = widget.favs[widget.i] as Favor;
      elId = element.courseId.toString();
      _fav = true;
    } else {
      element = widget.courses[widget.i] as Courses;
      elId = element.id.toString();
      _fav = false;
    }

    Stream<List<Favor>> eventFav = _dao.watchAllFavorites();

    eventFav.listen((event) {
      setState(() {
        for (int i = 0; i < event.length - 1; i++) {
          favorItem.add(FavorItem(courseId: event[i].courseId, favorite: true));
        }
      });
    });

    var _favItem = favorItem.where((item) =>
        item.courseId == element.id ||
        item.id == elId ||
        element.favorite == true);

    setState(() {
      switch (_favItem.isEmpty) {
        case true:
          _isFavorite = false;
          break;
        case false:
          _isFavorite = true;
          break;
        default:
          _isFavorite = false;
      }
    });

    insertData(Courses courses/*Answers answ*/) {
      _dao.insertNewFavorite(Favor(
          courseId: courses.id,
          title: courses.course,
          /*cardCourseId: answ.courseId,
          cardTitle: answ.title,
          cardQuestion: answ.description,
          cardType: answ.type,
          cardAnswer1: answ.answer1,
          cardAnswer2: answ.answer2,
          cardAnswer3: answ.answer3,
          cardAnswerCorrect: answ.answerCorrect,
          cardUrl: answ.url,*/
          favorite: true));
      favorItem.add(FavorItem(courseId: element.id, favorite: true));
      _isFavorite = true;
    }

    deleteData(int _id) async {
      Favor checkFavorite = await _dao.getFavorite(_id);
      if (checkFavorite != null) _dao.deleteFavorite(checkFavorite);
      favorItem
          .removeAt(favorItem.indexWhere((el) => el.courseId == element.id));
    }

    _Card() {
        return Card(
          elevation: 15.0,
          margin: EdgeInsets.symmetric(vertical: 20),
          child: ListTile(
            onTap: () {
              Navigator.pushNamed(
                context,
                widget.courses.isEmpty
                    ? '/course/${element.courseId}'
                    : '/course/${element.course}',
              );
            },
            // generate route for item card
            enabled: _isEnabled,
            title: Text(
              _fav ? element.title : element.course,
              // element.course,
              style: TextStyle(fontSize: 20),
            ),
            // subtitle: Text("${element.location} \n${element.date.toString()}"),
            leading: IconButton(
              icon:
                  _isEnabled ? Icon(Icons.lock_outlined) : Icon(Icons.lock_open),
              onPressed: () => setState(
                () => _isEnabled = !_isEnabled,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                //задаем смену сердечек от параметра _isFavorite
                size: 40,
                // color: Colors.indigo,
              ),
              onPressed: () {
                setState(() {
                  _isFavorite ? deleteData(int.parse(elId)) : insertData(element);
                  _isFavorite = !_isFavorite;
                });
              },
            ),
          ),
      );
    }

    return /*_fav
        ? Dismissible(
            child: _Card(),
            key: ValueKey<int>(elId),
            background: Container(
              color: Colors.red,
            ),
            onDismissed: (DismissDirection direction) {
              setState(() {
                deleteData(elId);
              });
            },
          )
        : */_Card();
  }
}
